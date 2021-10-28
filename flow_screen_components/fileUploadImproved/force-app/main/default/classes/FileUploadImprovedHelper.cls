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
    public static void createContentDocLink(List<String> versIds, String encodedKey, Boolean visibleToAllUsers){
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        for(ContentVersion vers : [SELECT Id, ContentDocumentId, Guest_Record_fileupload__c FROM ContentVersion WHERE Id IN :versIds]){
            ContentDocumentLink link = new ContentDocumentLink(
            	ContentDocumentId = vers.ContentDocumentId,
                LinkedEntityId = decrypt(vers.Guest_Record_fileupload__c, encodedKey)
        	);
            if(visibleToAllUsers != null){
                if(visibleToAllUsers){
                    link.Visibility = 'AllUsers';
                }
            }
            links.add(link);
        }
        if(!links.isEmpty()){
            insert links;
        }
    }

    @AuraEnabled
    public static void updateFileName(List<String> versIds, String fileName){
        List<ContentDocument> docs = new List<ContentDocument>();
        for(ContentVersion vers : [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentVersion WHERE Id IN :versIds]){
            if(vers.ContentDocument.Title != fileName){
                ContentDocument doc = new ContentDocument(
                    Id = vers.ContentDocumentId,
                    Title = fileName
                );
                docs.add(doc);
            }
        }
        if(!docs.isEmpty()){
            update docs;
        }
    }

    @AuraEnabled
    public static void deleteContentDoc(String versId){
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :versId LIMIT 1];
        ContentDocument cd = new ContentDocument(Id=cv.ContentDocumentId);
        delete cd;
    }

   @AuraEnabled
    public static List<objFiles> getExistingFiles(String recordId){
        Boolean isStandardUser = UserInfo.getUserType() == 'Standard';
        Map<Id,objFiles> objFiles = new Map<Id,objFiles>();
        for(ContentDocumentLink link : [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :recordId]){
            objFiles files = new objFiles();
            files.name = link.ContentDocument.Title +'.'+ link.ContentDocument.FileExtension;
            if(isStandardUser){
                files.documentId = link.ContentDocumentId;
            }
            objFiles.put(link.ContentDocumentId,files);
        }
        for(ContentVersion vers : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :objFiles.keyset()]){
            objFiles.get(vers.ContentDocumentId).contentVersionId = vers.Id;
        }
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

    private static String decrypt(String encodedValue, String encodedKey){
        Blob key = EncodingUtil.base64Decode(encodedKey);
        Blob value = EncodingUtil.base64Decode(encodedValue);
    	Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', key, value);
    	String recordId = decryptedBlob.toString();
        return recordId;
    }
}