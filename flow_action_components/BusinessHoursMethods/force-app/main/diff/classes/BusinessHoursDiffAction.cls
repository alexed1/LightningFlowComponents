public inherited sharing class BusinessHoursDiffAction {
    @InvocableMethod(label='Difference between two business hours (in seconds)' category='Business Hours')
    public static List<Integer> execute(List<Input> inputs) {
        List<Integer> result = new List<Integer>();

        for (Input input : inputs) {
            result.add(execute(input));
        }

        return result;
    }

    private static Integer execute(Input input) {
        return Integer.valueOf(BusinessHours.diff(input.businessHoursId, input.startDate, input.endDate) / 1000);
    }

    public class Input {
        @InvocableVariable(label='Business Hours ID' required=true)
        public Id businessHoursId;
        @InvocableVariable(label='Start Date' required=true)
        public Datetime startDate;
        @InvocableVariable(label='End Date' required=true)
        public Datetime endDate;
    }
}
