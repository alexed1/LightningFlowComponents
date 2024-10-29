@IsTest
public with sharing class CollectionCalculateControllerTest {

    @IsTest
    static void tryCalculate() {

        List<SObject> accounts = new List<SObject>{ 
            new Account(Name = 'A1', NumberOfEmployees = 10), 
            new Account(Name = 'A2', NumberOfEmployees = 15),
            new Account(Name = 'A3')
        };

        String result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'sum', 'use0' );
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 25, resultMap.get('outputDecimalResult') );
        Assert.areEqual( '25', resultMap.get('outputStringResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'multiply', 'use1' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 150, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'max', 'use0' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 15, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'min', 'use0' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 10, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'add', 'use0' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 25, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'count', 'use0' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 3, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'average', 'use0' );
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( 8, resultMap.get('outputDecimalResult') );

        result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'average', '' ); // Force Exception

    }

}