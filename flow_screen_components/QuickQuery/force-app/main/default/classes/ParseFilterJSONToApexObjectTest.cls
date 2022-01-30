@isTest
public with sharing class ParseFilterJSONToApexObjectTest {
    
    @isTest
    static void parseFilterJSONToApexObjectCheckNull_Test() {
        List<FilterObjectRepresentation> resultEmptyList = new List<FilterObjectRepresentation>();
        System.assertEquals(resultEmptyList, ParseFilterJSONToApexObject.parseStringToApexObj(null));
    }

    @isTest
    static void parseFilterJSONToApexObjectValuePresent_Test() {
        String filter = '[' + 
                            '{"type": "text","fieldName": "FirstName", "label": "First Name"},' + 
                            '{"type": "text","fieldName": "LastName","label": "Last Name"}, ' +
                            '{"type": "text","fieldName": "Email", "label": "Email"} ' + 
                        ']';
    
        List<FilterObjectRepresentation> result = ParseFilterJSONToApexObject.parseStringToApexObj(filter);
        System.assertEquals(3, result.size());
    }
}