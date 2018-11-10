global class GetGoogleSheetsData {
    
    @InvocableMethod(label='Get Google Sheets Data' description='Returns the values from Google Sheets cells that are located at specific address or relative to other specific values')
    global static List<GoogleSheetsResponse> GetGoogleSheetsData(List<GoogleSheetsRequest> requests) {
        return GetGoogleSheetsData.GetGoogleSheetsDataImpl(new GoogleDrive(new GoogleAPI()), requests);
    }

    public static List<GoogleSheetsResponse> GetGoogleSheetsDataImpl(IGoogleDrive drive, List<GoogleSheetsRequest> requests) {
        List<GoogleSheetsResponse> responses = new List<GoogleSheetsResponse>();

        for (GoogleSheetsRequest request : requests) {
            GoogleSheetsResponse response = new GoogleSheetsResponse();
            response.IsSuccess = true;
            responses.add(response);
            try {
                String spreadsheetId = drive.FindFileIdByName(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
                if (String.isBlank(spreadsheetId)) {
                    throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
                }
                List<List<String>> spreadsheetData = drive.GetSpreadsheetData(spreadsheetId);
                if (!String.isBlank(request.Direction1)) {
                    response.Value1 = LocateValue(spreadsheetData, request.Direction1, request.Location1);
                }
                if (!String.isBlank(request.Direction2)) {
                    response.Value2 = LocateValue(spreadsheetData, request.Direction2, request.Location2);
                }
                if (!String.isBlank(request.Direction3)) {
                    response.Value3 = LocateValue(spreadsheetData, request.Direction3, request.Location3);
                }
                if (!String.isBlank(request.Direction4)) {
                    response.Value4 = LocateValue(spreadsheetData, request.Direction4, request.Location4);
                }
                if (!String.isBlank(request.Direction5)) {
                    response.Value5 = LocateValue(spreadsheetData, request.Direction5, request.Location5);
                }
            } 
            catch (GoogleException ex) {
                response.IsSuccess = false;
                response.ErrorMessage = ex.getMessage();
            }
        }
        return responses;
    }

    private static String LocateValue(List<List<String>> data, String direction, String search) {
        Boolean isAddress = direction.equalsIgnoreCase('address');
        Boolean isRight = direction.equalsIgnoreCase('right');
        Boolean isBelow = direction.equalsIgnoreCase('below');
        if (!isAddress && !isRight && !isBelow) {
            throw new GoogleException('"' + direction + '" is not valid. Must be "Address", "Right" or "Below"');
        }
        Address address = null;
        if (isAddress) {
            address = ParseAddress(search);
        }
        else {
            for (Integer rowIndex = 0; rowIndex < data.size(); rowIndex++) {
                List<String> row = data[rowIndex];
                for (Integer colIndex = 0; colIndex < row.size(); colIndex++) {
                    if (row[colIndex].equalsIgnoreCase(search)) {
                        address = new Address();
                        address.row = rowIndex;
                        address.column = colIndex;
                    }
                }
            }
        }        
        //This is for the case where we just couldn't find a value
        if (address == null) {
            return '';
        }
        if (isRight) {
            address.column +=1;
        } else if (isBelow) {
            address.row += 1;
        }
        if (address.row >= 0 && address.row < data.size()) {
            List<String> row = data[address.row];            
            if (address.column >= 0 && address.column < row.size()) {
                return row[address.column];
            }
        }
        //This is the case where there requested address is located outside of the data area
        return '';
    }

    private static Address ParseAddress(String address) {
        Matcher matcher = Pattern.compile('^[A-Za-z]+').matcher(address);
        String column = null;
        if (matcher.find()) {
            column = matcher.group().toLowerCase();
        }
        else {
            throw new GoogleException('Address "' + address + '" doesn\'t contain column part');
        }
        matcher = Pattern.compile('\\d+$').matcher(address);
        Integer row = null;
        if (matcher.find()) {
            row = Integer.valueOf(matcher.group()) - 1;
        }
        else {
            throw new GoogleException('Address "' + address + '" doesn\'t contain row part');
        }
        Integer parsedColumn = 0;
        for (Integer i = 0; i < column.length(); i++) {
            parsedColumn = 26 * parsedColumn + column.charAt(i) - 'a'.charAt(0) + 1;        
        }
        parsedColumn--;
        Address result = new Address();
        result.row = row;
        result.column = parsedColumn;
        return result;
    }

    class Address {
        public Integer row;

        public Integer column;
    }

    global class GoogleSheetsRequest {

        @InvocableVariable(required=True label='Sheets File Name' description='Case-sensitive, no extension, name only')
        global String SpreadsheetName;

        @InvocableVariable(required=True label='#1 Direction' description='Allowed values: Address, Right, Below')
        global String Direction1;

        @InvocableVariable(required=True label='#1 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location1;

        @InvocableVariable(label='#2 Direction' description='Allowed values: Address, Right, Below')
        global String Direction2;

        @InvocableVariable(label='#2 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location2;

        @InvocableVariable(label='#3 Direction' description='Allowed values: Address, Right, Below')
        global String Direction3;

        @InvocableVariable(label='#3 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location3;

        @InvocableVariable(label='#4 Direction' description='Allowed values: Address, Right, Below')
        global String Direction4;

        @InvocableVariable(label='#4 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location4;

        @InvocableVariable(label='#5 Direction' description='Allowed values: Address, Right, Below')
        global String Direction5;

        @InvocableVariable(label='#5 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location5;
    }

    global class GoogleSheetsResponse {
        
        @InvocableVariable(label='Value #1')
        global String Value1;
        
        @InvocableVariable(label='Value #2')
        global String Value2;
        
        @InvocableVariable(label='Value #3')
        global String Value3;
        
        @InvocableVariable(label='Value #4')
        global String Value4;
        
        @InvocableVariable(label='Value #5')
        global String Value5;

        @InvocableVariable(label='Is Success' description='"True" if retrieval was successful, otherwise "False"')
        global Boolean IsSuccess;

        @InvocableVariable(label='Error Message' description='Contains the description of error if "IsSuccess" field is "False"')
        global String ErrorMessage;
    }
}