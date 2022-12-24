@isTest()
public with sharing class LwcConvertCSVToRecordsHelper_Test {

    static testMethod void getObjectFieldsTest() {
        List<String> fields = LwcConvertCSVToRecordsHelper.getObjectFields('Account');
        System.assertEquals('Id', fields[0]);
     }
}