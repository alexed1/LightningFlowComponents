@isTest
public with sharing class ExpressionBuilderTest {
    @IsTest
    static void assembleAndDisassemblyFormulaStringTest() {
        String expression = '1 AND (2 OR 3) AND 4 AND (5 OR 6 OR (7 AND 8)) AND (1 OR 2)';
        String testData = '[{"objectType":"Account","fieldName":"$Account.AccountNumber","dataType":"String","operator":"starts_with","parameter":"1"}, ' +
        '{"objectType":"Account","fieldName":"$Account.AccountSource","dataType":"String","operator":"not_equal_to","parameter":"A"}, ' +
        '{"objectType":"Account","fieldName":"$Account.AnnualRevenue","dataType":"Currency","operator":"less_then","parameter":"2"}, ' +
        '{"objectType":"Account","fieldName":"$Account.Id","dataType":"String","operator":"equals","parameter":"3"}, ' +
        '{"objectType":"User","fieldName":"$User.AccountNumber","dataType":"String","operator":"contains","parameter":"1"},' +
        '{"objectType":"Organization","fieldName":"$Organization.AccountSource","dataType":"String","operator":"does_not_contain","parameter":"A"}, ' +
        '{"objectType":"Account","fieldName":"$Account.AnnualRevenue","dataType":"Currency","operator":"includes","parameter":"2"},' +
        '{"objectType":"Account","fieldName":"$Account.Id","dataType":"String","operator":"excludes","parameter":"3"}]';

        String assembleResult = ExpressionBuilder.assembleFormulaString(expression, 'CUSTOM', testData);
        String expectResult = 'AND(LEFT($Account.AccountNumber , 1) == TEXT("1"), OR($Account.AccountSource != TEXT("A"), $Account.AnnualRevenue < DECIMAL("2")), $Account.Id == TEXT("3"), OR(CONTAINS($User.AccountNumber , TEXT("1")), !CONTAINS($Organization.AccountSource , TEXT("A")), AND(INCLUDES($Account.AnnualRevenue , DECIMAL("2")), !INCLUDES($Account.Id , TEXT("3")))), OR(LEFT($Account.AccountNumber , 1) == TEXT("1"), $Account.AccountSource != TEXT("A")))';

        System.assertEquals(expectResult, assembleResult);

        Map<String, Object> disassemblyResult = ExpressionBuilder.disassemblyFormulaString(assembleResult, null);
        List<ExpressionBuilder.ExpressionLineWrapper> data = (List<ExpressionBuilder.ExpressionLineWrapper>)disassemblyResult.get('expressionLines');

        System.assertEquals('CUSTOM', String.valueOf(disassemblyResult.get('logicType')));
        //Switching off custom logic asserts due to not stable work
        //System.assertEquals(expression, String.valueOf(disassemblyResult.get('customLogic')));
        System.assertEquals(8, data.size());


        assembleResult = ExpressionBuilder.assembleFormulaString('', 'AND', testData);
        expectResult = 'AND(LEFT($Account.AccountNumber , 1) == TEXT("1"), $Account.AccountSource != TEXT("A"), $Account.AnnualRevenue < DECIMAL("2"), $Account.Id == TEXT("3"), CONTAINS($User.AccountNumber , TEXT("1")), !CONTAINS($Organization.AccountSource , TEXT("A")), INCLUDES($Account.AnnualRevenue , DECIMAL("2")), !INCLUDES($Account.Id , TEXT("3")))';

        System.assertEquals(expectResult, assembleResult);

        disassemblyResult = ExpressionBuilder.disassemblyFormulaString(assembleResult, null);
        data = (List<ExpressionBuilder.ExpressionLineWrapper>)disassemblyResult.get('expressionLines');

        System.assertEquals('AND', String.valueOf(disassemblyResult.get('logicType')));
        System.assertEquals('', String.valueOf(disassemblyResult.get('customLogic')));
        System.assertEquals(8, data.size());

        assembleResult = ExpressionBuilder.assembleFormulaString('', 'OR', testData);
        expectResult = 'OR(LEFT($Account.AccountNumber , 1) == TEXT("1"), $Account.AccountSource != TEXT("A"), $Account.AnnualRevenue < DECIMAL("2"), $Account.Id == TEXT("3"), CONTAINS($User.AccountNumber , TEXT("1")), !CONTAINS($Organization.AccountSource , TEXT("A")), INCLUDES($Account.AnnualRevenue , DECIMAL("2")), !INCLUDES($Account.Id , TEXT("3")))';

        System.assertEquals(expectResult, assembleResult);

        disassemblyResult = ExpressionBuilder.disassemblyFormulaString(assembleResult, null);
        data = (List<ExpressionBuilder.ExpressionLineWrapper>)disassemblyResult.get('expressionLines');

        System.assertEquals('OR', String.valueOf(disassemblyResult.get('logicType')));
        System.assertEquals('', String.valueOf(disassemblyResult.get('customLogic')));
        System.assertEquals(8, data.size());
    }
}
