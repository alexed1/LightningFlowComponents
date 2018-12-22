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
            File file = drive.getFile(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (file == null) {
                throw new GoogleException('Google Sheet with the name "' + request.SpreadsheetName + '" doesn\'t exist');
            }
            SheetData spreadsheetData = new SheetData(drive.GetSpreadsheetData(file.id, request.SheetName));   
            CellValue value = null;         
            if (!String.isBlank(request.Right1) 
                || !String.isBlank(request.Below1)
                || !String.isBlank(request.Address1)) {
                value = spreadsheetData.locateValue(request.Address1, request.Right1, request.Below1);
                response.Value1 = value == null ? '' : value.value;
            }
            if (!String.isBlank(request.Right2) 
                || !String.isBlank(request.Below2)
                || !String.isBlank(request.Address2)) {
                value = spreadsheetData.locateValue(request.Address2, request.Right2, request.Below2);
                response.Value2 = value == null ? '' : value.value;
            }
            if (!String.isBlank(request.Right3) 
                || !String.isBlank(request.Below3)
                || !String.isBlank(request.Address3)) {
                value = spreadsheetData.locateValue(request.Address3, request.Right3, request.Below3);
                response.Value3 = value == null ? '' : value.value;
            }
            if (!String.isBlank(request.Right4) 
                || !String.isBlank(request.Below4)
                || !String.isBlank(request.Address4)) {
                value = spreadsheetData.locateValue(request.Address4, request.Right4, request.Below4);
                response.Value4 = value == null ? '' : value.value;
            }
            if (!String.isBlank(request.Right5) 
                || !String.isBlank(request.Below5)
                || !String.isBlank(request.Address5)) {
                value = spreadsheetData.locateValue(request.Address5, request.Right5, request.Below5);
                response.Value5 = value == null ? '' : value.value;
            }
        } 
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='A name of the file or a path to the file')
        global String SpreadsheetName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found spreadsheet will be used')
        global String SheetName;

        @InvocableVariable(label='#1 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right1;

        @InvocableVariable(label='#1 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below1;

        @InvocableVariable(label='#1 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address1;

        @InvocableVariable(label='#2 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right2;

        @InvocableVariable(label='#2 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below2;

        @InvocableVariable(label='#2 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address2;        

        @InvocableVariable(label='#3 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right3;

        @InvocableVariable(label='#3 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below3;

        @InvocableVariable(label='#3 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address3;

        @InvocableVariable(label='#4 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right4;

        @InvocableVariable(label='#4 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below4;

        @InvocableVariable(label='#4 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address4;

        @InvocableVariable(label='#5 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right5;

        @InvocableVariable(label='#5 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below5;

        @InvocableVariable(label='#5 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address5;
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