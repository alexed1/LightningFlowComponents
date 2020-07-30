@isTest
public with sharing class UpdateFieldTest {
    @isTest
    static void UpdateFieldRequestTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Amount = 15000.05;
        opp.CloseDate = Date.today().addDays(-30);
        opp.StageName = 'Prospecting';
        opp.IsPrivate = false;

        insert opp;

        UpdateField.Request request = new UpdateField.Request();
         request.objectId = opp.Id;
         request.fieldName = 'Amount';
         request.formula = '$Record.Amount + 200';
        UpdateField.execute(new List<UpdateField.Request>{request});

        System.assertEquals(15200.05, [SELECT Amount FROM Opportunity WHERE Id =: opp.Id LIMIT 1].Amount, 'Update decimal field');

         request.fieldName = 'IsPrivate';
         request.formula = '15 > 10';
        UpdateField.execute(new List<UpdateField.Request>{request});

        System.assertEquals(true, [SELECT IsPrivate FROM Opportunity WHERE Id =: opp.Id LIMIT 1].IsPrivate, 'Update boolean field');

         request.fieldName = 'CloseDate';
         request.formula = '$TODAY';
        UpdateField.execute(new List<UpdateField.Request>{request});

        System.assertEquals(System.today(), [SELECT CloseDate FROM Opportunity WHERE Id =: opp.Id LIMIT 1].CloseDate, 'Update date field');

         request.fieldName = 'Name';
         request.formula = '$Record.Name + "1"';
        UpdateField.execute(new List<UpdateField.Request>{request});
        
        System.assertEquals('Test Opportunity1', [SELECT Name FROM Opportunity WHERE Id =: opp.Id LIMIT 1].Name, 'Update string field');
    } 
}
