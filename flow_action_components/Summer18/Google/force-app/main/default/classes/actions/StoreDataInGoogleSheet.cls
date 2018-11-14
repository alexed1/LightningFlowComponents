global class StoreDataInGoogleSheet {
    
    @InvocableMethod(label='Store Data in Google Sheet' description='Saves values to Google Sheet at specific cells or relatively to other specific values')
    global static List<ActionResponse> StoreDataInGoogleSheet(List<GoogleSheetsRequest> requests) {
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        List<ActionResponse> responses = new List<ActionResponse>();
        for (GoogleSheetsRequest request: requests) {
            ActionResponse response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(googleDrive, request);
            responses.add(response);
        }
        return responses;
    }

    public static ActionResponse StoreDataInGoogleSheetImpl(IGoogleDrive googleDrive, GoogleSheetsRequest request) {
        ActionResponse response = new ActionResponse();
        try {
            String spreadsheetId = googleDrive.FindFileIdByName(request.aSpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (String.isBlank(spreadsheetId)) {
                throw new GoogleException('Spreadsheet with the name "' + request.aSpreadsheetName + '" was not found');
            }
            List<String> directions = new List<String> { 
                request.RelativeDirection1,
                request.RelativeDirection2,
                request.RelativeDirection3,
                request.RelativeDirection4,
                request.RelativeDirection5
            };
            List<String> locations = new List<String> { 
                request.TargetLabel1,
                request.TargetLabel2,
                request.TargetLabel3,
                request.TargetLabel4,
                request.TargetLabel5
            };
            List<String> values = new List<String> { 
                request.Value1,
                request.Value2,
                request.Value3,
                request.Value4,
                request.Value5
            };
            List<CellValue> valuesToWrite = new List<CellValue>();
            SheetData data = null;
            for (Integer i = 0; i < directions.size(); i++) {
                String dirStr = directions[i];
                if (String.isBlank(dirStr)) {
                    continue;
                }
                String location = locations[i];
                if (String.isEmpty(locations[i])) {
                    continue;
                }
                Direction dir = DirectionUtils.parse(dirStr);
                if (dir == Direction.ADDRESS) {
                    valuesToWrite.add(new CellValue(Address.parse(location), values[i]));
                } else {
                    if (data == null) {
                        data = new SheetData(googleDrive.GetSpreadsheetData(spreadsheetId));
                    }
                    Address addr = data.findAddressByValue(location);
                    if (addr == null) {
                        continue;
                    }
                    if (dir == Direction.RIGHT) {
                        addr = addr.shiftRight();
                    } else if (dir == Direction.BELOW) {
                        addr = addr.shiftBelow();
                    }
                    valuesToWrite.add(new CellValue(addr, values[i]));
                }
            }
            googleDrive.SaveSpreadsheetData(spreadsheetId, valuesToWrite);
        }
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }

    global class GoogleSheetsRequest {

        @InvocableVariable(required=True label='Spreadsheet Name' description='Case-sensitive, no extension, name only')
        global String aSpreadsheetName;

        @InvocableVariable(required=True label='#1 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection1;

        @InvocableVariable(required=True label='#1 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel1;

        @InvocableVariable(required=True label='#1 Value' description='Value to write to the sheet')
        global String Value1;

        @InvocableVariable(label='#2 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection2;

        @InvocableVariable(label='#2 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel2;

        @InvocableVariable(label='#2 Value' description='Value to write to the sheet')
        global String Value2;

        @InvocableVariable(label='#3 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection3;

        @InvocableVariable(label='#3 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel3;        

        @InvocableVariable(label='#3 Value' description='Value to write to the sheet')
        global String Value3;

        @InvocableVariable(label='#4 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection4;

        @InvocableVariable(label='#4 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel4;

        @InvocableVariable(label='#4 Value' description='Value to write to the sheet')
        global String Value4;

        @InvocableVariable(label='#5 Relative Direction' description='Allowed values: Address, Right, Below')
        global String RelativeDirection5;

        @InvocableVariable(label='#5 Target Label' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String TargetLabel5;

        @InvocableVariable(label='#5 Value' description='Value to write to the sheet')
        global String Value5;
    }
}
