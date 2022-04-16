@isTest
public with sharing class DataPollerControllerTest {
    public DataPollerControllerTest() {

    }

    @isTest
    static void canQuery() {
        List<Sobject> records = DataPollerController.getSobjects('SELECT Id FROM Account');
        System.assertNotEquals(null, records);
    }
}
