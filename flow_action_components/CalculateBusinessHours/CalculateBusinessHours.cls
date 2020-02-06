public class CalculateBusinessHours {
    public class inputTime
    {
        @InvocableVariable(label='Business Hours Id' required = true)
        public String businessHoursId;
        @InvocableVariable(label='Start Date' required = true)
        public DateTime startDate;
        @InvocableVariable(label='End Date' required = true)
        public DateTime endDate;
    }

    public class outputTime
    {
        @InvocableVariable (label='Result (in millisecond)')
        public long diffResult;
        @InvocableVariable (label='Result (in second)')
        public long diffResultSec;
        @InvocableVariable (label='Result (in minute)')
        public long diffResultMin;

    }
    @InvocableMethod(label='Professor Flow | Calculate Business Hours Difference' description='Returns the difference in milliseconds,second or minute between a start and end Datetime based on a specific set of business hours.')
    public static List<outputTime> getMilliSecondDiff(List<inputTime> inputParams)
    {
        List<outputTime> finalList = new List<outputTime>();
        long diffinms = 0;
        //use utility method in businesshours
        if(inputParams != null && inputParams.size() > 0)
        {
            for(inputTime pf: inputParams)
            {
                diffinms = BusinessHours.diff(pf.businessHoursId,pf.startDate,pf.endDate);
                outputTime resp = new outputTime();
                resp.diffResult = diffinms;
                resp.diffResultSec = diffinms / 1000 ;
                resp.diffResultMin = diffinms / 60000 ;
                finalList.add(resp);
            }
        }
        return finalList;
    }
}