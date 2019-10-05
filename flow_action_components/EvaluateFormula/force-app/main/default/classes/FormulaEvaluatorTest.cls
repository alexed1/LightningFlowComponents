@isTest
public with sharing class FormulaEvaluatorTest {
    @IsTest
    static void parseFormulaTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Amount = 15000.05;
        opp.CloseDate = Date.today().addDays(-30);
        opp.StageName = 'Prospecting';
        opp.IsPrivate = false;

        insert opp;

        List<ContextWraper> context = new List<ContextWraper>();
        context.add(new ContextWraper('$Record', opp.Id));
        context.add(new ContextWraper('itemOne', '30'));
        context.add(new ContextWraper('itemTwo', '45'));
        String stringContext = JSON.serialize(context);

        System.assertEquals('Test Opportunity', FormulaEvaluator.parseFormula('$Record.Name', stringContext), 'Formula include record');
        System.assertEquals('Test OpportunityTest', FormulaEvaluator.parseFormula('$Record.Name + "Test"', stringContext), 'Formula include record and text');
        System.assertEquals('Test Opportunity15000.05', FormulaEvaluator.parseFormula('"$Record.Name" + "$Record.Amount"', stringContext), 'Formula include 2 fields from record');
        System.assertEquals('30', FormulaEvaluator.parseFormula('itemOne', stringContext), 'Formula include static field');
        System.assertEquals('45', FormulaEvaluator.parseFormula('itemTwo', stringContext), 'Formula include static field');
        System.assertEquals('false', FormulaEvaluator.parseFormula('itemOne > itemTwo', stringContext), 'Formula include static fields and operator');
        System.assertEquals('true', FormulaEvaluator.parseFormula('itemOne < itemTwo', stringContext), 'Formula include static fields and operator');
        System.assertEquals('false', FormulaEvaluator.parseFormula('AND(true,false)', stringContext), 'Formula include "AND" condition');
        System.assertEquals('true', FormulaEvaluator.parseFormula('AND(true,true)', stringContext), 'Formula include "AND" condition');
        System.assertEquals('true', FormulaEvaluator.parseFormula('IF(15 > 10,true,false)', stringContext), 'Formula include "IF" condition');
        System.assertEquals('2019-01-01 11:00:15', FormulaEvaluator.parseFormula('DATETIME(2019,01,01,11,00,15)', stringContext), 'Formula include datetime');
        System.assertEquals(System.today(), Date.valueOf(FormulaEvaluator.parseFormula('$TODAY', stringContext)), 'Formula include $TODAY');
        System.assertNotEquals(NULL, FormulaEvaluator.parseFormula('$PI', stringContext), 'Formula include $PI');
        System.assertNotEquals(NULL, FormulaEvaluator.parseFormula('$E', stringContext), 'Formula include $E');
        System.assertNotEquals(NULL, FormulaEvaluator.parseFormula('$RANDOM', stringContext), 'Formula include $RANDOM');
        System.assertNotEquals(NULL, FormulaEvaluator.parseFormula('$NOW', stringContext), 'Formula include $NOW');
        System.assertNotEquals(NULL, FormulaEvaluator.parseFormula('$Organization.Name', stringContext), 'Formula include $Organization');
        System.assertEquals(UserInfo.getName(), FormulaEvaluator.parseFormula('$User.Name', stringContext), 'Formula include $User');
        System.assertEquals(UserInfo.getProfileId(), FormulaEvaluator.parseFormula('$Profile.Id', stringContext), 'Formula include $Profile');
        System.assertEquals(NULL, FormulaEvaluator.parseFormula('2019 / test', stringContext), 'Formula include wrong value');
        System.assertEquals('20', FormulaEvaluator.parseFormula('40 / 2', stringContext), 'Formula include /');
        System.assertEquals('180', FormulaEvaluator.parseFormula('10 * 18', stringContext), 'Formula include *');
        System.assertEquals('18.00', FormulaEvaluator.parseFormula('FLOOR(18.12)', stringContext), 'Formula include FLOOR()');
        System.assertEquals('256', FormulaEvaluator.parseFormula('TEXT(256)', stringContext), 'Formula convert Integer to String');
    }

    public class ContextWraper {
        public String name;
        public String value;

        public ContextWraper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }
}
