@IsTest
private class BusinessHoursAddActionTest {
    @IsTest
    static void test() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE];

        BusinessHoursAddAction.Input input = new BusinessHoursAddAction.Input();
        input.businessHoursId = bh.Id;
        input.intervalSeconds = 3600;
        input.startDate = System.now();

        Test.startTest();
        List<Datetime> result = BusinessHoursAddAction.execute(new List<BusinessHoursAddAction.Input>{ input });
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0]);
    }
}
