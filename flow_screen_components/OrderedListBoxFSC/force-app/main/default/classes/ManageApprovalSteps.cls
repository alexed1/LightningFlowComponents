global with sharing class ManageApprovalSteps {

    @AuraEnabled(cacheable=true)
    public static List<Member> getApprovalProcessSteps(Id approvalProcessId) {
        List<ApprovalProcessStepDefinition__c> steps = [SELECT Id, Name FROM ApprovalProcessStepDefinition__c WHERE ApprovalProcessDefinition__c = :approvalProcessId ORDER BY Order__c ASC];
        List<Member> members = new List<Member>();
        for (ApprovalProcessStepDefinition__c step : steps) {
            members.add(new Member(step.Name, step.Id));
        }

        return members;
    }

    @AuraEnabled
    public static void saveApprovalSteps(List<ApprovalProcessStepDefinition__c> appSteps) {
        update appSteps;
    }

    global class Member {
        @AuraEnabled global String label;
        @AuraEnabled global String value;
        public Member(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}