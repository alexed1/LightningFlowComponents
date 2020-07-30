@isTest
public with sharing class fbc_FormulaEvaluatorTest {
    @IsTest
    static void parseFormulaTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Amount = 15000.05;
        opp.CloseDate = Date.today().addDays(-30);
        opp.StageName = 'Prospecting';
        opp.IsPrivate = false;

        insert opp;

        List<ContextWrapper> context = new List<ContextWrapper>();
        context.add(new ContextWrapper('$Record', opp.Id));
        context.add(new ContextWrapper('itemOne', '30'));
        context.add(new ContextWrapper('itemTwo', '45'));
        String stringContext = JSON.serialize(context);

        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('POW(1,2)', stringContext));
        System.assertEquals('2', fbc_FormulaEvaluator.parseFormula('MAX(1,2)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('MIN(1,2)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('MOD(1,2)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('ABS(-1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('FLOOR(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('SQRT(1)', stringContext));
        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('ACOS(1)', stringContext));
        System.assertEquals('2', fbc_FormulaEvaluator.parseFormula('ASIN(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('ATAN(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('COS(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('SIN(1)', stringContext));
        System.assertEquals('2', fbc_FormulaEvaluator.parseFormula('TAN(1)', stringContext));
        System.assertEquals('2', fbc_FormulaEvaluator.parseFormula('COSH(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('SINH(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('TANH(1)', stringContext));
        System.assertEquals('3', fbc_FormulaEvaluator.parseFormula('EXP(1)', stringContext));
        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('LOG(1)', stringContext));
        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('LOG10(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('SIGNUM(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('RINT(1)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('INTEGER(1)', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('BOOLEAN(true)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('TEXT(text)', stringContext));
        System.assertEquals('1.1', fbc_FormulaEvaluator.parseFormula('DECIMAL("1.1")', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('INTEGER("1.1")', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATETIME("2019-12-26T00:00:00")', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATE(2019,12,26)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATE(2019,"12",26)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATE("2019",12,26)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATE(2019,12,"26")', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATETIME(2019,12,26,0,0,0)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATETIME("2019",12,26,0,0,0)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATETIME(2019,"12",26,0,0,0)', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('DATETIME(2019,12,"26",0,0,0)', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATETIME(2019,12,26,"0",0,0)', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATETIME(2019,12,26,0,"0",0)', stringContext));
        System.assertEquals('2019-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('DATETIME(2019,12,26,0,0,"0")', stringContext));
        System.assertEquals('25', fbc_FormulaEvaluator.parseFormula('DAY(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('12', fbc_FormulaEvaluator.parseFormula('MONTH(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('2019', fbc_FormulaEvaluator.parseFormula('YEAR(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('16', fbc_FormulaEvaluator.parseFormula('HOURS(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('MINUTES(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('SECONDS(DATETIME(2019,12,26,0,0,0))', stringContext));
        System.assertEquals('2019-12-27 00:00:00', fbc_FormulaEvaluator.parseFormula('ADDDAYS(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals('2020-01-26 00:00:00', fbc_FormulaEvaluator.parseFormula('ADDMONTHS(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals('2020-12-26 00:00:00', fbc_FormulaEvaluator.parseFormula('ADDYEARS(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals('2019-12-26 01:00:00', fbc_FormulaEvaluator.parseFormula('ADDHOURS(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals('2019-12-26 00:01:00', fbc_FormulaEvaluator.parseFormula('ADDMINUTES(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals('2019-12-26 00:00:01', fbc_FormulaEvaluator.parseFormula('ADDSECONDS(DATETIME(2019,12,26,0,0,0),1)', stringContext));
        System.assertEquals(String.valueOf(opp.Id), fbc_FormulaEvaluator.parseFormula('CONVERTID("' + opp.Id + '")', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('CONVERTID("error")', stringContext));
        System.assertEquals('5', fbc_FormulaEvaluator.parseFormula('LEN("error")', stringContext));
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('ISBLANK("error")', stringContext));
        System.assertEquals('error', fbc_FormulaEvaluator.parseFormula('SUBSTRING("error","1","text")', stringContext));
        System.assertEquals('err', fbc_FormulaEvaluator.parseFormula('LEFT("error",3)', stringContext));
        System.assertEquals('or', fbc_FormulaEvaluator.parseFormula('RIGHT("error",2)', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('ISPICKVAL("error","error")', stringContext));
        System.assertEquals(null, fbc_FormulaEvaluator.parseFormula('CASE("error","error",1,"success",2)', stringContext));
        System.assertEquals('1', fbc_FormulaEvaluator.parseFormula('CASE("error","error",1,"success",2,4)', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('CASE("error","error",BOOLEAN("true"),"success",BOOLEAN("true"),BOOLEAN("true"))', stringContext));
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('NOT(BOOLEAN("true"))', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('XOR(BOOLEAN("true"),BOOLEAN("false"))', stringContext));
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('(BOOLEAN("true"))&&(BOOLEAN("false"))', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('(BOOLEAN("true"))||(BOOLEAN("false"))', stringContext));
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('(BOOLEAN("true"))^^(BOOLEAN("false"))', stringContext));
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('!(BOOLEAN("true"))', stringContext));
        System.assertEquals('Test Opportunity', fbc_FormulaEvaluator.parseFormula('$Record.Name', stringContext), 'Formula include record');
        System.assertEquals('Test OpportunityTest', fbc_FormulaEvaluator.parseFormula('$Record.Name + "Test"', stringContext), 'Formula include record and text');
        System.assertEquals('Test Opportunity15000.05', fbc_FormulaEvaluator.parseFormula('$Record.Name + TEXT($Record.Amount)', stringContext), 'Formula include 2 fields from record');
        System.assertEquals('30', fbc_FormulaEvaluator.parseFormula('itemOne', stringContext), 'Formula include static field');
        System.assertEquals('45', fbc_FormulaEvaluator.parseFormula('itemTwo', stringContext), 'Formula include static field');
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('itemOne > itemTwo', stringContext), 'Formula include static fields and operator');
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('itemOne < itemTwo', stringContext), 'Formula include static fields and operator');
        System.assertEquals('false', fbc_FormulaEvaluator.parseFormula('AND(true,false)', stringContext), 'Formula include "AND" condition');
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('AND(true,true)', stringContext), 'Formula include "AND" condition');
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('IF(15 > 10,true,false)', stringContext), 'Formula include "IF" condition');
        System.assertEquals('2019-01-01 11:00:15', fbc_FormulaEvaluator.parseFormula('DATETIME(2019,01,01,11,00,15)', stringContext), 'Formula include datetime');
        System.assertEquals(System.today(), Date.valueOf(fbc_FormulaEvaluator.parseFormula('$TODAY', stringContext)), 'Formula include $TODAY');
        System.assertNotEquals(NULL, fbc_FormulaEvaluator.parseFormula('$PI', stringContext), 'Formula include $PI');
        System.assertNotEquals(NULL, fbc_FormulaEvaluator.parseFormula('$E', stringContext), 'Formula include $E');
        System.assertNotEquals(NULL, fbc_FormulaEvaluator.parseFormula('$RANDOM', stringContext), 'Formula include $RANDOM');
        System.assertNotEquals(NULL, fbc_FormulaEvaluator.parseFormula('$NOW', stringContext), 'Formula include $NOW');
        System.assertNotEquals(NULL, fbc_FormulaEvaluator.parseFormula('$Organization.Name', stringContext), 'Formula include $Organization');
        System.assertEquals(UserInfo.getName(), fbc_FormulaEvaluator.parseFormula('$User.Name', stringContext), 'Formula include $User');
        System.assertEquals(UserInfo.getProfileId(), fbc_FormulaEvaluator.parseFormula('$Profile.Id', stringContext), 'Formula include $Profile');
        System.assertEquals(NULL, fbc_FormulaEvaluator.parseFormula('2019 / test', stringContext), 'Formula include wrong value');
        System.assertEquals('20', fbc_FormulaEvaluator.parseFormula('40 / 2', stringContext), 'Formula include /');
        System.assertEquals('180', fbc_FormulaEvaluator.parseFormula('10 * 18', stringContext), 'Formula include *');
        System.assertEquals('18.00', fbc_FormulaEvaluator.parseFormula('FLOOR(18.12)', stringContext), 'Formula include FLOOR()');
        System.assertEquals('256', fbc_FormulaEvaluator.parseFormula('TEXT(256)', stringContext), 'Formula convert Integer to String');

        System.assertEquals('0', fbc_FormulaEvaluator.parseFormula('FIND($Record.Name,"Test")', stringContext), 'Formula include FIND');
        System.assertEquals('true', fbc_FormulaEvaluator.parseFormula('CONTAINS($Record.Name,"Test")', stringContext), 'Formula include CONTAINS');
        System.assertEquals(opp.Name.toLowerCase(), fbc_FormulaEvaluator.parseFormula('LOWER($Record.Name)', stringContext), 'Formula LOWER');
        System.assertEquals(opp.Name.toUpperCase(), fbc_FormulaEvaluator.parseFormula('UPPER($Record.Name)', stringContext), 'Formula UPPER');
        System.assertEquals('Test', fbc_FormulaEvaluator.parseFormula('MID($Record.Name,0,4)', stringContext), 'Formula include MID');
        System.assertEquals('Test', fbc_FormulaEvaluator.parseFormula('SUBSTRING($Record.Name,0,4)', stringContext), 'Formula include SUBSTRING');
        System.assertEquals(opp.Name.replace('Test', 'REPLACEMENT'), fbc_FormulaEvaluator.parseFormula('SUBSTITUTE($Record.Name,"Test","REPLACEMENT")', stringContext), 'Formula SUBSTITUTE');
        System.assertEquals('TEST  .', fbc_FormulaEvaluator.parseFormula('TRIM("  TEST  . ")', stringContext), 'Formula TRIM');
        System.assertEquals('100', fbc_FormulaEvaluator.parseFormula('VALUE("100")', stringContext), 'Formula VALUE');
        System.assertEquals('Test Opportunity15000.05', fbc_FormulaEvaluator.parseFormula('CONCATENATE($Record.Name,TEXT($Record.Amount))', stringContext), 'Formula CONCATENATE');
        System.assertEquals('$Opportunity.Name$Opportunity.Amount', fbc_FormulaEvaluator.parseFormula('CONCATENATE("$Opportunity.Name","$Opportunity.Amount")', stringContext), 'Formula CONCATENATE "&');
        System.assertEquals('8.0500', fbc_FormulaEvaluator.parseFormula('ABS(-10.0500)-2', stringContext), 'Formula VALUE');
        System.assertEquals('-0.4736', fbc_FormulaEvaluator.parseFormula('LOG(34.0000) - 4', stringContext), 'Formula VALUE');
        System.assertEquals('7.5264', fbc_FormulaEvaluator.parseFormula('LOG(34.0000) + 4', stringContext), 'Formula VALUE');
    }

    public class ContextWrapper {
        public String name;
        public String value;

        public ContextWrapper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }
}
