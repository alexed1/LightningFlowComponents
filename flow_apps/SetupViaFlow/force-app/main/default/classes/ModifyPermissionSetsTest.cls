@isTest
public with sharing class ModifyPermissionSetsTest {

    @isTest
    public static void CanModifyPermissionSetsUsingGranularTools() {

        flowDMC_PermissionSet testPermA = Fixture_TestPermissionSet_ApexType.testPermSet1(); //1 and 3
        flowDMC_PermissionSet testPermB = Fixture_TestPermissionSet_ApexType.testPermSet2(); //1 and 2
        List<flowDMC_PermissionSet> testPermSets = new List<flowDMC_PermissionSet>();
        testPermSets.add(testPermA);
        testPermSets.add(testPermB);

        ModifyPermissionSets.RequestSet testRequest = new ModifyPermissionSets.RequestSet();
        testRequest.targetRTShortName = 'AccountRT2';
        testRequest.assigned = false;
        testRequest.objectName = 'Account';
        testRequest.targetPermSets = testPermSets;

        List<ModifyPermissionSets.RequestSet> testRequestList = new List<ModifyPermissionSets.RequestSet>();
        testRequestList.add(testRequest);

        ModifyPermissionSets.ResultSet testResults = new ModifyPermissionSets.ResultSet();
        List<ModifyPermissionSets.ResultSet> testResultsList = new List<ModifyPermissionSets.ResultSet>();

        testResultsList = ModifyPermissionSets.execute(testRequestList);

        flowDMC_PermissionSet modifiedPermA = testResultsList[0].modifiedPermSets[0];
        flowDMC_PermissionSet modifiedPermB = testResultsList[0].modifiedPermSets[1];
        //setting 2 to false shouldn't affect A, but reduces B down to just on true value
        System.assertEquals(2, modifiedPermA.recordTypeVisibilities.size());
        System.assertEquals(1, modifiedPermB.recordTypeVisibilities.size());
      

    }

    @isTest
    public static void CanChangeRecordTypeVisbilityForAllRecordTypes() {

        flowDMC_PermissionSet testPermissionSetA = Fixture_TestPermissionSet_ApexType.testPermSet1(); //1 and 3
        flowDMC_PermissionSet testPermissionSetB = Fixture_TestPermissionSet_ApexType.testPermSet2(); //1 and 2
        List<flowDMC_PermissionSet> testPermissionSets = new List<flowDMC_PermissionSet>();
        testPermissionSets.add(testPermissionSetA);
        testPermissionSets.add(testPermissionSetB);

        ModifyPermissionSets.RequestSet testRequest = new ModifyPermissionSets.RequestSet();
        testRequest.targetRTShortName = null;
        testRequest.assigned = true;
        testRequest.objectName = 'Account';
        testRequest.targetPermSets = testPermissionSets;
        testRequest.allRecordTypesShortNames = new List<String> {'AccountRT1', 'AccountRT2', 'AccountRT3'};
        testRequest.selectedRecordTypeShortNames = new List<String> {'AccountRT3'};
        

        List<flowDMC_PermissionSet>  modifiedPermissionSets = ModifyPermissionSets.ChangeRecordTypeVisbilityForAllRecordTypes(testRequest);


        //should have only the 1 visible present
        System.assertEquals(1, modifiedPermissionSets[0].recordTypeVisibilities.size());
        //selected values are processed first so anticipated order is baz, foo, bar
        System.assertEquals('Account.AccountRT3', modifiedPermissionSets[0].recordTypeVisibilities[0].recordType);
        System.assertEquals(true, modifiedPermissionSets[0].recordTypeVisibilities[0].visible );

        //System.assertEquals('Account.AccountRT1', modifiedPermissionSets[0].recordTypeVisibilities[0].recordType);
        //System.assertEquals(false, modifiedPermissionSets[0].recordTypeVisibilities[0].visible );




    }

}
