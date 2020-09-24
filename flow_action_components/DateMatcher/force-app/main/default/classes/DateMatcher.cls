public with sharing class DateMatcher {
    

    @InvocableMethod(configurationEditor='c:dateMatcherCPE')
    public static List<Results> crunch (List<Request> requestList) {
        System.debug('entering DateMatcher');
        List<Results> responseWrapper = new List<Results>();
        for (Request curRequest : requestList) {
            Results curResult = new Results();
            DateAnalysisResult curAnalysis;

            switch on curRequest.testType {
                when 'NthWeekdayOfSpecificMonth' {
                    Integer inputWeekOfMonthNumber = Integer.valueOf(curRequest.weekOfMonthNumber);
                    Integer dayOfWeekNumber = Integer.valueOf(curRequest.dayOfWeekNumber);
                    Integer monthOfYearNumber = Integer.valueOf(curRequest.monthOfYearNumber);
                    curAnalysis = AnalyzeWeekdayOfSpecificMonth(inputWeekOfMonthNumber, dayOfWeekNumber, monthOfYearNumber);
                
                
                }
                when 'NthDayOfMonth' {
                    Integer monthOfYearNumber = Integer.valueOf(curRequest.monthOfYearNumber);
                    Integer dayOfMonthNumber = Integer.valueOf(curRequest.dayOfMonthNumber);
                    curAnalysis = AnalyzeDayOrdinalDate( dayOfMonthNumber, monthOfYearNumber);
                }
                when 'NthWeekdayOfAnyMonth' {
                    Integer inputWeekOfMonthNumber = Integer.valueOf(curRequest.weekOfMonthNumber);
                    Integer dayOfWeekNumber = Integer.valueOf(curRequest.dayOfWeekNumber);
                    curAnalysis = AnalyzeWeekdayOfAnyMonth(inputWeekOfMonthNumber, dayOfWeekNumber);
                }
            }
           

            if (curAnalysis.matchesDateTime == true) {
                curResult.matches = true;
            }

            responseWrapper.add(curResult);
        }     
     
        return responseWrapper;
    
    }

    public static  DateAnalysisResult AnalyzeWeekdayOfSpecificMonth(integer weekOfMonthNumber, integer weekdayNumber, integer monthNumber) {
        System.debug('entering AnalyzeWeekOrdinalDate');
        DateAnalysisResult curAnalysis = new DateAnalysisResult();

        // does the passed in date match today? 
        DateDescription todayDateDescription = generateDateDescriptionForToday();
        Boolean dateMatched = true;
        //is the week a match?
        if (weekOfMonthNumber != todayDateDescription.weekInMonthOrdinal)
            dateMatched = false;

        //is the month a match?
        if(monthNumber != todayDateDescription.monthInYearOrdinal)
            dateMatched = false;

        //is the day a match?
        if(weekdayNumber != todayDateDescription.weekdayNumber)
            dateMatched = false;
    
        curAnalysis.matchesDateTime = dateMatched;
        return curAnalysis;

    }

    public static  DateAnalysisResult AnalyzeWeekdayOfAnyMonth(integer weekOfMonthNumber, integer weekdayNumber) {
        System.debug('entering AnalyzeWeekOrdinalDate');
        DateAnalysisResult curAnalysis = new DateAnalysisResult();

        // does the passed in date match today? 
        DateDescription todayDateDescription = generateDateDescriptionForToday();
        Boolean dateMatched = true;
        //is the week a match?
        if (weekOfMonthNumber != todayDateDescription.weekInMonthOrdinal)
            dateMatched = false;

        //is the day a match?
        if(weekdayNumber != todayDateDescription.weekdayNumber)
            dateMatched = false;
    
        curAnalysis.matchesDateTime = dateMatched;
        return curAnalysis;

    }

    

     public static  DateAnalysisResult AnalyzeDayOrdinalDate(integer dayOfMonthNumber, integer monthNumber) {
        System.debug('entering AnalyzeDayOrdinalDate');
        DateAnalysisResult curAnalysis = new DateAnalysisResult();

        DateDescription todayDateDescription = generateDateDescriptionForToday();
        Boolean dateMatched = true;
                
        //is the month a match?
        if(monthNumber != todayDateDescription.monthInYearOrdinal)
        dateMatched = false;

        //is the day a match?
        if(dayOfMonthNumber != todayDateDescription.dayInMonthOrdinal)
            dateMatched = false;

        curAnalysis.matchesDateTime = dateMatched;
        return curAnalysis;

    } 

    public static DateMatcher.DateDescription generateDateDescriptionForToday() {
        DateMatcher.DateDescription todayDateDescription = new DateMatcher.DateDescription();
        Date todayDate = Date.today();

        DateTime todayDateTime = (DateTime) todayDate;
         todayDateTime = DateTime.now();
        System.debug ('today is: ' + todayDateTime);
        
        todayDateDescription.weekdayNumber = Integer.valueOf(todayDateTime.format('u'));
        todayDateDescription.weekInMonthOrdinal =  Integer.valueOf(todayDateTime.format('F'));
        todayDateDescription.dayInMonthOrdinal =  Integer.valueOf(todayDateTime.format('dd'));
        todayDateDescription.monthInYearOrdinal =  Integer.valueOf(todayDateTime.format('MM'));
        System.debug('today is: ' + todayDateDescription);
        return todayDateDescription;
    }
    public  class DateAnalysisResult {

        public Boolean matchesDateTime;

    }

    public class DateDescription {

        public Integer weekInMonthOrdinal;
        public Integer dayInMonthOrdinal;
        public Integer weekdayNumber;
        public Integer monthInYearOrdinal;

    }

    public class Request {
      
        @InvocableVariable
        public String testType; //supported values: 'NthWeekdayOfSpecificMonth', 'NthDayOfMonth'

        @InvocableVariable
        public String dayOfWeekNumber;

        @InvocableVariable
        public String weekOfMonthNumber;

        @InvocableVariable
        public String monthOfYearNumber;

        @InvocableVariable
        public String dayOfMonthNumber;
  
          
      }
      
      public class Results {
          @InvocableVariable
          public String errors;
  
          @InvocableVariable
          public Boolean matches;
  
  
      }
  
      public class InvocableActionException extends Exception {}
}
