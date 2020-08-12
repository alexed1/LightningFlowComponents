/**
 * ConvertDatetoDatetimeFlowAction.cls
 * 
 * Created By:  Eric Smith
 * 
 * Version 1.0  07/22/20    Eric Smith
 * 
 * This Flow Action can be used to convert a Date value to a Datetime value.  
 * The default time of the return value is 12:00am.
 * Option values can be passed in to set the time to a particular Hour, Minute and Second.
 * 
 * 
 **/
public with sharing class ConvertDateToDatetimeFlowAction {

    // Attributes passed in from the Flow
    public class Requests {

        @InvocableVariable(label='Date Value')
        public Date dateValue;

        @InvocableVariable(label='Hour Value (Default = 0)')
        public Integer hourValue;

        @InvocableVariable(label='Minute Value (Default = 0)')
        public Integer minuteValue;
        
        @InvocableVariable(label='Second Value (Default = 0)')
        public Integer secondValue;
        
    }

    // Attributes passed back to the Flow
    public class Results {

        @InvocableVariable
        public DateTime datetimeValue;

    }

    // Expose this Action to the Flow
    @InvocableMethod
    public static List<Results> convertDateToDatetime(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            Date dateValue = req.dateValue;
            Integer hourValue = 0;
            Integer minuteValue = 0;
            Integer secondValue = 0;
            if (req.hourValue != null) {
                hourValue = req.hourValue;
            }
            if (req.minuteValue != null) {
                minuteValue = req.minuteValue;
            }
            if (req.secondValue != null) {
                secondValue = req.secondValue;
            }

// BEGIN APEX ACTION PROCESSING LOGIC

            Integer d = dateValue.day();
            Integer m = dateValue.month();
            Integer y = dateValue.year();
            DateTime datetimeValue = DateTime.newInstance(y, m, d, hourValue, minuteValue, secondValue);

// END APEX ACTION PROCESSING LOGIC

            // Set Output Values
            response.datetimeValue = datetimeValue;
            responseWrapper.add(response);

        }
        // Return values back to the Flow
        return responseWrapper;
    }

}
