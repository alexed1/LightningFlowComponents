@isTest
public with sharing class FilterObjectRepresentationTest {
    
    @isTest
    static void testConst() {
        FilterObjectRepresentation emptyConstructor = new FilterObjectRepresentation();
        FilterObjectRepresentation constructorWithValues = new FilterObjectRepresentation('type', 'fieldName', 'label');
        System.assertEquals(emptyConstructor.getType(),null);
        System.assertEquals(emptyConstructor.getFieldName(), null);
        System.assertEquals(emptyConstructor.getLabel(), null);
        System.assertEquals(constructorWithValues.getType(),'type');
        System.assertEquals(constructorWithValues.getFieldName(), 'fieldName');
        System.assertEquals(constructorWithValues.getLabel(), 'label');
    }
}