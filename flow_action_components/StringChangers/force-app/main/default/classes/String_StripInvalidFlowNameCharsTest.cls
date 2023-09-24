@isTest
public with sharing class String_StripInvalidFlowNameCharsTest {
       
            
            @isTest
            public static void String_StripInvalidFlowNameCharsTest() {

                string inputString = 'QuickEmailFlow_test-khg0mhe7pjlb@example.com_2022-10-30 18:44:07Z';
                String_StripInvalidFlowNameChars.Request testRequest = new String_StripInvalidFlowNameChars.Request();
                List<String_StripInvalidFlowNameChars.Request> testRequestList = new List<String_StripInvalidFlowNameChars.Request>();
        
                testRequest.inputStr = inputString;
                testRequestList.add(testRequest);
                List<String_StripInvalidFlowNameChars.Result>  testResponseList =String_StripInvalidFlowNameChars.execute(testRequestList) ;
               
                String outputString = testResponseList[0].outputStr;
               

               System.assertEquals('QuickEmailFlow_testkhg0mhe7pjlbexamplecom_20221030184407Z', outputString);
        
            }
        }
        