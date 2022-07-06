@IsTest
private class BusinessHoursDiffActionTest {
    @IsTest
    static void test() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE];

        BusinessHoursDiffAction.Input input = new BusinessHoursDiffAction.Input();
        input.businessHoursId = bh.Id;
        input.startDate = System.now();
        input.endDate = System.now().addDays(7);

        Test.startTest();
        List<Integer> result = BusinessHoursDiffAction.execute(new List<BusinessHoursDiffAction.Input>{ input });
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0]);
    }
}
