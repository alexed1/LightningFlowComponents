@isTest
public with sharing class GetFirstControllerTest {

    @isTest
    static void tryExtractFirstRecord() {

        Account acct = new Account(Name='Test Account1', AccountNumber='1');
        insert acct;
        List<Account> accts = new List<Account>();
        accts.add(acct);
        acct = new Account(Name='Test Account2', AccountNumber='2');
        insert acct;
        accts.add(acct);

        String result = GetFirstController.getFirstRecord(accts, false);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual('1', objToRec(resultMap.get('outputMember')).get('AccountNumber'));

    }

    // Convert an object to an object and fix date format
    private static SObject objToRec(Object obj) {
        return (SObject) JSON.deserialize(JSON.serialize(obj).replace('+0000','Z'), SObject.class);
    } 

}