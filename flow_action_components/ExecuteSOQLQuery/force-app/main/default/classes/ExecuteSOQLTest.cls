@isTest
public class ExecuteSOQLTest {
    @isTest
    public static void testExecuteSOQL() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        //Not formatted DateTime
        ExecuteSOQL.Requests requests = new ExecuteSOQL.Requests();
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= 4/12/2020, 3:24 PM';
        List<ExecuteSOQL.Results> results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        System.assertEquals(acc.Id, results[0].sObjects[0].Id);

        //Not formatted Date
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= April 12, 2020';
        results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        System.assertEquals(acc.Id, results[0].sObjects[0].Id);

        //Formatted date time
        requests.soqlQuery = 'Select Id From Account Where CreatedDate >= 2020-04-12T15:24:00Z';
        results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        System.assertEquals(acc.Id, results[0].sObjects[0].Id);

        //Multiple records returned
        Set<Id> accIds = new Set<Id>();
        accIds.add(acc.Id);
        acc = new Account(Name = 'Test Account2');
        insert acc;
        accIds.add(acc.Id);
        requests.soqlQuery = 'Select Id From Account Where Name != \'TEST\' ORDER BY CreatedDate LIMIT 2';
        results = ExecuteSOQL.getEligibleProducts(new List<ExecuteSOQL.Requests>{
                requests
        });
        for (SObject so : results[0].sObjects) {
            System.assertEquals(true, accIds.contains(so.Id));
        }

    }
}