global class GetQuipSheetData {
    
    @InvocableMethod(label='Get Quip Sheet Data' description='Returns the values from Quip sheet cells that are located at specific address or relative to other specific values')
    global static List<Response> GetQuipSheetData(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IQuip quip = new Quip(new QuipAPI());
        for (Request request : requests) {
            Response response = GetQuipSheetData.GetQuipSheetDataImpl(quip, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response GetQuipSheetDataImpl(IQuip quip, Request request) {
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
            if (!String.isBlank(request.Right1) 
                || !String.isBlank(request.Below1)
                || !String.isBlank(request.Address1)) {
                response.Value1 = LocateValue(sheet, request.Address1, request.Right1, request.Below1);
            }
            if (!String.isBlank(request.Right2) 
                || !String.isBlank(request.Below2)
                || !String.isBlank(request.Address2)) {
                response.Value2 = LocateValue(sheet, request.Address2, request.Right2, request.Below2);
            }
            if (!String.isBlank(request.Right3) 
                || !String.isBlank(request.Below3)
                || !String.isBlank(request.Address3)) {
                response.Value3 = LocateValue(sheet, request.Address3, request.Right3, request.Below3);
            }
            if (!String.isBlank(request.Right4) 
                || !String.isBlank(request.Below4)
                || !String.isBlank(request.Address4)) {
                response.Value4 = LocateValue(sheet, request.Address4, request.Right4, request.Below4);
            }
            if (!String.isBlank(request.Right5) 
                || !String.isBlank(request.Below5)
                || !String.isBlank(request.Address5)) {
                response.Value5 = LocateValue(sheet, request.Address5, request.Right5, request.Below5);
            }
        } 
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    private static String LocateValue(ThreadSheet data, String address, String rightOf, String belowOf) {
        ThreadCell cell = data.findCell(address, rightOf, belowOf);
        return cell == null ? '' : cell.value;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='Case-sensitive')
        global String FileName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found file will be used')
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