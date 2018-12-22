global class StoreDataInGoogleSheet {
    
    @InvocableMethod(label='Store Data in Google Sheet' description='Saves values to Google Sheet at specific cells or relatively to other specific values')
    global static List<Response> StoreDataInGoogleSheet(List<Request> requests) {
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        List<Response> responses = new List<Response>();
        for (Request request: requests) {
            Response response = StoreDataInGoogleSheet.StoreDataInGoogleSheetImpl(googleDrive, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response StoreDataInGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            File file = googleDrive.getFile(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (file == null) {
                throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
            }            
            List<String> addresses = new List<String> { 
                request.Address1,
                request.Address2,
                request.Address3,
                request.Address4,
                request.Address5
            };
            List<String> rights = new List<String> { 
                request.Right1,
                request.Right2,
                request.Right3,
                request.Right4,
                request.Right5
            };
            List<String> belows = new List<String> { 
                request.Below1,
                request.Below2,
                request.Below3,
                request.Below4,
                request.Below5
            };
            List<String> values = new List<String> { 
                request.Value1,
                request.Value2,
                request.Value3,
                request.Value4,
                request.Value5
            };
            SheetData data = null;
            List<CellValue> valuesToWrite = new List<CellValue>();
            for (Integer i = 0; i < addresses.size(); i++) {
                String addr = addresses[i];
                String below = belows[i];
                String right = rights[i];
                if (String.isBlank(addr) && String.isBlank(below) && String.isBlank(right)) {
                    continue;
                }
                if (data == null) {
                    data = new SheetData(googleDrive.getSpreadsheetData(file.id, request.SheetName));
                }
                CellValue cell = data.locateValue(addr, right, below);
                if (cell == null) {
                    continue;
                }
                cell.value = values[i];
                valuesToWrite.add(cell);
            }
            googleDrive.saveSpreadsheetData(file.id, request.SheetName, valuesToWrite);
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

        @InvocableVariable(label='#1 Value' description='Value to write to the sheet')
        global String Value1;

        @InvocableVariable(label='#2 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right2;

        @InvocableVariable(label='#2 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below2;

        @InvocableVariable(label='#2 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address2;   

        @InvocableVariable(label='#2 Value' description='Value to write to the sheet')
        global String Value2;     

        @InvocableVariable(label='#3 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right3;

        @InvocableVariable(label='#3 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below3;

        @InvocableVariable(label='#3 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address3;       

        @InvocableVariable(label='#3 Value' description='Value to write to the sheet')
        global String Value3;

        @InvocableVariable(label='#4 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right4;

        @InvocableVariable(label='#4 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below4;

        @InvocableVariable(label='#4 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address4;

        @InvocableVariable(label='#4 Value' description='Value to write to the sheet')
        global String Value4;

        @InvocableVariable(label='#5 Cell To The Right of Which Label' description='Gets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right5;

        @InvocableVariable(label='#5 Cell Below Which Label' description='Get the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below5;

        @InvocableVariable(label='#5 At Cell' description='Get the value located at the specified Excel-like address (e.g. B2)')
        global String Address5;

        @InvocableVariable(label='#5 Value' description='Value to write to the sheet')
        global String Value5;
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
    }
}
