@isTest
public with sharing class ers_EncodeDecodeURLTest {

    @isTest
    public static void testEncodeDecode() {

        string decoded = '2:{class: slds-theme_shade slds-theme_error}';
        string encoded = '2%3A%7Bclass%3A+slds-theme_shade+slds-theme_error%7D';

        ers_EncodeDecodeURL.Requests testRequest = new ers_EncodeDecodeURL.Requests();

        /* Decode */
        List<ers_EncodeDecodeURL.Requests> testDecodeRequestList = new List<ers_EncodeDecodeURL.Requests>();
        testRequest.inputStr = encoded;
        testDecodeRequestList.add(testRequest);
        List<ers_EncodeDecodeURL.Results> testDecodeResponseList = ers_EncodeDecodeURL.decodeStringForURL(testDecodeRequestList);
        System.assertEquals(decoded, testDecodeResponseList[0].outputStr);

        /* Encode */
        List<ers_EncodeDecodeURL.Requests> testEncodeRequestList = new List<ers_EncodeDecodeURL.Requests>();
        testRequest.inputStr = decoded;
        testRequest.encode = true;
        testEncodeRequestList.add(testRequest);
        List<ers_EncodeDecodeURL.Results> testEncodeResponseList = ers_EncodeDecodeURL.decodeStringForURL(testEncodeRequestList);
        System.assertEquals(encoded, testEncodeResponseList[0].outputStr);

    }
}
