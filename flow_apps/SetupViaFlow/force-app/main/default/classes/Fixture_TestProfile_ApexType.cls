public with sharing class Fixture_TestProfile_ApexType {

//this generates permission set data in the ApexType (aka flowDMC) style used by Flow Actions

    public static flowDMC_Profile testProfile1() {
        flowDMC_Profile profile1 = new flowDMC_Profile();
        profile1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return profile1;
    }

    public static flowDMC_Profile testProfile2() {
        flowDMC_Profile profile2 = new flowDMC_Profile();
        profile2.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return profile2;
    }

    public static List<flowDMC_ProfileRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<flowDMC_ProfileRecordTypeVisibility> recordTypeVisibilities = new List<flowDMC_ProfileRecordTypeVisibility>();

        flowDMC_ProfileRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1', true);
        flowDMC_ProfileRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2', false);
        flowDMC_ProfileRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3', false);

        recordTypeVisibilities.add(recordType1);
        recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static List<flowDMC_ProfileRecordTypeVisibility> generateCollectionRecordTypeVisibilities2 () {
        List<flowDMC_ProfileRecordTypeVisibility> recordTypeVisibilities = new List<flowDMC_ProfileRecordTypeVisibility>();

        flowDMC_ProfileRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1', true);
        flowDMC_ProfileRecordTypeVisibility recordType2 = generateRecordTypeVisibility(true, 'Account.AccountRT2', false);
        flowDMC_ProfileRecordTypeVisibility recordType3 = generateRecordTypeVisibility(false, 'Account.AccountRT3', false);

        recordTypeVisibilities.add(recordType1);
        recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static flowDMC_ProfileRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType, Boolean isDefault) {
        flowDMC_ProfileRecordTypeVisibility curRT = new flowDMC_ProfileRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        if(isDefault == true) {
            curRT.default_x = true;
        } else {
            curRT.default_x = false;
        }
        curRT.personAccountDefault = false;
        return curRT;

    }

}