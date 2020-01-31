@isTest
public with sharing class FormulaBuilderControllerTest {
    @IsTest
    static void getFieldListTest() {
        List<String> result = FormulaBuilderController.getFieldList('Opportunity');
        System.assertNotEquals(NULL, result, 'Result not NULL');
        System.assertNotEquals(0, result.size(), 'Result size > 0');
    }
}
