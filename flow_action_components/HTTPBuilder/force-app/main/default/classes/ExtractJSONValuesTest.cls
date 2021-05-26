@isTest
public with sharing class ExtractJSONValuesTest {
    final static String JSON_VALUES_SAMPLE = '{ "ok": true,'+
    '"channel": "C024BE91L",' +
    '"ts": "1401383885.000061",' +
     '"text": "Updated text you carefully authored",' +
    '"message": { "text": "Updated text you carefully authored", "user": "U34567890" }'+
     '}';

     final static String KEY_TO_EXTRACT_JSON_SAMPLE = '[{"key":"value1","value":"ok"},'+
     '{"key":"value2","value":"message.user"},' +
     '{"key":"value10","value":"text"},'+
     '{"key":"value11","value":"message.user.user"},' +
     '{"key":"value12","value":"testfield"}]';

    @isTest
    static void testExtractJSONValue() {
        ExtractJSONValues.Request request = new ExtractJSONValues.Request();
        request.inputJSONString = JSON_VALUES_SAMPLE;
        request.keysToExtract = KEY_TO_EXTRACT_JSON_SAMPLE;

        ExtractJSONValues.Response response = ExtractJSONValues.Invoke(new List<ExtractJSONValues.Request> {request})[0];
        System.assertEquals(response.value1, 'true');
        System.assertEquals(response.value2, 'U34567890');
        System.assertEquals(response.value10, 'Updated text you carefully authored');
        System.assertEquals(response.value11, 'U34567890');
        System.assertEquals(response.value12, null);
        System.assertEquals(response.value3, null);
    }
}
