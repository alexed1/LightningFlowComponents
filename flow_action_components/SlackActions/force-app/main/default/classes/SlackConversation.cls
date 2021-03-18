global  inherited sharing class SlackConversation {
	@AuraEnabled 
    global String name;
    
	@AuraEnabled
    global String id;
    
	@AuraEnabled 
    global Boolean isPrivate;

    @AuraEnabled 
    global Boolean isGeneral;
    @AuraEnabled 
    global Boolean isShared;
    @AuraEnabled 
    global Boolean isGroup;
    @AuraEnabled 
    global Boolean isArchived;
    @AuraEnabled 
    global Integer createTime;
    @AuraEnabled 
    global String createdBy;
	@AuraEnabled 
    global String topic;
    
	@AuraEnabled 
    global String purpose;
    
	@AuraEnabled 
    global Integer numberOfMembers;
}
