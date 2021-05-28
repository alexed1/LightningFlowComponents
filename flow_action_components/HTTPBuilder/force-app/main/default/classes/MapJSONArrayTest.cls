@isTest
public with sharing class MapJSONArrayTest {
    final static String JSON_VALUES_SAMPLE = '[ { "text": "This is an attachment", "id": "1", "fallback": "This is an attachment\'s fallback" },'+
    '{ "text": "This is another attachment", "id": "2", "fallback": "This is another attachment\'s fallback" } ]';

    final static String INVALID_JSON_VALUES_SAMPLE = '[ { "text": "This is an attachment", "id": "1", "fallback": "This is an attachment\'s fallback" },'+
    '{ "text": "This is another attachment", "id": "2", ' +
    '"fallback": [ { "text": "This is an attachment", "id": "1"},'+
    '{ "text": "This is another attachment", "id": "2"} ]]';

     final static String KEY_TO_EXTRACT_JSON_SAMPLE = '[{"key":"Name","value":"text"},'+
     '{"key":"Description","value":"fallback"},' +
     '{"key":"AccountNumber","value":"id"}]';

    @isTest
    static void testMapJSONArray() {
        MapJSONArray.Request request = new MapJSONArray.Request();
        request.inputJSONString = JSON_VALUES_SAMPLE;
        request.keysToExtract = KEY_TO_EXTRACT_JSON_SAMPLE;
        request.sobjectType = 'Account';

        MapJSONArray.Response response = MapJSONArray.Invoke(new List<MapJSONArray.Request> {request})[0];
        System.debug(response);
        List<Account> accountList = response.sobjectList;
        System.assertEquals(accountList.size(), 2);

        System.assertEquals(accountList[0].Name, 'This is an attachment');
        System.assertEquals(accountList[0].Description, 'This is an attachment\'s fallback');
        System.assertEquals(accountList[0].AccountNumber, '1');

        System.assertEquals(accountList[1].Name, 'This is another attachment');
        System.assertEquals(accountList[1].Description, 'This is another attachment\'s fallback');
        System.assertEquals(accountList[1].AccountNumber, '2');


        request.inputJSONString = INVALID_JSON_VALUES_SAMPLE;
        request.keysToExtract = KEY_TO_EXTRACT_JSON_SAMPLE;
        request.sobjectType = 'Account';

        response = MapJSONArray.Invoke(new List<MapJSONArray.Request> {request})[0];

        System.assert(response.errors != null);

    }
}
