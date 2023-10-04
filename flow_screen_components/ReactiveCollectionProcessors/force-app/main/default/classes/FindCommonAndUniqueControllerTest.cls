@IsTest
public with sharing class FindCommonAndUniqueControllerTest {

    @IsTest
    static void tryFindCommonAndUnique() {

        List<SObject> sourceAccounts = new List<SObject>{ 
            new Account(Name = 'A1', Site = '1'), 
            new Account(Name = 'A2', Site = '2'),
            new Account(Name = 'A3', Site = '3')
        };

        List<SObject> targetAccounts = new List<SObject>{ 
            new Account(Name = 'B1', Site = '1'),
            new Account(Name = 'B4', Site = '4')
        };

        String result = FindCommonAndUniqueController.findCommonAndUnique(sourceAccounts, 'Site', targetAccounts, 'Site', false);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 2, objToObj(resultMap.get('sourceUniqueRecordCollection')).size() );
        Assert.areEqual( 1, objToObj(resultMap.get('sourceCommonRecordCollection')).size() );
        Assert.areEqual( 1, objToObj(resultMap.get('targetUniqueRecordCollection')).size() );
        Assert.areEqual( 1, objToObj(resultMap.get('targetCommonRecordCollection')).size() );

    }

        // Convert an object to a list of objects
        private static List<SObject> objToObj(Object obj) {
            return (List<SObject>) JSON.deserialize(JSON.serialize(obj), List<SObject>.class);
        } 

}