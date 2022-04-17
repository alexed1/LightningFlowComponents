//This generates test data in the format used by the MetadataService in FlowBaseComponents
public with sharing class Fixture_TestPermSet_MetadataService {
    public static usf3.MetadataService.PermissionSet testPermSetM1() {
        usf3.MetadataService.PermissionSet permSetM1 = new usf3.MetadataService.PermissionSet();
        permSetM1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return permSetM1;
    }

    public static List<usf3.MetadataService.PermissionSetRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<usf3.MetadataService.PermissionSetRecordTypeVisibility> recordTypeVisibilities = new List<usf3.MetadataService.PermissionSetRecordTypeVisibility>();

        usf3.MetadataService.PermissionSetRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //usf3.MetadataService.PermissionSetRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        usf3.MetadataService.PermissionSetRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static usf3.MetadataService.PermissionSetRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        usf3.MetadataService.PermissionSetRecordTypeVisibility curRT = new usf3.MetadataService.PermissionSetRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}
