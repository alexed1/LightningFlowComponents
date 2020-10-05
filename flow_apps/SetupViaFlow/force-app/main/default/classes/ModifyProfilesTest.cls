@isTest
public with sharing class ModifyProfilesTest {
    @isTest
    public static void CanModifyProfilesUsingGranularTools() {

        flowDMC_Profile testProfileA = Fixture_TestProfile_ApexType.testProfile1(); //1 and 3
        flowDMC_Profile testProfileB = Fixture_TestProfile_ApexType.testProfile2(); //1 and 2
        List<flowDMC_Profile> testProfiles = new List<flowDMC_Profile>();
        testProfiles.add(testProfileA);
        testProfiles.add(testProfileB);

        ModifyProfiles.RequestSet testRequest = new ModifyProfiles.RequestSet();
        testRequest.targetRTShortName = 'AccountRT2';
        testRequest.assigned = true;
        testRequest.objectName = 'Account';
        testRequest.defaultRTNameAssignment = 'AccountRT2';
        testRequest.targetProfiles = testProfiles;

        List<ModifyProfiles.RequestSet> testRequestList = new List<ModifyProfiles.RequestSet>();
        testRequestList.add(testRequest);

        ModifyProfiles.ResultSet testResults = new ModifyProfiles.ResultSet();
        List<ModifyProfiles.ResultSet> testResultsList = new List<ModifyProfiles.ResultSet>();

        testResultsList = ModifyProfiles.execute(testRequestList);

        flowDMC_Profile modifiedProfileA = testResultsList[0].modifiedProfiles[0];
        flowDMC_Profile modifiedProfileB = testResultsList[0].modifiedProfiles[1];
        // for profiles, the size shouldn't change (not the case for permission sets)
         System.assertEquals(3, modifiedProfileA.recordTypeVisibilities.size());
        System.assertEquals(3, modifiedProfileB.recordTypeVisibilities.size());
      

        //the second rtv, representing account rt2, should be the default, and default should be false on the others
        System.assertEquals(true, modifiedProfileA.recordTypeVisibilities[1].default_x);
        System.assertEquals(false, modifiedProfileA.recordTypeVisibilities[0].default_x);
        System.assertEquals(false, modifiedProfileA.recordTypeVisibilities[2].default_x);
    }

    @isTest
    public static void CanValidateDefaultStatus() {
    
        flowDMC_Profile testProfileA = Fixture_TestProfile_ApexType.testProfile1(); //1* and 3
        flowDMC_Profile testProfileB = Fixture_TestProfile_ApexType.testProfile2(); //1* and 2
        List<flowDMC_Profile> testProfiles = new List<flowDMC_Profile>();
        testProfiles.add(testProfileA);
        testProfiles.add(testProfileB);

        ModifyProfiles.RequestSet testRequest = new ModifyProfiles.RequestSet();
        testRequest.targetRTShortName = 'AccountRT2';
        testRequest.assigned = true;
        testRequest.objectName = 'Account';
        testRequest.defaultRTNameAssignment = 'AccountRT2';
        testRequest.targetProfiles = testProfiles;

        List<ModifyProfiles.RequestSet> testRequestList = new List<ModifyProfiles.RequestSet>();
        testRequestList.add(testRequest);

        ModifyProfiles.ResultSet testResults = new ModifyProfiles.ResultSet();
        List<ModifyProfiles.ResultSet> testResultsList = new List<ModifyProfiles.ResultSet>();

        Boolean valid = ModifyProfiles.ChangesAreValid(testProfileA);
        System.assertEquals(true, valid);

        testProfileA = Fixture_TestProfile_ApexType.testProfile1(); //1* and 3
        
        testProfileA.recordTypeVisibilities[0].default_x = false;
    
        valid = ModifyProfiles.ChangesAreValid(testProfileA);
        System.assertEquals(false, valid);
    
    }

    @isTest

    public static void CanChangeRecordTypeVisbilityForAllRecordTypes() {

        flowDMC_Profile testProfileA = Fixture_TestProfile_ApexType.testProfile1(); //1 and 3
        flowDMC_Profile testProfileB = Fixture_TestProfile_ApexType.testProfile2(); //1 and 2
        List<flowDMC_Profile> testProfiles = new List<flowDMC_Profile>();
        testProfiles.add(testProfileA);
        testProfiles.add(testProfileB);

        ModifyProfiles.RequestSet testRequest = new ModifyProfiles.RequestSet();
        testRequest.targetRTShortName = 'AccountRT2';
        testRequest.assigned = true;
        testRequest.objectName = 'Account';
        testRequest.defaultRTNameAssignment = 'AccountRT3';
        testRequest.targetProfiles = testProfiles;
        testRequest.allRecordTypesShortNames = new List<String> {'AccountRT1', 'AccountRT2', 'AccountRT3'};
        testRequest.selectedRecordTypeShortNames = new List<String> {'AccountRT3'};
        

        List<flowDMC_Profile>  modifiedProfiles = ModifyProfiles.ChangeRecordTypeVisbilityForAllRecordTypes(testRequest);


        //should have all 3 present
        System.assertEquals(3, modifiedProfiles[0].recordTypeVisibilities.size());
        //selected values are processed first so anticipated order is baz, foo, bar
        System.assertEquals('Account.AccountRT3', modifiedProfiles[0].recordTypeVisibilities[2].recordType);
        System.assertEquals(true, modifiedProfiles[0].recordTypeVisibilities[2].visible );
        System.assertEquals(true, modifiedProfiles[0].recordTypeVisibilities[2].default_x );
        System.assertEquals('Account.AccountRT1', modifiedProfiles[0].recordTypeVisibilities[0].recordType);
        System.assertEquals(false, modifiedProfiles[0].recordTypeVisibilities[0].visible );
        System.assertEquals(false, modifiedProfiles[0].recordTypeVisibilities[0].default_x );



    }


}