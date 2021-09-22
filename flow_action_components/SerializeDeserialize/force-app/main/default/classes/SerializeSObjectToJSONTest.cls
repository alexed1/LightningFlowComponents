@isTest
public with sharing class SerializeSObjectToJSONTest {
    @isTest
    static void testSerialize() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<SerializeSObjectToJSON.Requests> requests = new List<SerializeSObjectToJSON.Requests>();
        for (Integer i = 0; i < 201; i += 3) {
            SerializeSObjectToJSON.Requests requestList = new SerializeSObjectToJSON.Requests();
            requestList.inputSObjectList = accounts;
            requests.add(requestList);
            SerializeSObjectToJSON.Requests requestSingleton = new SerializeSObjectToJSON.Requests();
            requestSingleton.inputSObject = accounts[i];
            requests.add(requestSingleton);
            SerializeSObjectToJSON.Requests requestBoth = new SerializeSObjectToJSON.Requests();
            requestBoth.inputSObjectList = accounts;
            requestBoth.inputSObject = accounts[i];
            requests.add(requestBoth);
        }
        List<SerializeSObjectToJSON.Results> results = SerializeSObjectToJSON.serialize(requests);
        System.assertEquals(201, results.size());
    }
}
