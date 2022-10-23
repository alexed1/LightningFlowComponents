@IsTest
private class BusinessHoursAddGmtActionTest {
    @IsTest
    static void test() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE];

        BusinessHoursAddGmtAction.Input input = new BusinessHoursAddGmtAction.Input();
        input.businessHoursId = bh.Id;
        input.intervalSeconds = 3600;
        input.startDate = System.now();

        Test.startTest();
        List<Datetime> result = BusinessHoursAddGmtAction.execute(new List<BusinessHoursAddGmtAction.Input>{ input });
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0]);
    }
}
