@IsTest
public with sharing class FilterCollectionControllerTest {

    @IsTest
    static void tryFilterCollection() {

        List<SObject> accounts = new List<SObject>{ 
            new Account(Name = 'A1', NumberOfEmployees = 10), 
            new Account(Name = 'A2', NumberOfEmployees = 15),
            new Account(Name = 'A3', NumberOfEmployees = 10)
        };
        insert accounts;

        String formula = '$Record.NumberOfEmployees=10';
        String result = FilterCollectionController.filterCollection(accounts, formula);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        // List<SObject> recs = objToObj(resultMap.get('outputCollection'));
        Assert.areEqual( 2, objToObj(resultMap.get('outputCollection')).size() );

    }

        // Convert an object to a list of objects
        private static List<SObject> objToObj(Object obj) {
            return (List<SObject>) JSON.deserialize(JSON.serialize(obj), List<SObject>.class);
        } 

}