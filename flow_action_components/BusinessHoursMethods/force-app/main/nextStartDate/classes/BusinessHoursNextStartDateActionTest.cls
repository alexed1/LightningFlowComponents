@IsTest
private class BusinessHoursNextStartDateActionTest {
    @IsTest
    static void test() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE];

        BusinessHoursNextStartDateAction.Input input = new BusinessHoursNextStartDateAction.Input();
        input.businessHoursId = bh.Id;
        input.targetDate = System.today();

        Test.startTest();
        List<Datetime> result = BusinessHoursNextStartDateAction.execute(new List<BusinessHoursNextStartDateAction.Input>{ input });
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0]);
    }
}
