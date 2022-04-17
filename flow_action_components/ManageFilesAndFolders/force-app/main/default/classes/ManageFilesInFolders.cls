global with sharing class ManageFilesInFolders {

        @InvocableMethod
        global static List <Results> execute(List<Requests> requestList) {
            List<Results> resultsList = new List<Results>();
            System.debug('requestList is: ' + requestList);
            for (Requests curRequest : requestList) {
                Results response = new Results();
                System.debug('actiontype is: ' + curRequest.actionType);
                switch on curRequest.actionType {
                    when 'add' {
                        System.debug('entering add');
                        List<ContentFolderMember> newCFMList = new List<ContentFolderMember>();
                        for (ContentDocument curDoc : curRequest.selectedContentDocuments){
                            for (ContentFolder curFolder : curRequest.selectedContentFolders) {
                                ContentFolderMember newCFM = new ContentFolderMember(
                                    ChildRecordId = curDoc.Id,
                                    ParentContentFolderId = curFolder.Id
                                );
                                newCFMList.add(newCFM);
                            }
                        }
                        insert newCFMList;
                        response.curContentFolderMembers = newCFMList;
                        System.debug('curCFM on add are: ' + response.curContentFolderMembers);
                        response.isSuccess = true;

                    }

                } 
                //todo: what happens if the cfm's already exist? 
                //response.fields = describeSObject(requestList[0].objectName);

                resultsList.add(response);
            }

            return resultsList;
    
        }
    
        
    
        global class Requests {
    
            @InvocableVariable(required=true)
            global String actionType;

            @InvocableVariable 
            global List<ContentDocument> selectedContentDocuments;

            @InvocableVariable 
            global List<ContentFolder> selectedContentFolders;

        }
    
        global class Results {
    
            @InvocableVariable
            global List<ContentFolderMember> curContentFolderMembers;

            @InvocableVariable
            global boolean isSuccess;

            @InvocableVariable
            global string resultsLog;
            
        }
    }