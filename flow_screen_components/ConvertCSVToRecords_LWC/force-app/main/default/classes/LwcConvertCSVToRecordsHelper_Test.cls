@isTest()
public with sharing class LwcConvertCSVToRecordsHelper_Test {

    static testMethod void getObjectFieldsTest() {
        List<Map<String,String>> fields = LwcConvertCSVToRecordsHelper.getObjectFields('Account');
     }

}