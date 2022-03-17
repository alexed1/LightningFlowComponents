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
    public static List<objFiles> createContentVers(List<String> fileNames, String encodedRecordId){
        List<ContentVersion> versions = new List<ContentVersion>();
        for(String fileName : fileNames){
            Integer startOfExtension = fileName.lastIndexOf('.');
            ContentVersion version = new ContentVersion(
                Title = fileName.Substring(0,startOfExtension),
                PathOnClient = '/'+fileName,
                VersionData = Blob.valueOf(' '),
                IsMajorVersion = FALSE,
                Guest_Record_fileupload__c = encodedRecordId
            );
            versions.add(version);
        }

        List<Database.SaveResult> results = Database.insert(versions);

        List<Id> versionIds = new List<Id>();
        for(Database.SaveResult result : results){
            versionIds.add(result.getId());
        }

        Boolean isStandardUser = UserInfo.getUserType() == 'Standard';
        List<objFiles> objFiles = new List<objFiles>();
        for(ContentVersion version : [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentVersion WHERE Id IN :versionIds ORDER BY Id]){
            objFiles objFile = new objFiles();
            objFile.name = version.ContentDocument.Title +'.'+ version.ContentDocument.FileExtension;
            objFile.contentVersionId = version.Id;

            if(isStandardUser){
                objFile.documentId = version.ContentDocumentId;
            }
            
            objFiles.add(objFile);
        }

        return objFiles;
    }

    @AuraEnabled 
    public static void appendDataToContentVersion(String versionId, String base64Data){
        ContentVersion vers = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :versionId];
        String existingVersionData = EncodingUtil.base64Encode(vers.VersionData);
        if(existingVersionData == 'IA=='){
            vers.VersionData = EncodingUtil.base64Decode(base64Data);
        } else {
            vers.VersionData = EncodingUtil.base64Decode(existingVersionData + base64Data);
        }
        update vers;
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
        for(ContentVersion vers : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :objFiles.keyset() AND IsLatest = TRUE]){
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

    @InvocableMethod(
        label='Create Content Document Links Downstream'
        description='Sometimes when using File Upload Improved you don\'t know the Related Record Id until after your user has already uploaded files. Use this Invocable Method to create the Content Document Links downstream in your flow.'
        category='File Upload Improved'
    )
    public static void createContentDocumentLinkDownstream(List<Input> inputs){
        Set<Id> setContentVersIds = new Set<Id>();
        for(Input input : inputs){
            setContentVersIds.addAll(input.versIds);
        }
        setContentVersIds.remove(null);
        if(!setContentVersIds.isEmpty()){
            Map<Id,Id> mapVersIdToDocId = new Map<Id,Id>();
            for(ContentVersion vers : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :setContentVersIds]){
                mapVersIdToDocId.put(vers.Id,vers.ContentDocumentId);
            }
            Map<Id,Set<Id>> mapDocIdToRecordIds = new Map<Id,Set<Id>>();
            for(ContentDocumentLink doc : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :mapVersIdToDocId.values()]){
                Id docId = doc.ContentDocumentId;
                Id recordId = doc.LinkedEntityId;
                if(mapDocIdToRecordIds.get(docId) == null){
                    mapDocIdToRecordIds.put(docId,new Set<Id>());
                }
                mapDocIdToRecordIds.get(docId).add(recordId);
            }
            List<ContentDocumentLink> links = new List<ContentDocumentLink>();
            for(Input input : inputs){
                Id recordId = input.recordId;
                Boolean visibleToAllUsers = input.visibleToAllUsers == null ? FALSE : input.visibleToAllUsers;
                for(Id versId : input.versIds){
                    Id docId = mapVersIdToDocId.get(versId);
                    if(docId != null){
                        if(mapDocIdToRecordIds.get(docId).contains(recordId)){
                            continue;
                        } else {
                            ContentDocumentLink link = new ContentDocumentLink(
                                ContentDocumentId = docId,
                                LinkedEntityId = recordId
                            );
                            if(visibleToAllUsers){
                                link.Visibility = 'AllUsers';
                            }
                            links.add(link);
                        }
                    }
                }
            }
            if(!links.isEmpty()){
                insert links;
            }
        } else {
            return;
        }
        
    }

    public class Input{
        @InvocableVariable(
            label='Collection of Content Version Ids'
            required=true
        )
        public List<Id> versIds;

        @InvocableVariable(
            label='Related Record Id'
            required=true
        )
        public Id recordId;

        @InvocableVariable(
            label='Visible to All Users?'
        )
        public Boolean visibleToAllUsers;
    }

    private static String decrypt(String encodedValue, String encodedKey){
        Blob key = EncodingUtil.base64Decode(encodedKey);
        Blob value = EncodingUtil.base64Decode(encodedValue);
    	Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', key, value);
    	String recordId = decryptedBlob.toString();
        return recordId;
    }
}