public without sharing class FileUploadImprovedHelper{
    
    @AuraEnabled(cacheable = true)
    public static String getKey(){
        Blob key = Crypto.generateAesKey(256);
        String encodedKey = EncodingUtil.base64Encode(key);
        return encodedKey;
    }
    
    @AuraEnabled(cacheable = true)
    public static String encrypt(String recordId, String encodedKey){
        Blob key = EncodingUtil.base64Decode(encodedKey);
        Blob value = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(recordId));
        String encodedValue = EncodingUtil.base64Encode(value);
        return encodedValue;
    }
    
    @AuraEnabled
    public static void createContentDocLink(List<String> versIds, String encodedKey){
        List<ContentVersion> versions = [SELECT Id, ContentDocumentId, Guest_Record_fileupload__c
                                   		 FROM ContentVersion
                                   		 WHERE Id IN :versIds];
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        for(ContentVersion vers : versions){
            ContentDocumentLink link = new ContentDocumentLink(
            	ContentDocumentId = vers.ContentDocumentId
        	);
            try{
                link.LinkedEntityId = decrypt(vers.Guest_Record_fileupload__c, encodedKey);
                links.add(link);
            }catch(Exception e){
                system.debug(e);
            }
        }
        database.insert(links, false);
    }

    @AuraEnabled
    public static void deleteContentDoc(String versId){
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :versId LIMIT 1];
        ContentDocument cd = new ContentDocument(Id=cv.ContentDocumentId);
        delete cd;
    }
    
    private static String decrypt(String encodedValue, String encodedKey){
        Blob key = EncodingUtil.base64Decode(encodedKey);
        Blob value = EncodingUtil.base64Decode(encodedValue);
    	Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', key, value);
    	String recordId = decryptedBlob.toString();
        return recordId;
    }

   @AuraEnabled(cacheable = true)
    public static List<objFiles> getExistingFiles(String recordId){
        system.debug(recordId);
        Map<Id,objFiles> objFiles = new Map<Id,objFiles>();
        for(ContentDocumentLink link : [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :recordId]){
            objFiles files = new objFiles();
            files.name = link.ContentDocument.Title +'.'+ link.ContentDocument.FileExtension;
            files.documentId = link.ContentDocumentId;
            system.debug(files);
            objFiles.put(files.documentId,files);
        }
        for(ContentDocument doc : [SELECT Id, (SELECT Id FROM ContentVersions WHERE IsLatest = TRUE) FROM ContentDocument WHERE Id IN :objFiles.keyset()]){
            objFiles.get(doc.Id).contentVersionId = doc.ContentVersions[0].Id;
        }
        system.debug(objFiles);
        system.debug(objFiles.values());
        return objFiles.values();
    }

    public class objFiles{
        @AuraEnabled
        public string name;

        @AuraEnabled
        public string documentId;

        @AuraEnabled
        public string contentVersionId;
    }
}