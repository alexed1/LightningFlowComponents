global class AddRowToQuipSheet {
    
    @InvocableMethod(label='Add Row to Quip Sheet' description='Adds a new row after the last non-empty one using the specified column labels and values')
    global static List<Response> AddRowToQuipSheet(List<Request> requests) {
        IQuip Quip = new Quip(new QuipAPI());
        List<Response> responses = new List<Response>();
        for (Request request: requests) {
            Response response = AddRowToQuipSheet.AddRowToQuipSheetImpl(Quip, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response AddRowToQuipSheetImpl(IQuip Quip, Request request) {
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
            List<String> columns = new List<String> { 
                request.TargetColumnName1,
                request.TargetColumnName2,
                request.TargetColumnName3,
                request.TargetColumnName4,
                request.TargetColumnName5,
                request.TargetColumnName6,
                request.TargetColumnName7,
                request.TargetColumnName8,
                request.TargetColumnName9,
                request.TargetColumnName10
            };
            List<String> values = new List<String> { 
                request.Value1,
                request.Value2,
                request.Value3,
                request.Value4,
                request.Value5,
                request.Value6,
                request.Value7,
                request.Value8,
                request.Value9,
                request.Value10
            };
            //First we need to find the columns to write values to
            List<ThreadCell> columnHeaders = new List<ThreadCell>();  
            for (Integer i = 0; i < columns.size(); i++) {
                String column = columns[i];
                if (String.isBlank(column)) {
                    columnHeaders.add(null);
                    continue;
                }
                ThreadCell cell = sheet.findCellByValue(column);
                if (cell == null) {
                    Integer columnIndex = sheet.headers.indexOf(column);
                    if (columnIndex == -1) {
                        columnHeaders.add(null);
                        continue;
                    }
                    cell = sheet.findCellByAddress(new Address(columnIndex, 0));
                }
                columnHeaders.add(cell);
            }
            //Now we need to find the first empty row that lies below all column headers
            Integer row = 0;
            for (ThreadCell columnHeader: columnHeaders) {
                if (columnHeader == null){
                    continue;
                }
                if (columnHeader.addr.row > row) {

                    row = columnHeader.addr.row;
                }
            }
            while (true) {
                Boolean rowIsEmpty = true;
                for (Integer i = 0; i < columnHeaders.size(); i++) {
                    ThreadCell columnHeader = columnHeaders[i];
                    if (columnHeader == null) {
                        continue;
                    }
                    ThreadCell rowValue = sheet.findCellByAddress(new Address(columnHeader.addr.column, row));
                    //This is very strange behavior by Apex. It doesn't treat Unicode 8203 (Zero-width Space) as space symbol
                    //Thus it doesn't consider a string with only this symbol to be an empty string
                    if (!String.isBlank(rowValue.value) && rowValue.value.length() != 1 && rowValue.value.codePointAt(0) != 8203) {
                        rowIsEmpty = false;
                        break;
                    }
                }
                if (rowIsEmpty) {
                    break;
                }
                row++;
            }
            List<ThreadCell> valuesToWrite = new List<ThreadCell>();
            for (Integer i = 0; i < columnHeaders.size(); i++) {
                ThreadCell columnHeader = columnHeaders[i];
                if (columnHeader == null) {
                    continue;
                }
                ThreadCell rowValue = sheet.findCellByAddress(new Address(columnHeader.addr.column, row));
                rowValue.value = values[i];
                valuesToWrite.add(rowValue);
            }
            System.debug(valuesToWrite);
            Quip.saveSpreadsheetData(thread, sheet, valuesToWrite);
        }
        catch (QuipException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='Document Name' description='Case-sensitive, no extension, name only')
        global String FileName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found document will be used')
        global String SheetName;

        @InvocableVariable(required=True label='#1 Column Name')
        global String TargetColumnName1;

        @InvocableVariable(required=True label='#1 Value')
        global String Value1;

        @InvocableVariable(label='#2 Column Name')
        global String TargetColumnName2;

        @InvocableVariable(label='#2 Value')
        global String Value2;

        @InvocableVariable(label='#3 Column Name')
        global String TargetColumnName3;

        @InvocableVariable(label='#3 Value')
        global String Value3;

        @InvocableVariable(label='#4 Column Name')
        global String TargetColumnName4;

        @InvocableVariable(label='#4 Value')
        global String Value4;

        @InvocableVariable(label='#5 Column Name')
        global String TargetColumnName5;

        @InvocableVariable(label='#5 Value')
        global String Value5;

        @InvocableVariable(label='#6 Column Name')
        global String TargetColumnName6;

        @InvocableVariable(label='#6 Value')
        global String Value6;

        @InvocableVariable(label='#7 Column Name')
        global String TargetColumnName7;

        @InvocableVariable(label='#7 Value')
        global String Value7;

        @InvocableVariable(label='#8 Column Name')
        global String TargetColumnName8;

        @InvocableVariable(label='#8 Value')
        global String Value8;

        @InvocableVariable(label='#9 Column Name')
        global String TargetColumnName9;

        @InvocableVariable(label='#9 Value')
        global String Value9;

        @InvocableVariable(label='#10 Column Name')
        global String TargetColumnName10;

        @InvocableVariable(label='#10 Value')
        global String Value10;
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
