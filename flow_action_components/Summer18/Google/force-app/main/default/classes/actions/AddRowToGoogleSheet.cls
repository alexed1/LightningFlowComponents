global class AddRowToGoogleSheet {
    
    @InvocableMethod(label='Add Row to Google Sheet' description='Adds a new row after the last non-empty one using the specified column labels and values')
    global static List<Response> AddRowToGoogleSheet(List<Request> requests) {
        IGoogleDrive googleDrive = new GoogleDrive(new GoogleAPI());
        List<Response> responses = new List<Response>();
        for (Request request: requests) {
            Response response = AddRowToGoogleSheet.AddRowToGoogleSheetImpl(googleDrive, request);
            responses.add(response);
        }
        return responses;
    }

    public static Response AddRowToGoogleSheetImpl(IGoogleDrive googleDrive, Request request) {
        Response response = new Response();
        try {
            String spreadsheetId = googleDrive.findFileIdByName(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (String.isBlank(spreadsheetId)) {
                throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
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
            SheetData data = null;
            //First we need to find the columns to write values to
            List<CellValue> columnHeaders = new List<CellValue>();            
            for (Integer i = 0; i < columns.size(); i++) {
                String column = columns[i];
                if (String.isBlank(column)) {
                    columnHeaders.add(null);
                    continue;
                }
                String value = values[i];
                if (data == null) {
                    data = new SheetData(googleDrive.getSpreadsheetData(spreadsheetId, request.SheetName));
                }
                CellValue cell = data.findCellByValue(columns[i]);
                if (cell == null) {
                    Address addr = Address.parse(columns[i] + '1');
                    if (addr.column > 1000) {
                        //For now we assume that there can't be too many columns
                        columnHeaders.add(null);
                        continue;
                    }
                    cell = data.getValueByAddress(addr);
                }
                columnHeaders.add(cell);
            }
            //Now we need to find the first empty row that lies below all column headers
            Integer row = 0;
            for (CellValue columnHeader: columnHeaders) {
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
                    CellValue columnHeader = columnHeaders[i];
                    if (columnHeader == null) {
                        continue;
                    }
                    CellValue rowValue = data.getValueByAddress(new Address(columnHeader.addr.column, row));
                    if (!String.isBlank(rowValue.value)) {
                        rowIsEmpty = false;
                        break;
                    }
                }
                if (rowIsEmpty) {
                    break;
                }
                row++;
            }
            List<CellValue> valuesToWrite = new List<CellValue>();
            for (Integer i = 0; i < columnHeaders.size(); i++) {
                CellValue columnHeader = columnHeaders[i];
                if (columnHeader == null) {
                    continue;
                }
                CellValue rowValue = new CellValue(new Address(columnHeader.addr.column, row), values[i]);
                valuesToWrite.add(rowValue);
            }
            System.debug(valuesToWrite);
            googleDrive.saveSpreadsheetData(spreadsheetId, request.SheetName, valuesToWrite);
        }
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }

    global class Request {

        @InvocableVariable(required=True label='Spreadsheet Name' description='Case-sensitive, no extension, name only')
        global String SpreadsheetName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found spreadsheet will be used')
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
