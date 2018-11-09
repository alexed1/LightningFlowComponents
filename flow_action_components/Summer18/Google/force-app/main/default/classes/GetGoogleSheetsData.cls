global class GetGoogleSheetsData {
    
    @InvocableMethod(label='Get Google Sheets Data' description='Returns the values from Google Sheets cells that are located at specific address or relative to other specific values')
    global static List<GoogleSheetsResponse> GetGoogleSheetsData(List<GoogleSheetsRequest> requests) {
        return GetGoogleSheetsData.GetGoogleSheetsDataImpl(new GoogleDrive(new GoogleAPI()), requests);
    }

    public static List<GoogleSheetsResponse> GetGoogleSheetsDataImpl(GoogleDrive drive, List<GoogleSheetsRequest> requests) {
        List<GoogleSheetsResponse> responses = new List<GoogleSheetsResponse>();

        for (GoogleSheetsRequest request : requests) {
            String spreadsheetId = drive.FindFileIdByName(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (String.isBlank(spreadsheetId)) {
                throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
            }
            GoogleSheetsResponse response = new GoogleSheetsResponse();
            responses.add(response);
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
        return responses;
    }

    private static String LocateValue(List<List<String>> data, String direction, String search) {
        Address address = null;
        if (direction.equalsIgnoreCase('address')) {
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
        if (direction.equalsIgnoreCase('right')) {
            address.column +=1;
        } else if (direction.equalsIgnoreCase('below')) {
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
            return null;
        }
        matcher = Pattern.compile('\\d+$').matcher(address);
        Integer row = null;
        if (matcher.find()) {
            row = Integer.valueOf(matcher.group()) - 1;
        }
        else {
            return null;
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

        @InvocableVariable(required=True label='The name of Google Sheets file (case-sensitive)')
        global String SpreadsheetName;

        @InvocableVariable(required=True label='Where to look for the data. Valid values are "Address", "Right", "Below"')
        global String DataDirection1;

        @InvocableVariable(required=True label='What value to compare the data location with. For data location "Address" it should be Excel-like cell address e.g. "A1"')
        global String DataLocator1;

        @InvocableVariable(label='Where to look for the data. Valid values are "Address", "Right", "Below"')
        global String DataDirection2;

        @InvocableVariable(label='What value to compare the data location with. For data location "Address" it should be Excel-like cell address e.g. "A1"')
        global String DataLocator2;

        @InvocableVariable(label='Where to look for the data. Valid values are "Address", "Right", "Below"')
        global String DataDirection3;

        @InvocableVariable(label='What value to compare the data location with. For data location "Address" it should be Excel-like cell address e.g. "A1"')
        global String DataLocator3;

        @InvocableVariable(label='Where to look for the data. Valid values are "Address", "Right", "Below"')
        global String DataDirection4;

        @InvocableVariable(label='What value to compare the data location with. For data location "Address" it should be Excel-like cell address e.g. "A1"')
        global String DataLocator4;

        @InvocableVariable(label='Where to look for the data. Valid values are "Address", "Right", "Below"')
        global String DataDirection5;

        @InvocableVariable(label='What value to compare the data location with. For data location "Address" it should be Excel-like cell address e.g. "A1"')
        global String DataLocator5;
    }

    global class GoogleSheetsResponse {
        
        @InvocableVariable(label='Value returned from the DataDirection1/DataLocator1 inputs')
        global String Value1;
        
        @InvocableVariable(label='Value returned from the DataDirection2/DataLocator2 inputs')
        global String Value2;
        
        @InvocableVariable(label='Value returned from the DataDirection3/DataLocator3 inputs')
        global String Value3;
        
        @InvocableVariable(label='Value returned from the DataDirection4/DataLocator4 inputs')
        global String Value4;
        
        @InvocableVariable(label='Value returned from the DataDirection5/DataLocator5 inputs')
        global String Value5;
    }
}