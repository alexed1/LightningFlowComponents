//This generates test data in the format used by the MetadataService in FlowBaseComponents
public with sharing class Fixture_TestPermSet_MetadataService {
    public static usf.MetadataService.PermissionSet testPermSetM1() {
        usf.MetadataService.PermissionSet permSetM1 = new usf.MetadataService.PermissionSet();
        permSetM1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return permSetM1;
    }

    public static List<usf.MetadataService.PermissionSetRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<usf.MetadataService.PermissionSetRecordTypeVisibility> recordTypeVisibilities = new List<usf.MetadataService.PermissionSetRecordTypeVisibility>();

        usf.MetadataService.PermissionSetRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //usf.MetadataService.PermissionSetRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        usf.MetadataService.PermissionSetRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static usf.MetadataService.PermissionSetRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        usf.MetadataService.PermissionSetRecordTypeVisibility curRT = new usf.MetadataService.PermissionSetRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}
