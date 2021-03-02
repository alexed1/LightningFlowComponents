public with sharing class Fixture_TestProfile_MetadataService {
//This generates test data in the format used by the MetadataService in FlowBaseComponents
    public static usf.MetadataService.Profile testProfileP1() {
        usf.MetadataService.Profile profileP1 = new usf.MetadataService.Profile();
        profileP1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return profileP1;
    }

    public static List<usf.MetadataService.ProfileRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<usf.MetadataService.ProfileRecordTypeVisibility> recordTypeVisibilities = new List<usf.MetadataService.ProfileRecordTypeVisibility>();

        usf.MetadataService.ProfileRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //usf.MetadataService.ProfileRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        usf.MetadataService.ProfileRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static usf.MetadataService.ProfileRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        usf.MetadataService.ProfileRecordTypeVisibility curRT = new usf.MetadataService.ProfileRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}