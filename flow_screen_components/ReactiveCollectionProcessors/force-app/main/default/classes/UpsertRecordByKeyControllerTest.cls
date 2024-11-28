@isTest
public with sharing  class UpsertRecordByKeyControllerTest {

    @isTest
    static void tryUpsertRecordByKey() {

        Account acct = new Account(Name='Test Account1', AccountNumber='1');
        insert acct;
        List<Account> accts = new List<Account>();
        accts.add(acct);
        acct = new Account(Name='Test Account2', AccountNumber='2');
        insert acct;
        accts.add(acct);
        acct = new Account(Name='Test Account3', AccountNumber='3');
        insert acct;
        accts.add(acct);

        Account upd_acct1 = new Account(Name='Test Account1', AccountNumber='11');

        String result = UpsertRecordByKeyController.upsertByKey(accts, upd_acct1, 'Name', false);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual('11', objToObj(resultMap.get('outputCollection'))[0].get('AccountNumber'));

    }

    // Convert an object to a list of objects
    private static List<SObject> objToObj(Object obj) {
        return (List<SObject>) JSON.deserialize(JSON.serialize(obj).replace('+0000','Z'), List<SObject>.class);
    }

}