@isTest
public with sharing class ConvertCSVStringCollectionControllerTest {

    @isTest
    static void testConvert() {

        List<String> textCollection = new List<String>{};
        String csvString = 'abc;def';

        String result = ConvertCSVStringCollectionController.convertCSVCollection(csvString, textCollection, ';');
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        List<String> objAsStrings = (List<String>) JSON.deserialize(JSON.serialize( resultMap.get('stringCollectionOut') ), List<String>.class);
        Assert.areEqual( objAsStrings[0], 'abc' );
        Assert.areEqual( objAsStrings[1], 'def' );

        result = ConvertCSVStringCollectionController.convertCSVCollection('', objAsStrings, ';');
        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual( csvString, resultMap.get('csvStringOut') );

    }
    
}