
//this generates permission set data in the ApexType (aka flowDMC) style used by Flow Actions
public with sharing class Fixture_TestPermissionSet_ApexType {
    

    public static flowDMC_PermissionSet testPermSet1() {
        flowDMC_PermissionSet permSet1 = new flowDMC_PermissionSet();
        permSet1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return permSet1;
    }

    public static flowDMC_PermissionSet testPermSet2() {
        flowDMC_PermissionSet permSet2 = new flowDMC_PermissionSet();
        permSet2.recordTypeVisibilities = generateCollectionRecordTypeVisibilities2();
        return permSet2;
    }

    public static List<flowDMC_PermSetRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<flowDMC_PermSetRecordTypeVisibility> recordTypeVisibilities = new List<flowDMC_PermSetRecordTypeVisibility>();

        flowDMC_PermSetRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //flowDMC_PermSetRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2'); false values aren't stored. so it was wrong to create this here
        flowDMC_PermSetRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static List<flowDMC_PermSetRecordTypeVisibility> generateCollectionRecordTypeVisibilities2 () {
        List<flowDMC_PermSetRecordTypeVisibility> recordTypeVisibilities = new List<flowDMC_PermSetRecordTypeVisibility>();

        flowDMC_PermSetRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        flowDMC_PermSetRecordTypeVisibility recordType2 = generateRecordTypeVisibility(true, 'Account.AccountRT2'); 

        recordTypeVisibilities.add(recordType1);
        recordTypeVisibilities.add(recordType2);
        
        return recordTypeVisibilities;

    }

    public static flowDMC_PermSetRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        flowDMC_PermSetRecordTypeVisibility curRT = new flowDMC_PermSetRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }

}
