@isTest
public with sharing class SerializeSObjectListToJSONTest {
    @isTest
    static void testSerialize() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<SerializeSObjectListToJSON.Requests> requests = new List<SerializeSObjectListToJSON.Requests>();
        for (Integer i = 0; i < 201; i += 3) {
            SerializeSObjectListToJSON.Requests requestList = new SerializeSObjectListToJSON.Requests();
            requestList.inputSObjectList = accounts;
            requests.add(requestList);
            SerializeSObjectListToJSON.Requests requestSingleton = new SerializeSObjectListToJSON.Requests();
            requestSingleton.inputSObject = accounts[i];
            requests.add(requestSingleton);
            SerializeSObjectListToJSON.Requests requestBoth = new SerializeSObjectListToJSON.Requests();
            requestBoth.inputSObjectList = accounts;
            requestBoth.inputSObject = accounts[i];
            requests.add(requestBoth);
        }
        List<SerializeSObjectListToJSON.Results> results = SerializeSObjectListToJSON.serialize(requests);
        System.assertEquals(201, results.size());
    }
}
