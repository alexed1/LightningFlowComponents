@isTest
public class RefreshRecordsTest {
    @TestSetup
    static void makeData(){
        insert new Lead(Email = 'email@email.com', LastName = 'Doe', Company = 'Business');
    }

    @isTest
    static void RefreshRecordsTest() {
        RefreshRecords.Request input = new RefreshRecords.Request();
        input.inputCollection = [SELECT Id FROM Lead];
        RefreshRecords.RefreshRecords(new List<RefreshRecords.Request>{input});
    }
}