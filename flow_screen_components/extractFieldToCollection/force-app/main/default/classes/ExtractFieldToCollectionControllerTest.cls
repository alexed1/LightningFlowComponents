@IsTest
public with sharing class ExtractFieldToCollectionControllerTest {
    
    @IsTest
    static void tryExtract() {

        List<SObject> accounts = new List<SObject>{ 
            new Account(Name = 'A1', NumberOfEmployees = 10), 
            new Account(Name = 'A2', NumberOfEmployees = 15),
            new Account(Name = 'A3', NumberOfEmployees = 15)
        };

        String result = ExtractFieldToCollectionController.extractFieldToCollection( accounts, 'NumberOfEmployees', null, null );
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        List<String> objAsStrings = (List<String>) JSON.deserialize(JSON.serialize( resultMap.get('fieldValueCollection') ), List<String>.class);
        Assert.areEqual( 2, objAsStrings.size() );
        Assert.areEqual( 5, String.valueOf( resultMap.get('fieldValueString') ).length() );

        result = ExtractFieldToCollectionController.extractFieldToCollection( accounts, 'NumberOfEmployees', false, null );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        objAsStrings = (List<String>) JSON.deserialize(JSON.serialize( resultMap.get('fieldValueCollection') ), List<String>.class);
        Assert.areEqual( 3, objAsStrings.size() );
        Assert.areEqual( 8, String.valueOf( resultMap.get('fieldValueString') ).length() );

        accounts = new List<SObject>{};
        result = ExtractFieldToCollectionController.extractFieldToCollection( accounts, 'NumberOfEmployees', false, true );

        // Force error
        result = ExtractFieldToCollectionController.extractFieldToCollection( accounts, 'NumberOfEmployees', false, null );

    }
    
}