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
            List<ThreadCell> cellsToUpdate = new List<ThreadCell>();
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
                Address addr = null;
                if (dir == Direction.ADDRESS) {
                    Taddr = Address.parse(location);
                } else {
                    addr = sheet.findAddressByValue(location);
                    if (addr == null) {
                        continue;
                    }
                    if (dir == Direction.RIGHT) {
                        addr = addr.shiftRight();
                    } else if (dir == Direction.BELOW) {
                        addr = addr.shiftBelow();
                    }
                }
                ThreadCell cell = sheet.findCellByAddress(addr);
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

    class RequestToWrite {
        public Direction direction;
        
        public String targetLabel;

        public String value;
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