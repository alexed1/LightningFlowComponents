public inherited sharing class BusinessHoursAddGmtAction {
    @InvocableMethod(label='Add seconds (GMT)' category='Business Hours')
    public static List<Datetime> execute(List<Input> inputs) {
        List<Datetime> result = new List<Datetime>();

        for (Input input : inputs) {
            result.add(execute(input));
        }

        return result;
    }

    private static Datetime execute(Input input) {
        Long millis = input.intervalSeconds * 1000;
        return BusinessHours.add(input.businessHoursId, input.startDate, millis);
    }

    public class Input {
        @InvocableVariable(label='Business Hours ID' required=true)
        public Id businessHoursId;
        @InvocableVariable(label='Start Date' required=true)
        public Datetime startDate;
        @InvocableVariable(label='Interval (seconds)' required=true)
        public Integer intervalSeconds;
    }
}
