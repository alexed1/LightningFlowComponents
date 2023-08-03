@IsTest
private class CollectionCalculateControllerTest {

    @IsTest
    static void tryCalculate() {

        List<SObject> accounts = new List<SObject>{ new Account(Name = 'A1', NumberOfEmployees = 10), new Account(Name = 'A2', NumberOfEmployees = 15) };

        String result = CollectionCalculateController.collectionCalculate( accounts, 'NumberOfEmployees', 'sum', 'use0' );

        System.debug(result);
        // Assert.areEqual( 25, result[0].get(outputDecimalResult) );
        // Assert.areEqual( '25', result[0].outputStringResult );

    }

}