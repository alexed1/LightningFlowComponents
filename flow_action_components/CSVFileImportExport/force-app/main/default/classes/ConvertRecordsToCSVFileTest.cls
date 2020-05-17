
    @isTest
    public with sharing class ConvertRecordsToCSVFileTest {
        
        @testSetup
        static void createData(){
    
            Account[] lstAccounts = new Account[]{
                new Account(Name = 'CSV Acc1', AnnualRevenue = NULL, AccountNumber = '', NumberOfEmployees = NULL, Rating = 'Hot'),
                new Account(Name = 'CSV Acc2', AnnualRevenue = 1000, AccountNumber = '911', NumberOfEmployees = 0, Rating = 'Warm'),
                new Account(Name = 'CSV Acc3', AnnualRevenue = 911007, AccountNumber = '007',NumberOfEmployees = 10,Rating = 'Cold')
            };
    
            insert lstAccounts;
            
        }
    
        @isTest
        static void testRecordCollectionToCSVConverterMethod(){
            
            ConvertRecordsToCSVFile.FlowActionInput[] lstInputs = createFlowInputsList();
            
            Test.startTest();
            ConvertRecordsToCSVFile.recordCollectionToCSVConverter(lstInputs);
            Test.stopTest();
    
            ContentVersion uploadedCSV = [SELECT Id,Title,FileExtension FROM ContentVersion];
    
            System.assert(uploadedCSV != NULL, 'No file found');
            System.assert(uploadedCSV.Title == lstInputs[0].strFileTitle, 'File not found: '+lstInputs[0].strFileTitle);
            System.assert(uploadedCSV.FileExtension == 'csv', 'Uploaded file not of CSV type');
            
        }
    
        @isTest
        static void TestGetFieldApiNameToLabelMapException(){
    
            ConvertRecordsToCSVFile.FlowActionInput[] lstInputs = createFlowInputsList();
            lstInputs[0].strObjectApiName='InvalidObject';
            Test.startTest();
            try {
                ConvertRecordsToCSVFile.recordCollectionToCSVConverter(lstInputs);
            } catch (Exception e) {
                System.assert(
                    e.getMessage() == 'Error: Invalid Object API name.', 
                    'Exception message mismatch!'
                );
            }
            Test.stopTest();
            
        }
    
        static ConvertRecordsToCSVFile.FlowActionInput[] createFlowInputsList(){
            
            ConvertRecordsToCSVFile.FlowActionInput[] flowInputs = new ConvertRecordsToCSVFile.FlowActionInput[]{};
            ConvertRecordsToCSVFile.FlowActionInput input = new ConvertRecordsToCSVFile.FlowActionInput();
            input.strObjectApiName = 'Account';
            input.lstRecords = Database.query(getQuery(input.strObjectApiName));
            input.strFileTitle = 'Accounts List';
            input.boolAddTimeStamp = false;
            flowInputs.add(input);
    
            return flowInputs;
        }
    
        static String getQuery(String strObjectApiName) {
            String strQuery = 'SELECT';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(strObjectApiName).getDescribe().fields.getMap();
    
            for(String fieldApiName : objectFields.keySet()) {
                strQuery += ' ' + fieldApiName + ', ';
            }
            strQuery = strQuery.subString(0,strQuery.trim().Length()-1); // Removing the last comma
    
            strQuery += ' FROM ' + strObjectApiName;
            
            return strQuery;
        }
    
    }
