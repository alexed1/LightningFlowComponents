@isTest
public with sharing class DateMatcherTests {


    

    @isTest
    public static void CanAnalyzeWordDate(){

        //returns the time in the locale time zone
        DateMatcher.DateDescription todayDateDescription = DateMatcher.generateDateDescriptionForToday();

        DateMatcher.DateDescription testDateDescription = new DateMatcher.DateDescription();

        testDateDescription.weekInMonthOrdinal=todayDateDescription.weekInMonthOrdinal;
        testDateDescription.dayInMonthOrdinal=todayDateDescription.dayInMonthOrdinal;
        testDateDescription.weekdayNumber=todayDateDescription.weekdayNumber;
        testDateDescription.monthInYearOrdinal=todayDateDescription.monthInYearOrdinal;


        DateMatcher.DateAnalysisResult dateAnalysis = DateMatcher.AnalyzeWeekdayOfSpecificMonth(testDateDescription.weekInMonthOrdinal, testDateDescription.weekdayNumber, testDateDescription.monthInYearOrdinal);
        System.assertEquals(true, dateAnalysis.matchesDateTime);

        testDateDescription.weekdayNumber= testDateDescription.weekdayNumber+1;
        dateAnalysis = DateMatcher.AnalyzeWeekdayOfSpecificMonth(testDateDescription.weekInMonthOrdinal, testDateDescription.weekdayNumber, testDateDescription.monthInYearOrdinal);
        System.assertEquals(false, dateAnalysis.matchesDateTime);

        dateAnalysis = DateMatcher.AnalyzeDayOrdinalDate(testDateDescription.dayInMonthOrdinal, testDateDescription.monthInYearOrdinal);


    }

}
