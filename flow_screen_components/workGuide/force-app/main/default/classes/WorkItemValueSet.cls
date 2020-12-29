global  with sharing class WorkItemValueSet {

    @AuraEnabled
    global  List<String> workItemLabels;

    @AuraEnabled
    global  List<String> workItemRecordIds;

    global WorkItemValueSet() {
        workItemLabels = new List<String>();
        workItemRecordIds = new List<String>();
    }
}