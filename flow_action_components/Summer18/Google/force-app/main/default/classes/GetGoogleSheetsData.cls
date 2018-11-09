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
                if (!String.isBlank(request.DataDirection1)) {
                    response.Value1 = LocateValue(spreadsheetData, request.DataDirection1, request.DataLocator1);
                }
                if (!String.isBlank(request.DataDirection2)) {
                    response.Value2 = LocateValue(spreadsheetData, request.DataDirection2, request.DataLocator2);
                }
                if (!String.isBlank(request.DataDirection3)) {
                    response.Value3 = LocateValue(spreadsheetData, request.DataDirection3, request.DataLocator3);
                }
                if (!String.isBlank(request.DataDirection4)) {
                    response.Value4 = LocateValue(spreadsheetData, request.DataDirection4, request.DataLocator4);
                }
                if (!String.isBlank(request.DataDirection5)) {
                    response.Value5 = LocateValue(spreadsheetData, request.DataDirection5, request.DataLocator5);
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
        if (address == null) {
            return null;
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
        return null;
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

        @InvocableVariable(required=True label='Google Sheets File name (case-sensitive)')
        global String SpreadsheetName;

        @InvocableVariable(required=True label='Data Direction #1' description='Allowed values: Address, Right, Below')
        global String DataDirection1;

        @InvocableVariable(required=True label='Data Locator #1' description='What value to search for')
        global String DataLocator1;

        @InvocableVariable(label='Data Direction #2' description='Allowed values: Address, Right, Below')
        global String DataDirection2;

        @InvocableVariable(label='Data Locator #2' description='What value to search for')
        global String DataLocator2;

        @InvocableVariable(label='Data Direction #3' description='Allowed values: Address, Right, Below')
        global String DataDirection3;

        @InvocableVariable(label='Data Locator #3' description='What value to search for')
        global String DataLocator3;

        @InvocableVariable(label='Data Direction #4' description='Allowed values: Address, Right, Below')
        global String DataDirection4;

        @InvocableVariable(label='Data Locator #4' description='What value to search for')
        global String DataLocator4;

        @InvocableVariable(label='Data Direction #5' description='Allowed values: Address, Right, Below')
        global String DataDirection5;

        @InvocableVariable(label='Data Locator #5' description='What value to search for')
        global String DataLocator5;
    }

    global class GoogleSheetsResponse {
        
        @InvocableVariable(label='Value #1' required=True)
        global String Value1;
        
        @InvocableVariable(label='Value #2')
        global String Value2;
        
        @InvocableVariable(label='Value #3')
        global String Value3;
        
        @InvocableVariable(label='Value #4')
        global String Value4;
        
        @InvocableVariable(label='Value #5')
        global String Value5;

        @InvocableVariable(label='Is Success')
        global Boolean IsSuccess;

        @InvocableVariable(label='Error Message')
        global String ErrorMessage;
    }
}