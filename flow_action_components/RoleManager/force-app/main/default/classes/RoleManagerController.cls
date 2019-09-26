global with sharing class RoleManagerController {

    @AuraEnabled
    global static String handleButtonAction(String buttonName, String managerName, String paramsString) {

        return getRoleManagerProvider(managerName).execute(buttonName, paramsString);
    }

    @AuraEnabled(cacheable=true)
    global static List<MemberInfo> getExistingMembers(String managerName, String recordId) {

        return getRoleManagerProvider(managerName).getExisting(recordId);
    }

    @AuraEnabled(cacheable=true)
    global static String getSupportedButtons(String managerName, String recordId) {

        return JSON.serialize(getRoleManagerProvider(managerName).getSupportedButtons(recordId));
    }

    private static RoleManagerProvider getRoleManagerProvider(String managerName) {

        try {
            RoleManagerProvider sm = (RoleManagerProvider) Type.forName(managerName).newInstance();
            return sm;
        } catch (Exception ex) {
            throw getAuraException('Manager "' + managerName + '" is not found');
        }
    }

    global class ButtonSetting {

        @AuraEnabled global String name;
        @AuraEnabled global ButtonMatchingRule matchingRule;
        public ButtonSetting(String name, ButtonMatchingRule matchingRule) {
            this.name = name;
            this.matchingRule = matchingRule;
        }
    }
    global class MemberInfo {

        @AuraEnabled global Id memberId;
        @AuraEnabled global String recordId;
        @AuraEnabled global String name;
        @AuraEnabled global String label;
        @AuraEnabled global SObject record;
        public MemberInfo(Id memberId, String recordId, String name, String label, SObject record) {
            this.memberId = memberId;
            this.recordId = recordId;
            this.name = name;
            this.label = label;
            this.record = record;
        }
    }

    global enum MatchingAction {
        ANYEXISTS, EXISTS, NOTEXISTS, VALUEEQUALS, SUPPORTED
    }

    global class ButtonMatchingRule {

        @AuraEnabled global MatchingAction matchingAction;
        @AuraEnabled global Map<String, List<String>> disabledValues;
        public ButtonMatchingRule(MatchingAction matchingAction, Map<String, List<String>> disabledValues) {
            this.matchingAction = matchingAction;
            this.disabledValues = disabledValues;
        }
        public ButtonMatchingRule(MatchingAction matchingAction) {
            this.matchingAction = matchingAction;
        }
    }

    private static AuraHandledException getAuraException(String errorMessage) {
        AuraHandledException e = new AuraHandledException(errorMessage);
        e.setMessage(errorMessage);
        return e;
    }
}