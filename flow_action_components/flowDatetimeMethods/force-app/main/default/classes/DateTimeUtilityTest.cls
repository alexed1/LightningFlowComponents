@isTest
public class DateTimeUtilityTest {
    static testMethod void testDatetimeMethods(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt40', 
                            Email='standarduser123@testorg123.com', 
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_AU', 
                            ProfileId = p.Id, 
                            TimeZoneSidKey='Australia/Sydney', 
                            UserName='standarduser4387549387589435@testorg.com.tyrr');

        System.runAs(u){ // to ensure the user locale is aligned to the expected test results
        
            DateTimeUtility.DateTimeRequest req = new DateTimeUtility.DateTimeRequest();
            req.methodName = 'Datetime.addDays';
            req.dateTimeString = '1/1/2021, 3:47 pm'; // flow datetime string format
            req.increment = 1;
            req.returnFormat = null;
            req.timeZone = null;
            
            Test.startTest();
                List<DateTimeUtility.DateTimeRequestResponse> results = 
                    DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-01-02 15:47:00',
                                    results[0].result,
                                    'addDays didnt return what we expected');
            
                req.methodName = 'Datetime.addHours';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-01-01 16:47:00',
                                    results[0].result,
                                    'addHours didnt return what we expected');

                req.dateTimeString = '1/1/2021, 3:47 pm';
                req.methodName = 'Datetime.addMinutes';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-01-01 15:48:00',
                                    results[0].result,
                                    'addMinutes didnt return what we expected');
            
                req.dateTimeString = '1/1/2021, 3:47 pm';
                req.methodName = 'Datetime.addSeconds';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-01-01 15:47:01',
                                    results[0].result,
                                    'addSeconds didnt return what we expected');
            
                req.dateTimeString = '1/1/2021, 3:47 pm';
                req.methodName = 'Datetime.addMonths';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-02-01 15:47:00',
                                    results[0].result,
                                    'addMonths didnt return what we expected');
            
                req.dateTimeString = '1/1/2021, 3:47 pm';
                req.methodName = 'Datetime.addYears';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2022-01-01 15:47:00',
                                    results[0].result,
                                    'addYears didnt return what we expected');
            
                req.dateTimeString = '1/1/2021, 3:47 pm';
                req.methodName = 'Datetime.formatGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // not going to test this one as dont feel need to verify system method works.

                req.methodName = 'Datetime.format';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021-01-01 15:47:00',
                                    results[0].result,
                                    'format didnt return what we expected');
            
                req.timezone = 'non-existant';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals(false,results[0].errorOccured,
                                    'format should just defaulted to gmt if bad timezone');
            
                req.timezone = 'Australia/Sydney';
                string res1 = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req})[0].result;
                // not asserting - simple method call
                
                req.timezone = 'America/Los_Angeles';
                string res2 = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req})[0].result;
                // not asserting - simple method call

                req.methodName = 'invalidMethod';
                try{
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                }
                catch(DateTimeUtility.DateTimeUtilityException e){}
                    
            
                req.methodName = 'Datetime.formatLong';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // not going to test this one as dont feel need to verify system method works.
                
                req.methodName = 'Datetime.getTime';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1609476420000', 
                                    results[0].result,
                                    'should have converted to ms');

                req.methodName = 'Datetime.time';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('15:47:00.000Z',
                                    results[0].result,
                                    'should have retrieved time portion' );
                
                req.methodName = 'Datetime.timeGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                
                req.methodName = 'Datetime.year';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021',
                                    results[0].result,
                                    'should have retrieved year' );
                
                req.methodName = 'Datetime.hour';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('15',
                                    results[0].result,
                                    'should have retrieved hour' );
                
                req.methodName = 'Datetime.minute';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('47',
                                    results[0].result,
                                    'should have retrieved minutes' );
                
                req.methodName = 'Datetime.second';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('0',
                                    results[0].result,
                                    'should have retrieved seconds' );
                

                req.methodName = 'Datetime.yearGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // no assert - simple method call 

                req.methodName = 'Datetime.monthGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // no assert - simple method call 

                req.methodName = 'Datetime.dayGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // no assert - simple method call 

                req.methodName = 'Datetime.hourGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                // wont assert this one - not running in specific user context

                req.methodName = 'Datetime.minuteGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('47',
                                    results[0].result,
                                    'should have retrieved minutes' );
                

                req.methodName = 'Datetime.secondGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('0',
                                    results[0].result,
                                    'should have retrieved seconds' );
                
                req.methodName = 'Datetime.month';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1',
                                    results[0].result,
                                    'should have retrieved month' );
                
                req.methodName = 'Datetime.day';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1',
                                    results[0].result,
                                    'should have retrieved day' );
                
                req.methodName = 'Datetime.millisecond';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('0',
                                    results[0].result,
                                    'should have retrieved milliseconds' );
                
                req.methodName = 'Datetime.millisecondGmt';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('0',
                                    results[0].result,
                                    'should have retrieved milliseconds in Gmt' );
                
                req.methodName = 'Datetime.now';
                req.returnFormat = 'd MMM yy, h:m a';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                
                /*** testing of date methods */

                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.addDays';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2/1/2021',
                                    results[0].result,
                                    'should have iterated a day' );

                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.addMonths';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1/2/2021',
                                    results[0].result,
                                    'should have iterated a month' );

                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.addYears';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1/1/2022',
                                    results[0].result,
                                    'should have iterated a year' );

                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.day';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1',
                                    results[0].result,
                                    'should have returned day of week for date' );
                
                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.year';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('2021',
                                    results[0].result,
                                    'should have returned year for date' );


                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.dayOfYear';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1',
                                    results[0].result,
                                    'should have returned day of year for date' );

                
                req.dateTimeString = '01/01/2021';
                req.secondDateString = '02/01/2021';
                req.methodName = 'Date.daysBetween';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1',
                                    results[0].result,
                                    'should have returned delta of 1 day' );
                
                req.dateTimeString = '01/01/2021';
                req.secondDateString = '01/01/2022';
                req.methodName = 'Date.monthsBetween';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('12',
                                    results[0].result,
                                    'should have returned delta of 1 day' );
                
                                                        
                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.daysInMonth';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('31',
                                    results[0].result,
                                    'should have returned days in month for date' );
                        
                req.dateTimeString = '01/01/2021';
                req.methodName = 'Date.isLeapYear';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('false',
                                    results[0].result,
                                    'should have returned false result for year' );
                
                req.dateTimeString = '';
                req.methodName = 'Date.today';
                req.returnFormat = 'dd-MM-yy';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals(Date.today().format(),
                                    results[0].result,
                                    'should have returned todays date' );

                req.dateTimeString = '10/01/2021';
                req.methodName = 'Date.toStartOfMonth';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('1/1/2021',
                                    results[0].result,
                                    'should have returned to first day of month' );
                
                req.dateTimeString = '11/01/2021';
                req.methodName = 'Date.toStartOfWeek';
                results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                System.assertEquals('10/1/2021',
                                    results[0].result,
                                    'should have returned to first day of week' );                    
                /**** optional testing of the BusinessHours logic only if business hours setup */

                id defaultBHours;
                try{
                    defaultBHours = DateTimeUtility.defaultBusinessHoursId; // will throw error if b hours not setup
                } catch (exception e){
                    System.debug('** No Business Hours setup so testing of these methods will be bypassed at expense of coverage % **');
                }
                system.debug('def business hts'+defaultBHours);
                if(defaultBHours != null){
                    // execute additional tests that rely on business hours being setup
                    req.dateTimeString = '1/1/2021, 3:47 pm';
                    req.methodName = 'BusinessHours.add';
                    req.returnFormat = 'd MMM yy, h:m a';
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                    System.assertNotEquals('', results[0].result,'BusinessHours add should have returned a result');
                    // not checking result as is simple system method. just conditional coverage and error handling

                    req.methodName = 'BusinessHours.addGmt';
                    req.returnFormat = 'd MMM yy, h:m a';
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                    System.assertNotEquals('', results[0].result,'BusinessHours Gmt should have returned a result');
                    // not checking result as is simple system method. just conditional coverage and error handling

                    req.methodName = 'BusinessHours.isWithin';
                    req.returnFormat = 'd MMM yy, h:m a';
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                    System.assert(results[0].result == 'true' || results[0].result == 'false','BusinessHours isWithin should have returned a result');
                    // not checking result as is simple system method. just conditional coverage and error handling
                
                    try{
                        req.methodName = 'BusinessHours.diff';
                        req.returnFormat = 'd MMM yy, h:m a';
                        results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                        // not checking result as is simple system method. just conditional coverage and error handling
                        system.assertEquals(true,false,'BusinessHours.diff should have thrown error');
                    } catch (exception e){
                        // catch error and move on as did what was required.
                    }
                    req.methodName = 'BusinessHours.diff';
                    req.returnFormat = 'd MMM yy, h:m a';
                    req.secondDateString = '10/1/2021, 9:00 am';
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                    System.assert(results[0].errorOccured == false,'BusinessHours diff should have returned a result');
                    // not checking result as is simple system method. just conditional coverage and error handling

                    req.methodName = 'BusinessHours.nextStartDate';
                    req.returnFormat = 'd MMM yy, h:m a';
                    results = DateTimeUtility.methods(new List<DateTimeUtility.DateTimeRequest>{req});
                    System.assert(results[0].result != '','BusinessHours nextStartDate should have returned a result');
                    // not checking result as is simple system method. just conditional coverage and error handling
                }

            Test.stopTest();
        }
    }

    

    

    
}
