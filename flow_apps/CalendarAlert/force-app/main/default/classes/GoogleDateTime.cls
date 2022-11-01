public with sharing class GoogleDateTime {
    public GoogleDateTime() {

    }
    @AuraEnabled
    public String startTime {get;set;}

    @AuraEnabled
    public String timeZone {get;set;}

}
