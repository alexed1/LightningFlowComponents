@IsTest
public with sharing class JoinCollectionsControllerTest {

    @IsTest
    static void tryJoinCollections() {

        List<SObject> accounts = new List<SObject>{ 
            new Account(Name = 'A1', NumberOfEmployees = 10), 
            new Account(Name = 'A2', NumberOfEmployees = 15),
            new Account(Name = 'A3')
        };

        List<SObject> accounts2 = new List<SObject>{ 
            new Account(Name = 'B1', NumberOfEmployees = 10)
        };

        String result = JoinCollectionsController.joinCollections(accounts, accounts2);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 4, objToObj(resultMap.get('outputCollection')).size() );

    }

        // Convert an object to a list of objects
        private static List<SObject> objToObj(Object obj) {
            return (List<SObject>) JSON.deserialize(JSON.serialize(obj), List<SObject>.class);
        } 

}