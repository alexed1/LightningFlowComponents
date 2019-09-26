global with sharing class AdminTools {
    global static String objectTypeFromId(Id recordId) {
        Schema.SObjectType token = recordId.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();
        return dr.getName();
    }


    private static boolean isStandard(String sobj) {
        if (sobj == 'Account' || sobj == 'Asset' || sobj == 'Campaign' || sobj == 'Case' || sobj == 'Contact' || sobj == 'Lead' || sobj == 'Opportunity' || sobj == 'User') {
            return true;
        }
        return false;
    }

    @TestVisible
    public static String getLookupField(String sobj) {
        if (isStandard(sobj)) {
            return sobj + 'Id';
        } else {
            return 'ParentId';
        }
    }

    @TestVisible
    public static String getAccessLevelField(String sobj) {
        System.debug('accesslevelField received sobject type :' + sobj);
        if (isStandard(sobj)) {
            System.debug('is a special object');
            return sobj + 'AccessLevel';
        } else {
            System.debug('is not a special object');
            return 'AccessLevel';
        }
    }
}