@IsTest
private class BusinessHoursIsWithinActionTest {
    @IsTest
    static void test() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE];

        BusinessHoursIsWithinAction.Input input = new BusinessHoursIsWithinAction.Input();
        input.businessHoursId = bh.Id;
        input.targetDate = System.today();

        Test.startTest();
        List<Boolean> result = BusinessHoursIsWithinAction.execute(new List<BusinessHoursIsWithinAction.Input>{ input });
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0]);
    }
}
