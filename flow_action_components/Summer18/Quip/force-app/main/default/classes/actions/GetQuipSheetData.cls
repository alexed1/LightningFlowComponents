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
            if (!String.isBlank(request.RelativeDirection1)) {
                response.Value1 = LocateValue(sheet, request.RelativeDirection1, request.TargetLabel1);
            }
            if (!String.isBlank(request.RelativeDirection2)) {
                response.Value2 = LocateValue(sheet, request.RelativeDirection2, request.TargetLabel2);
            }
            if (!String.isBlank(request.RelativeDirection3)) {
                response.Value3 = LocateValue(sheet, request.RelativeDirection3, request.TargetLabel3);
            }
            if (!String.isBlank(request.RelativeDirection4)) {
                response.Value4 = LocateValue(sheet, request.RelativeDirection4, request.TargetLabel4);
            }
            if (!String.isBlank(request.RelativeDirection5)) {
                response.Value5 = LocateValue(sheet, request.RelativeDirection5, request.TargetLabel5);
            }
        } 
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response;
    }

    private static String LocateValue(ThreadSheet data, String direct, String search) {
        Direction dir = DirectionUtils.parse(direct);
        Address addr = null;
        if (dir == Direction.ADDRESS) {
            addr = Address.parse(search);
        }
        else {
            addr = data.findAddressByValue(search);
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
        ThreadCell cell = data.findCellByAddress(addr);
        return cell.value;
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='Case-sensitive')
        global String FileName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found file will be used')
        global String SheetName;

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