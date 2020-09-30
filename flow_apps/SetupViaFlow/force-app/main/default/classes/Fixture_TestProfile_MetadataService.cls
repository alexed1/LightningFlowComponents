public with sharing class Fixture_TestProfile_MetadataService {
//This generates test data in the format used by the MetadataService in FlowBaseComponents
    public static fbc_MetadataService.Profile testProfileP1() {
        fbc_MetadataService.Profile profileP1 = new fbc_MetadataService.Profile();
        profileP1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return profileP1;
    }

    public static List<fbc_MetadataService.ProfileRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<fbc_MetadataService.ProfileRecordTypeVisibility> recordTypeVisibilities = new List<fbc_MetadataService.ProfileRecordTypeVisibility>();

        fbc_MetadataService.ProfileRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //fbc_MetadataService.ProfileRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        fbc_MetadataService.ProfileRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static fbc_MetadataService.ProfileRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        fbc_MetadataService.ProfileRecordTypeVisibility curRT = new fbc_MetadataService.ProfileRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}