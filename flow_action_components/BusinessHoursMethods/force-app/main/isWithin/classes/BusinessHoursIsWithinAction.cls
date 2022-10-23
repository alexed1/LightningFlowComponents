public inherited sharing class BusinessHoursIsWithinAction {
    @InvocableMethod(label='Is within business hours' category='Business Hours')
    public static List<Boolean> execute(List<Input> inputs) {
        List<Boolean> result = new List<Boolean>();

        for (Input input : inputs) {
            result.add(execute(input));
        }

        return result;
    }

    private static Boolean execute(Input input) {
        return BusinessHours.isWithin(input.businessHoursId, input.targetDate);
    }

    public class Input {
        @InvocableVariable(label='Business Hours ID' required=true)
        public Id businessHoursId;
        @InvocableVariable(label='Target Date' required=true)
        public Datetime targetDate;
    }
}
