public with sharing class Fixture_TestProfile_MetadataService {
//This generates test data in the format used by the MetadataService in FlowBaseComponents
    public static usf3.MetadataService.Profile testProfileP1() {
        usf3.MetadataService.Profile profileP1 = new usf3.MetadataService.Profile();
        profileP1.recordTypeVisibilities = generateCollectionRecordTypeVisibilities();
        return profileP1;
    }

    public static List<usf3.MetadataService.ProfileRecordTypeVisibility> generateCollectionRecordTypeVisibilities () {
        List<usf3.MetadataService.ProfileRecordTypeVisibility> recordTypeVisibilities = new List<usf3.MetadataService.ProfileRecordTypeVisibility>();

        usf3.MetadataService.ProfileRecordTypeVisibility recordType1 = generateRecordTypeVisibility(true, 'Account.AccountRT1');
        //usf3.MetadataService.ProfileRecordTypeVisibility recordType2 = generateRecordTypeVisibility(false, 'Account.AccountRT2');
        usf3.MetadataService.ProfileRecordTypeVisibility recordType3 = generateRecordTypeVisibility(true, 'Account.AccountRT3');

        recordTypeVisibilities.add(recordType1);
        //recordTypeVisibilities.add(recordType2);
        recordTypeVisibilities.add(recordType3);
        return recordTypeVisibilities;

    }

    public static usf3.MetadataService.ProfileRecordTypeVisibility generateRecordTypeVisibility (Boolean visible, String recordType) {
        usf3.MetadataService.ProfileRecordTypeVisibility curRT = new usf3.MetadataService.ProfileRecordTypeVisibility();
        curRT.visible = visible;
        curRT.recordType = recordType;
        return curRT;

    }
}