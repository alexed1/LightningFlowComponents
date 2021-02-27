Global class SlackChannel {
	@AuraEnabled 
    global String Name;
    
	@AuraEnabled
    global String Id;
    
	@AuraEnabled 
    global Boolean IsPrivate;
    
	@AuraEnabled 
    global String Topic;
    
	@AuraEnabled 
    global String Purpose;
    
	@AuraEnabled 
    global Integer NumberOfMembers;
    
}