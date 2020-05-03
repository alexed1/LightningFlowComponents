public with sharing class ConvertRecordsToCSVFile {

       
        ///was bulkifying but probably will never finish because of the CapTech version
        @InvocableMethod(label='Convert Record Collection to CSV file' description='Pass a list of records and get a CSV file as output')
        public static FlowActionOutput[] recordCollectionToCSVConverter( FlowActionInput[] lstInputs ) {
            for (FlowActionInput curInput : lstInputs) {
                Map<String,String> mapfieldApiNameToLabel = getFieldApiNameToLabelMap(lstInputs[0].strObjectApiName);
                String strFileTitle = curInput.strFileTitle;
                Boolean boolAddTimeStamp = curInput.boolAddTimeStamp;
                FlowActionOutput[] lstOutput = new FlowActionOutput[]{};
                ContentVersion[] curContentVersionList = new ContentVersion[]{};
                for(FlowActionInput input : lstInputs) {
                    String strTitle = strFileTitle + (boolAddTimeStamp ? ' '+ System.now() : '');
                    ContentVersion cv = new ContentVersion(
                        Title = strTitle,
                        VersionData = createCSVBlob(mapfieldApiNameToLabel,input.lstRecords),
                        PathOnClient = strTitle+'.csv'
                    );
                    curContentVersionList.add(cv);
                }

                insert curContentVersionList;

            }
           
            
            
           
            
    
            for(ContentVersion file : [ SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id IN: lstFilesToUpload] ) {
                FlowActionOutput output = new FlowActionOutput();
                output.strContentDocumentId = file.ContentDocumentId;
                lstOutput.add(output);
            }
            return lstOutput;
        }
    
        static Blob createCSVBlob(Map<String,String> mapfieldApiNameToLabel, SObject[] lstRecords) {
            String csvStringContent;
            Blob csvBlobContent;
            List<String> lstFieldApiNames = new List<String>(mapfieldApiNameToLabel.keySet());
            Integer intFieldListSize = lstFieldApiNames.size();
            Integer intRecordListSize = lstRecords.size();  
    
            String csvHeader = String.join( mapfieldApiNameToLabel.values(), ',') + '\n';
            csvStringContent = csvHeader;
            
            for(Integer i = 0; i < intRecordListSize; i++) {
                SObject obj = lstRecords[i];
                for(Integer j = 0; j <intFieldListSize; j++) {
                    String fieldApiName = lstFieldApiNames[j];
                    Object fieldValue = obj.get(fieldApiName);
                    System.debug(fieldApiName);
                    System.debug(fieldValue);
                    if(fieldValue != NULL && fieldValue Instanceof String) {
                        csvStringContent = csvStringContent+ ((String)fieldValue).escapeCsv();
                    }else {
                        csvStringContent = csvStringContent +'';
                    }
                    if( j < intFieldListSize-1 ) {
                        csvStringContent += + ',';
                    }
                }
                if( i < intRecordListSize-1 ) {
                    csvStringContent += '\n';
                }
                System.debug(csvStringContent);
            }
            System.debug(csvStringContent);
            return Blob.valueOf(csvStringContent);
        }
    
        static Map<String,String> getFieldApiNameToLabelMap(String strObjectApiName){
            Map<String,String> mapfieldApiNameToLabel = new Map<String,String>();
            System.Type objType = Type.forName(strObjectApiName);
            if(objType == NULL) {
                throw new FlowCustomException('Error: Invalid Object API name.');
            }
            SObject sObj = (SObject)objType.newInstance();
            
            SObjectType sObjType = sObj.getSObjectType();
            
            for(Schema.SObjectField field : sObjType.getDescribe().fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescription = field.getDescribe();
                mapfieldApiNameToLabel.put(fieldDescription.getName(), fieldDescription.getLabel());
            }
    
            return mapfieldApiNameToLabel;
        }

        public class FlowActionInput {
            @InvocableVariable(label='Object API Name' required = true)
            public String strObjectApiName;
    
            @InvocableVariable(label='Save file with name' required = true)
            public String strFileTitle;
    
            @InvocableVariable(label='Add time stamp to the file name?'  )
            public Boolean boolAddTimeStamp;
    
            @InvocableVariable(label='List of Records' required = true)
            public SObject[] lstRecords;
        }
    
        public class FlowActionOutput {
            @InvocableVariable
            public String strContentDocumentId;
        }
    
        public class FlowCustomException extends Exception{}
        
    }
    