public with sharing class GoogleCalendarEventSet {
  
    @AuraEnabled
	public String kind {get;set;} 
    @AuraEnabled
	public String etag {get;set;} 
    @AuraEnabled
	public String summary {get;set;} 
    @AuraEnabled
	public String updated {get;set;} 
    @AuraEnabled
	public String timeZone {get;set;} 
    @AuraEnabled
	public String accessRole {get;set;} 
    @AuraEnabled
	public List<GoogleDefaultReminders> defaultReminders {get;set;} 
    @AuraEnabled
	public String nextPageToken {get;set;} 
    @AuraEnabled
	public List<GoogleCalendarEvent> items {get;set;} 

}
