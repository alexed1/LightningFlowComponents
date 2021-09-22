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
            	ContentDocumentId = vers.ContentDocumentId,
            	LinkedEntityId = decrypt(vers.Guest_Record_fileupload__c, encodedKey)
        	);
            links.add(link);
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
}