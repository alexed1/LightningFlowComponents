public with sharing class ConvertCSVToRecords {

        @InvocableMethod(label='Convert CSV File to Records')
        public static Response[] convert (Request[] inputs) {
            Response[] responseList = new Response[]{};
            
            for (Request curInput : inputs) {
        
                if (curInput.contentDocumentId == null && curInput.contentDocumentIdList == null) {
                    throw new FlowCustomException('You need to provide either a single ContentDocument Id OR a list of ContentDocumentIds as inputs to this Flow action.');
                }
                else {
                    // Easiest to just combine the inputs for processing
                    if (curInput.contentDocumentId != null)
                        curInput.contentDocumentIdList.add(curInput.contentDocumentId);
                }
                for (String curContentDocumentId : curInput.contentDocumentIdList){
                    SObjectType sObjType = ((SObject)Type.forName(curInput.objectApiName).newInstance()).getSObjectType();         
                    map<String,SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
                    
                    Blob csvBlobContent = getCsvContent(curContentDocumentId);
                    String csvStringContent = blobToString(csvBlobContent, 'ISO-8859-1');
                    csvStringContent = csvStringContent.replaceAll('(\r\n|\r)','\n');
                               
                    String[] csvRows = csvStringContent.split('\n');
                    String[] fields = csvRows[0].split(','); //Gives all the API names of the fields from the 1st CSV row
                    csvRows.remove(0);
                    map<String,Schema.DisplayType> fieldToFieldTypeMap = new map<String,Schema.DisplayType>();
                    for (String field : fields) {
                        fieldToFieldTypeMap.put(field, getFieldType(fieldMap, field));
                    }
                   
                    Response output = new Response();
                    output.convertedCSVRows = new SObject[]{};
                    for(String row : csvRows) {
                        SObject obj = sObjType.newSObject();
                        String[] fieldInputValues = row.split(',');
                        
                        for (Integer i = 0; i < fields.size(); i++) {
                            String fieldValue = fieldInputValues[i];
                            Schema.DisplayType fieldType = fieldToFieldTypeMap.get(fields[i]);
                            obj.put( fields[i], getConvertedFieldValue(fieldType, fieldValue));
                        }
                        output.convertedCSVRows.add(obj);
                    }
                    responseList.add(output);
                }            
                

            }
            return responseList;
        }
    
        static Blob getCsvContent( String contentDocumentId) {        
            ContentVersion csvFile = [SELECT 
                                       VersionData 
                                       FROM ContentVersion 
                                       WHERE ContentDocumentId = :contentDocumentId 
                                             AND IsLatest = true
                                     ];
            System.debug('contentDocumentId is: ' + contentDocumentId);
            System.debug('csvFile is: ' + csvFile);
            return csvFile.VersionData;
        }
    
        /* Converting the CSV file input(BLOB format) to a string */
        static String blobToString(Blob input, String inCharset){
            String hex = EncodingUtil.convertToHex(input);
            System.assertEquals(0, hex.length() & 1);
            final Integer bytesCount = hex.length() >> 1;
            String[] bytes = new String[bytesCount];
            for(Integer i = 0; i < bytesCount; ++i)
                bytes[i] =  hex.mid(i << 1, 2);
            return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
        } 
    
        static Object getConvertedFieldValue(Schema.DisplayType fieldType, String fieldValue){
            Object convertedFieldValue;
            switch on fieldType {//Setting Field value based on the field data type
                when BOOLEAN {
                    convertedfieldValue = String.isEmpty(fieldValue) ? false : Boolean.valueOf(fieldValue);
                }
                when DOUBLE {
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fieldValue);
                }
                when CURRENCY {
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fieldValue);
                }
                when INTEGER {
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Integer.valueOf(fieldValue);
                }
                when else { 
                    convertedfieldValue = fieldValue;
                }
            }
            return convertedFieldValue;
        }
    
        @TestVisible
        static Schema.DisplayType getFieldType(map<String, SObjectField> fieldMap, String fieldApiName) {
            if(fieldMap.get(fieldApiName) == null) {
                throw new FlowCustomException('Invalid Field Error: '+fieldApiName + '. Please double check the API name of the field.');
            }
            return fieldMap.get(fieldApiName).getDescribe().getType();
        }
        
        public class FlowCustomException extends Exception{}
    
        public class Request{
            @InvocableVariable(label='Object API Name' required=true)
            public string objectApiName;
            
            @InvocableVariable(label='Single CSV File ID')
            public string contentDocumentId;

            @InvocableVariable(label='List of CSV File IDs')
            public List<String> contentDocumentIdList;
        }
    
        public class Response{
            @InvocableVariable(label='List(collection) of Records')
            public List<SObject> convertedCSVRows;
        }
    }