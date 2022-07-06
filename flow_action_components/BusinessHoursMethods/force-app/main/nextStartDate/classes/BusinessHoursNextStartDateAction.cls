public inherited sharing class BusinessHoursNextStartDateAction {
    @InvocableMethod(label='Next start date/time' category='Business Hours')
    public static List<Datetime> execute(List<Input> inputs) {
        List<Datetime> result = new List<Datetime>();

        for (Input input : inputs) {
            result.add(execute(input));
        }

        return result;
    }

    private static Datetime execute(Input input) {
        return BusinessHours.nextStartDate(input.businessHoursId, input.targetDate);
    }

    public class Input {
        @InvocableVariable(label='Business Hours ID' required=true)
        public Id businessHoursId;
        @InvocableVariable(label='Target Date' required=true)
        public Datetime targetDate;
    }
}
