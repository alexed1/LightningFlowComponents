global class StoreDataInQuipSheet {
    
    @InvocableMethod(label='Store Data in Quip Sheet' description='Saves values to Quip Sheet at specific cells or relatively to other specific values')
    global static List<Response> StoreDataInQuipSheet(List<Request> requests) {
        IQuip Quip = new Quip(new QuipAPI());
        List<Response> responses = new List<Response>();
        for (Request request: requests) {
            Response response = StoreDataInQuipSheet.StoreDataInQuipSheetImpl(Quip, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response StoreDataInQuipSheetImpl(IQuip quip, Request request) {
        Response response = new Response();
        try {
            Thread thread = quip.findThread(request.FileName);            
            if (thread == null) {
                response.IsSuccess = false;
                response.ErrorMessage = 'File with the name "' + request.FileName + '" was not found';
                return response;
            }
            ThreadSheet sheet = null;
            for (ThreadSheet threadSheet : thread.sheets) {
                if (String.isBlank(request.SheetName) || threadSheet.title == request.SheetName) {
                    sheet = threadSheet;
                    break;
                }
            }
            if (sheet == null) {
                response.IsSuccess = false;
                if (String.isBlank(request.SheetName)) {
                    response.ErrorMessage = 'File "' + request.FileName + '" doesn\'t contain child sheets';
                } else {
                    response.ErrorMessage = 'File "' + request.Filename + '" doesn\'t contain sheet "' + request.SheetName + '"';
                }
                return response;
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
            List<ThreadCell> cellsToUpdate = new List<ThreadCell>();
            for (Integer i = 0; i < addresses.size(); i++) {
                String addr = addresses[i];
                String below = belows[i];
                String right = rights[i];
                if (String.isBlank(addr) && String.isBlank(below) && String.isBlank(right)) {
                    continue;
                }
                ThreadCell cell = sheet.findCell(addr, right, below);
                cell.value = values[i];
                cellsToUpdate.add(cell);
            }
            quip.saveSpreadsheetData(thread, sheet, cellsToUpdate);
        }
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }  

    global class Request {

        @InvocableVariable(required=True label='File Name' description='Case-sensitive')
        global String FileName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found file will be used')
        global String SheetName;

        @InvocableVariable(label='#1 Cell To The Right of Which Label' description='Sets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right1;

        @InvocableVariable(label='#1 Cell Below Which Label' description='Sets the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then sets the value that is located at the intersection of these two')
        global String Below1;

        @InvocableVariable(label='#1 At Cell' description='Sets the value located at the specified Excel-like address (e.g. B2)')
        global String Address1;

        @InvocableVariable(required=True label='#1 Value' description='Value to write to the sheet')
        global String Value1;

        @InvocableVariable(label='#2 Cell To The Right of Which Label' description='Sets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right2;

        @InvocableVariable(label='#2 Cell Below Which Label' description='Sets the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below2;

        @InvocableVariable(label='#2 At Cell' description='Sets the value located at the specified Excel-like address (e.g. B2)')
        global String Address2;   

        @InvocableVariable(label='#2 Value' description='Value to write to the sheet')
        global String Value2;        

        @InvocableVariable(label='#3 Cell To The Right of Which Label' description='Sets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right3;

        @InvocableVariable(label='#3 Cell Below Which Label' description='Sets the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below3; 

        @InvocableVariable(label='#3 Value' description='Value to write to the sheet')
        global String Value3;

        @InvocableVariable(label='#3 At Cell' description='Sets the value located at the specified Excel-like address (e.g. B2)')
        global String Address3;

        @InvocableVariable(label='#4 Cell To The Right of Which Label' description='Sets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right4;

        @InvocableVariable(label='#4 Cell Below Which Label' description='Sets the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below4;

        @InvocableVariable(label='#4 At Cell' description='Sets the value located at the specified Excel-like address (e.g. B2)')
        global String Address4;

        @InvocableVariable(label='#4 Value' description='Value to write to the sheet')
        global String Value4;

        @InvocableVariable(label='#5 Cell To The Right of Which Label' description='Sets the value located directly Cell To The Right of Which Label the specified one. If used together with "Cell Below Which Label" then gets the value that is located at the intersection of these two')
        global String Right5;

        @InvocableVariable(label='#5 Cell Below Which Label' description='Sets the value located directly under the specified one. If used together with "Cell To The Right of Which Label" then gets the value that is located at the intersection of these two')
        global String Below5;

        @InvocableVariable(label='#5 At Cell' description='Sets the value located at the specified Excel-like address (e.g. B2)')
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