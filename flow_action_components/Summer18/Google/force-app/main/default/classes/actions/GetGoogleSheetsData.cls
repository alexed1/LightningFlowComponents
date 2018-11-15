global class GetGoogleSheetsData {
    
    @InvocableMethod(label='Get Google Sheets Data' description='Returns the values from Google Sheets cells that are located at specific address or relative to other specific values')
    global static List<Response> GetGoogleSheetsData(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleDrive drive = new GoogleDrive(new GoogleAPI());
        for (Request request : requests) {
            Response response = GetGoogleSheetsData.GetGoogleSheetsDataImpl(drive, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response GetGoogleSheetsDataImpl(IGoogleDrive drive, Request request) {
        Response response = new Response();
        try {
            String spreadsheetId = drive.FindFileIdByName(request.aSpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (String.isBlank(spreadsheetId)) {
                throw new GoogleException('Spreadsheet with the name "' + request.aSpreadsheetName + '" was not found');
            }
            List<List<String>> spreadsheetData = drive.GetSpreadsheetData(spreadsheetId);
            if (!String.isBlank(request.RelativeDirection1)) {
                response.Value1 = LocateValue(spreadsheetData, request.RelativeDirection1, request.TargetLabel1);
            }
            if (!String.isBlank(request.RelativeDirection2)) {
                response.Value2 = LocateValue(spreadsheetData, request.RelativeDirection2, request.TargetLabel2);
            }
            if (!String.isBlank(request.RelativeDirection3)) {
                response.Value3 = LocateValue(spreadsheetData, request.RelativeDirection3, request.TargetLabel3);
            }
            if (!String.isBlank(request.RelativeDirection4)) {
                response.Value4 = LocateValue(spreadsheetData, request.RelativeDirection4, request.TargetLabel4);
            }
            if (!String.isBlank(request.RelativeDirection5)) {
                response.Value5 = LocateValue(spreadsheetData, request.RelativeDirection5, request.TargetLabel5);
            }
        } 
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    private static String LocateValue(List<List<String>> data, String direct, String search) {
        Direction dir = DirectionUtils.parse(direct);
        Address addr = null;
        SheetData sheetData = new SheetData(data);
        if (dir == Direction.ADDRESS) {
            addr = Address.parse(search);
        }
        else {
            addr = sheetData.findAddressByValue(search);
        }        
        //This is for the case where we just couldn't find a value
        if (addr == null) {
            return '';
        }
        if (dir == Direction.RIGHT) {
            addr = addr.shiftRight();
        }
        else if (dir == Direction.BELOW) {
            addr = addr.shiftBelow();
        }
        System.debug('Looking for the value at ' + addr);
        CellValue value = sheetData.getValueByAddress(addr);
        return value.value;
    }

    global class Request {

        @InvocableVariable(required=True label='Spreadsheet Name' description='Case-sensitive, no extension, name only')
        global String aSpreadsheetName;

        @InvocableVariable(required=True label='#1 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection1;

        @InvocableVariable(required=True label='#1 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel1;

        @InvocableVariable(label='#2 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection2;

        @InvocableVariable(label='#2 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel2;

        @InvocableVariable(label='#3 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection3;

        @InvocableVariable(label='#3 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel3;

        @InvocableVariable(label='#4 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection4;

        @InvocableVariable(label='#4 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel4;

        @InvocableVariable(label='#5 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection5;

        @InvocableVariable(label='#5 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel5;
    }

    global class Response {

        global Response() {
            IsSuccess = true;
            ErrorMessage = '';
        }

        @InvocableVariable(label='Is Success' description='"True" if action was successful, otherwise "False"')
        global Boolean IsSuccess;

        @InvocableVariable(label='Error Message' description='Contains the description of error if action was not successfull"')
        global String ErrorMessage;
        
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
    }
}