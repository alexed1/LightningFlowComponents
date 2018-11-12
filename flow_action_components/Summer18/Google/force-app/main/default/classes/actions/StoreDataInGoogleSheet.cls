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
            String spreadsheetId = googleDrive.FindFileIdByName(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (String.isBlank(spreadsheetId)) {
                throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
            }
            List<String> directions = new List<String> { 
                request.Direction1,
                request.Direction2,
                request.Direction3,
                request.Direction4,
                request.Direction5
            };
            List<String> locations = new List<String> { 
                request.Location1,
                request.Location2,
                request.Location3,
                request.Location4,
                request.Location5
            };
            List<String> values = new List<String> { 
                request.Value1,
                request.Value2,
                request.Value3,
                request.Value4,
                request.Value5
            };
            for (Integer i = 0; i < directions.size(); i++) {
                String direction = directions[i];
                if (String.isBlank(direction)) {
                    continue;
                }
                String location = locations[i];
                if (String.isEmpty(locations[i])) {
                    continue;
                }
            }

            //TODO:
        }
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }

    global class GoogleSheetsRequest {

        @InvocableVariable(required=True label='Sheets File Name' description='Case-sensitive, no extension, name only')
        global String SpreadsheetName;

        @InvocableVariable(required=True label='#1 Direction' description='Allowed values: Address, Right, Below')
        global String Direction1;

        @InvocableVariable(required=True label='#1 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location1;

        @InvocableVariable(required=True label='#1 Value' description='Value to write to the sheet')
        global String Value1;

        @InvocableVariable(label='#2 Direction' description='Allowed values: Address, Right, Below')
        global String Direction2;

        @InvocableVariable(label='#2 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location2;

        @InvocableVariable(required=True label='#2 Value' description='Value to write to the sheet')
        global String Value2;

        @InvocableVariable(label='#3 Direction' description='Allowed values: Address, Right, Below')
        global String Direction3;

        @InvocableVariable(label='#3 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location3;        

        @InvocableVariable(required=True label='#3 Value' description='Value to write to the sheet')
        global String Value3;

        @InvocableVariable(label='#4 Direction' description='Allowed values: Address, Right, Below')
        global String Direction4;

        @InvocableVariable(label='#4 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location4;

        @InvocableVariable(required=True label='#4 Value' description='Value to write to the sheet')
        global String Value4;

        @InvocableVariable(label='#5 Direction' description='Allowed values: Address, Right, Below')
        global String Direction5;

        @InvocableVariable(label='#5 Location' description='What value to search for. If related direction is set to "Address", the format should be Excel-like (e.g. "A1")')
        global String Location5;

        @InvocableVariable(required=True label='#5 Value' description='Value to write to the sheet')
        global String Value5;
    }
}
