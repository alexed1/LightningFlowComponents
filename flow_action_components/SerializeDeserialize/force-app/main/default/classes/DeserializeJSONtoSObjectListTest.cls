@isTest
public with sharing class DeserializeJSONtoSObjectListTest {
    @isTest
    static void testDeserialize() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<SerializeSObjectListToJSON.Requests> serializeRequests = new List<SerializeSObjectListToJSON.Requests>();
        for (Integer i = 0; i < 200; i += 2) {
            SerializeSObjectListToJSON.Requests requestList = new SerializeSObjectListToJSON.Requests();
            requestList.inputSObjectList = accounts;
            serializeRequests.add(requestList);
            SerializeSObjectListToJSON.Requests requestSingleton = new SerializeSObjectListToJSON.Requests();
            requestSingleton.inputSObject = accounts[i];
            serializeRequests.add(requestSingleton);
        }
        List<SerializeSObjectListToJSON.Results> serializeResults = SerializeSObjectListToJSON.serialize(serializeRequests);
        List<DeserializeJSONtoSObjectList.Requests> deserializeRequests = new List<DeserializeJSONtoSObjectList.Requests>();
        for (SerializeSObjectListToJSON.Results result : serializeResults) {
            DeserializeJSONtoSObjectList.Requests request = new DeserializeJSONtoSObjectList.Requests();
            request.serializedSObjectListString = result.serializedSObjectListString;
            request.objectTypeName = 'Account';
            deserializeRequests.add(request);
        }
        List<DeserializeJSONtoSObjectList.Results> deserializeResults = DeserializeJSONtoSObjectList.parse(deserializeRequests);
        System.assertEquals(200, deserializeResults.size());
    }
}
