@isTest
public with sharing class FilterObjectRepresentationTest {
    
    @isTest
    static void testConst() {
        FilterObjectRepresentation emptyConstructor = new FilterObjectRepresentation();
        FilterObjectRepresentation constructorWithValues = new FilterObjectRepresentation('type', 'fieldName', 'label');
        System.assertEquals(emptyConstructor.type,null);
        System.assertEquals(emptyConstructor.fieldName, null);
        System.assertEquals(emptyConstructor.label, null);
        System.assertEquals(constructorWithValues.type,'type');
        System.assertEquals(constructorWithValues.fieldName, 'fieldName');
        System.assertEquals(constructorWithValues.label, 'label');
    }
}