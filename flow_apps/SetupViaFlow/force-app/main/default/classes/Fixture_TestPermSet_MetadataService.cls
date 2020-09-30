//This generates test data in the format used by the MetadataService in FlowBaseComponents
public with sharing class Fixture_TestPermSet_MetadataService {
    public static fbc_MetadataService.PermissionSet testPermSetM1() {
        fbc_MetadataService.PermissionSet permSetM1 = new fbc_MetadataService.PermissionSet();
        permSetM1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return permSetM1;
    }

    public static List<fbc_MetadataService.PermissionSetRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<fbc_MetadataService.PermissionSetRecordTypeVisibility> recordTypeVisibilities = new List<fbc_MetadataService.PermissionSetRecordTypeVisibility>();

        fbc_MetadataService.PermissionSetRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //fbc_MetadataService.PermissionSetRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        fbc_MetadataService.PermissionSetRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static fbc_MetadataService.PermissionSetRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        fbc_MetadataService.PermissionSetRecordTypeVisibility curRT = new fbc_MetadataService.PermissionSetRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}
