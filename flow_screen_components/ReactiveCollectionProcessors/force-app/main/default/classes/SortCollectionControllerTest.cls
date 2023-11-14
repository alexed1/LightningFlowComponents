@IsTest
public with sharing class SortCollectionControllerTest {

    @IsTest
    static void trySortCollection() {

        List<SObject> accounts = new List<SObject>{ 
            new Account(Name = 'A1', NumberOfEmployees = 10), 
            new Account(Name = 'A2', NumberOfEmployees = 15),
            new Account(Name = 'A3')
        };


        String result = SortCollectionController.sortCollection(accounts, 'Name:DESC');
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        List<SObject> recs = objToObj(resultMap.get('outputCollection'));
        Assert.areEqual( 'A3', recs[0].get('Name') );

    }

        // Convert an object to a list of objects
        private static List<SObject> objToObj(Object obj) {
            return (List<SObject>) JSON.deserialize(JSON.serialize(obj), List<SObject>.class);
        } 

}