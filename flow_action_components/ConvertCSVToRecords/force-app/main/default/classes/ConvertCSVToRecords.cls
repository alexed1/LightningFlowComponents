public with sharing class ConvertCSVToRecords {
    @InvocableMethod(label='Convert CSV File to Records from single or multiple ContentDocumentIds')
    public static Response[] convert(Request[] inputs) {
        Response[] responseList = new List<Response>{};

        for (Request curInput : inputs) {
            if (curInput.contentDocumentId == null && curInput.contentDocumentIdList == null) {
                throw new FlowCustomException('You need to provide either a single ContentDocument Id OR a list of ContentDocumentIds as inputs to this Flow action.');
            } else {
                // Easiest to just combine the inputs for processing
                if (curInput.contentDocumentId != null) {
                    if(curInput.contentDocumentIdList == null) {
                        curInput.contentDocumentIdList = new List<String>();
                    }
                    curInput.contentDocumentIdList.add(curInput.contentDocumentId);
                }
            }
            for (String curContentDocumentId : curInput.contentDocumentIdList) {
                SObjectType sObjType = ((SObject) Type.forName(curInput.objectApiName).newInstance()).getSObjectType();
                Map<String, SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();

                Blob csvBlobContent = getCsvContent(curContentDocumentId);
                String csvStringContent = blobToString(csvBlobContent, 'ISO-8859-1');
                String fSepRepl = '~`~', newlineRepl = '-`-';
                csvStringContent = csvStringContent.replaceAll('(\r\n|\r)', '\n');
                csvStringContent = removeFSeps(csvStringContent, 0,curInput.FSep,fSepRepl, newlineRepl);
                String[] csvRows = csvStringContent.split('\n');
                String[] fields = csvRows[0].split(curInput.FSep); //Gives all the API names of the fields from the 1st CSV row 
                csvRows.remove(0);
                Map<String, Schema.DisplayType> fieldToFieldTypeMap = new Map<String, Schema.DisplayType>();
                Map<String, String> fieldName = new Map<String, String>();
                for (String field : fields) {
                    String fieldApiName = field.trim(); //Since fieldnames will never contain spaces, we will always trim
                    if (fieldMap.get(fieldApiName) == null) {
                        fieldApiName = fieldApiName.replaceAll('/', '_');
                        fieldApiName = fieldApiName.replaceAll(' ', '_').replaceAll('[^a-zA-Z0-9_]', ''); // Convert to alphanumeric and underscore
                        fieldApiName = fieldApiName.replaceAll('__', '_') + '__c'; // Remove extra _s and add __c to end
                    }
                    fieldToFieldTypeMap.put(field, getFieldType(fieldMap, fieldApiName));
                    fieldName.put(field, fieldApiName);
                }

                Response output = new Response();
                output.convertedCSVRows = new List<SObject>{};
                for (String row : csvRows) {
                    row = replaceNewline(row, newlineRepl);
                    SObject obj = sObjType.newSObject();
                    //row = row.replace(curInput.Fsep + '"',curInput.Fsep).replace('"' + curInput.Fsep,curInput.Fsep);
                    String[] fieldInputValues = row.split(curInput.FSep,-1);
                    for (Integer i = 0; i < fields.size(); i++) {
                        String fieldValue = fieldInputValues[i].replace(curInput.Fsep + '"',curInput.Fsep).replace('"' + curInput.Fsep,curInput.Fsep);
                        fieldValue = replaceFSep(fieldValue, curInput.Fsep, fSepRepl);
                        fieldValue = removeQuotes(fieldValue); // Remove " characters if they bracket the field value
                        String Tsep = curInput.Tsep;
                        String Dsep = curInput.Dsep;
                        String vCur = curInput.vCur;
                        if (curInput.isTrim) {
                            fieldValue = fieldValue.trim();
                        }
                        Schema.DisplayType fieldType = fieldToFieldTypeMap.get(fields[i]);
                        try {
                            obj.put( fieldName.get(fields[i]), getConvertedFieldValue(fieldType, fieldValue, Tsep, Dsep, vCur) );
                        } catch(exception e) {
                            obj.put( fieldName.get(fields[i]), null );
                        }
                    }
                    output.convertedCSVRows.add(obj);
                }
                responseList.add(output);
            }
        }
        return responseList;
    }

    static Blob getCsvContent(String contentDocumentId) {
        ContentVersion csvFile = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId AND IsLatest = TRUE];
        System.debug('contentDocumentId is: ' + contentDocumentId);
        System.debug('csvFile is: ' + csvFile);
        return csvFile.VersionData;
    }

    /* Converting the CSV file input(BLOB format) to a string */
    static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new List<String>(bytesCount);
        for (Integer i = 0; i < bytesCount; ++i)
            bytes[i] = hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    @TestVisible
    static Object getConvertedFieldValue(Schema.DisplayType fieldType, String fieldValue, String Tsep, String Dsep, String vCur){
        Object convertedFieldValue;

        switch on
            fieldType { //Setting Field value based on the field data type
            when BOOLEAN {
                convertedfieldValue = String.isEmpty(fieldValue) ? false : Boolean.valueOf(fieldValue);
            }
            when DOUBLE {
                String fValue = fieldValue.replaceAll('^0-9,.','');
                if( fValue.indexOf(Tsep) < 0 && fValue.indexOf(Dsep) < 0 ) {/* both WITHOUT Thousands separator and WITHOUT decimal separator */
                    /* No conversion needed */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue);
                    }
                if( fValue.indexOf(Tsep) < 0 && fValue.indexOf(Dsep) > -1) {/*example: change value WITHOUT thousands separator and WITH decimals like 1.234 (US) or 1,234 (EU) to 1.234 (US)*/
                    /* Convert comma as decimal separator to point */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',','.'));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) < 0) {/*example: change value WITH thousands separator and WITHOUT decimals like 1,234 (US) or 1.234 (EU) to 1234 */
                    /* Remove comma and point as Thousands separator (no decimals present) */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',','').replace('.',''));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) > -1 && Tsep == ',') {/*example: change value WITH thousand separator and WITH decimals like 1,234.56 to 1234.56 (US) */
                    /* Remove comma Thousands separator, leave decimal separator unchanged) */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',',''));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) > -1 && Tsep == '.') {/*example: change value WITH thousand separator and WITH decimals like 1.234,56 to 1234,56 (EU)*/
                    /* Remove point as Thousands separator, change comma to point as decimal separator */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue = fValue.replace('.','').replace(',','.'));
                    }
            }
            when CURRENCY {
                String fValue = fieldValue.replaceAll('^0-9,.','').replace(vCur,'').replace(' ','');
                if( fValue.indexOf(Tsep) < 0 && fValue.indexOf(Dsep) < 0 ) {/* both WITHOUT Thousands separator and WITHOUT decimal separator */
                    /* No conversion needed */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue);
                    }
                if( fValue.indexOf(Tsep) < 0 && fValue.indexOf(Dsep) > -1) {/*example: change value WITHOUT thousands separator and WITH decimals like 1.234 (US) or 1,234 (EU) to 1.234 (US)*/
                    /* Convert comma as decimal separator to point */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',','.'));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) < 0) {/*example: change value WITH thousands separator and WITHOUT decimals like 1,234 (US) or 1.234 (EU) to 1234 */
                    /* Remove comma and point as Thousands separator (no decimals present) */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',','').replace('.',''));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) > -1 && Tsep == ',') {/*example: change value WITH thousand separator and WITH decimals like 1,234.56 to 1234.56 (US) */
                    /* Remove comma Thousands separator, leave decimal separator unchanged) */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue.replace(',',''));
                    }
                if( fValue.indexOf(Tsep) > -1 && fValue.indexOf(Dsep) > -1 && Tsep == '.') {/*example: change value WITH thousand separator and WITH decimals like 1.234,56 to 1234,56 (EU)*/
                    /* Remove point as Thousands separator, change comma to point as decimal separator */
                    convertedfieldValue = String.isEmpty(fieldValue) ? null : Decimal.valueOf(fValue = fValue.replace('.','').replace(',','.'));
                    }
            }
            when INTEGER {
                /*Remove thousands separator ( , and . like in 1,234 and 1.234 ) */
                convertedfieldValue = String.isEmpty(fieldValue) ? null : Integer.valueOf(fieldValue.replaceAll('^0-9',''));
            }
            when DATE {
                /* replace / and : and . in fieldvalue by -  like in 2021.12.31 or 2021/12/31 or 2021:12:31 or 1.1.2021 or 31/12/2021 or 31:12:2021 */
                String fValue = fieldValue.replaceAll('^0-9','-');
                list<String> lstSplit = fValue.split('-');
                If (fValue.indexOf('-') > 2){
                   /* Format found like YYYY-MM-DD */
                   Integer Year = Integer.valueOf(lstSplit[0]);           
                   Integer Month = Integer.valueOf(lstSplit[1]);           
                   Integer Day = Integer.valueOf(lstSplit[2]);
                   convertedfieldValue = String.isEmpty(fieldValue) ? null : date.valueOf(Year + '-' + ('0' + Month).Right(2) + '-' + ('0' + Day).Right(2));
                   }
                else {
                   /* Format found like DD-MM-YYYY, convert to YYYY-MM-DD */
                   Integer Day = Integer.valueOf(lstSplit[0]);           
                   Integer Month = Integer.valueOf(lstSplit[1]);           
                   Integer Year = Integer.valueOf(lstSplit[2]);
                   convertedfieldValue = String.isEmpty(fieldValue) ? null : date.valueOf(Year + '-' + ('0' + Month).Right(2) + '-' + ('0' + Day).Right(2));
                   }                      
            }
            when else {
                convertedfieldValue = fieldValue;
            }
        }

        return convertedFieldValue;
    }

    static String removeFSeps(String text, Integer eloc, String fSep, String fSepRepl, String newlineRepl) {
        Integer sloc = -1;
        if (eloc == 0 && text.substring(eloc, 1) == '"') {
            sloc = 0;
        } else {
            sloc = getNextQuoteIndex(text, eloc, false);
        }
        if (sloc == -1) {
            return text;
        }
        eloc = getNextQuoteIndex(text, sloc, true);
        if (eloc == -1) {
            if (text.substring(text.length() - 1) == '"') {
                eloc = text.length() - 1;
            } else {
                return text;
            }
        }
        String subText = text.substring(sloc + 1, eloc).replace(fSep, fSepRepl).replace('\n', newlineRepl);
        String replText = text.substring(0, sloc + 1) + subText + text.substring(eloc);
        return removeFSeps(replText, eloc,fSep, fSepRepl, newlineRepl);
    }

    static Integer getNextQuoteIndex(String text, Integer startingFrom, Boolean isClosing) {
        Integer midRowQuote = text.indexOf(isClosing ? '",' : ',"', startingFrom);
        Integer startEndRowQuote = text.indexOf(isClosing ? '"\n' : '\n"', startingFrom);
        if (midRowQuote > -1) {
            if (startEndRowQuote == -1) {
                return midRowQuote;
            } else {
                return Math.min(startEndRowQuote, midRowQuote);
            }
        } else if (startEndRowQuote > -1) {
            return startEndRowQuote;
        }
        return -1;
    }

    static String replaceFSep(String text, String fSep, String fSepRepl) {
        return text.replace(fSepRepl,fSep);
    }

    static String replaceNewline(String text, String newlineRepl) {
        return text.replace(newlineRepl, '\n');
    }

    static String removeQuotes(String text) {
        return text.removeStart('\"').removeEnd('\"').replace('""', '"'); //according to spec "" stands for a single " within a column.
    }

    @TestVisible
    static Schema.DisplayType getFieldType(Map<String, SObjectField> fieldMap, String fieldApiName) {
        if (fieldMap.get(fieldApiName) == null) {
            throw new FlowCustomException('Invalid Field Error: ' + fieldApiName + '. Please double check the API name of the field.');
        }
        return fieldMap.get(fieldApiName).getDescribe().getType();
    }

    public class FlowCustomException extends Exception {
    }

    public class Request {
        public Request() {
        }

        @InvocableVariable(label='Object API Name' required=true)
        public string objectApiName;

        @InvocableVariable(label='Separator 1: Fields' description='Choose comma (input: , ) or semicolon (input: ; )' required=true)
        public string FSep;

        @InvocableVariable(label='Separator 2: Decimals' description='Choose comma (input: , ) or semicolon (input: ; )' required=true)
        public string DSep;

        @InvocableVariable(label='Separator 3: Thousands' description='Choose comma (input: , ) or semicolon (input: ; )' required=true)
        public string TSep;
        
        @InvocableVariable(label='Symbol of Currency' description='Like $, €, £' required=true)
        public string vCur;
        
        @InvocableVariable(label='CSV (single) File ID')
        public string contentDocumentId;

        @InvocableVariable(label='CSV List of File IDs')
        public List<String> contentDocumentIdList;

        @InvocableVariable(label='Trim leading and trailing spaces')
        public Boolean isTrim = false;
    }

    public class Response {
        @InvocableVariable(label='List(collection) of Records')
        public List<SObject> convertedCSVRows;
    }
}
