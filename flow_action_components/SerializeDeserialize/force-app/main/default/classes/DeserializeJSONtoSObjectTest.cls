@isTest
public with sharing class DeserializeJSONtoSObjectTest {
    @isTest
    static void testDeserialize() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<SerializeSObjectToJSON.Requests> serializeRequests = new List<SerializeSObjectToJSON.Requests>();
        for (Integer i = 0; i < 200; i += 2) {
            SerializeSObjectToJSON.Requests requestList = new SerializeSObjectToJSON.Requests();
            requestList.inputSObjectList = accounts;
            serializeRequests.add(requestList);
            SerializeSObjectToJSON.Requests requestSingleton = new SerializeSObjectToJSON.Requests();
            requestSingleton.inputSObject = accounts[i];
            serializeRequests.add(requestSingleton);
        }
        List<SerializeSObjectToJSON.Results> serializeResults = SerializeSObjectToJSON.serialize(serializeRequests);
        List<DeserializeJSONtoSObject.Requests> deserializeRequests = new List<DeserializeJSONtoSObject.Requests>();
        for (SerializeSObjectToJSON.Results result : serializeResults) {
            DeserializeJSONtoSObject.Requests request = new DeserializeJSONtoSObject.Requests();
            request.serializedSObjectString = result.serializedSObjectString;
            request.objectTypeName = 'Account';
            deserializeRequests.add(request);
        }
        List<DeserializeJSONtoSObject.Results> deserializeResults = DeserializeJSONtoSObject.parse(deserializeRequests);
        System.assertEquals(200, deserializeResults.size());
    }
}
