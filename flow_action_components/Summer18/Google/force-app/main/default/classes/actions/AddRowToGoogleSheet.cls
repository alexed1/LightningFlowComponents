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
            File file = googleDrive.getFile(request.SpreadsheetName, FileMimeTypes.GOOGLE_SHEET);
            if (file == null) {
                throw new GoogleException('Spreadsheet with the name "' + request.SpreadsheetName + '" was not found');
            }              
            List<ColumnValue> columnValues = new List<ColumnValue>();
            columnValues.add(new ColumnValue(request.TargetColumnName1, request.Value1, request.IsUpdate1));
            columnValues.add(new ColumnValue(request.TargetColumnName2, request.Value2, request.IsUpdate2));
            columnValues.add(new ColumnValue(request.TargetColumnName3, request.Value3, request.IsUpdate3));
            columnValues.add(new ColumnValue(request.TargetColumnName4, request.Value4, request.IsUpdate4));
            columnValues.add(new ColumnValue(request.TargetColumnName5, request.Value5, request.IsUpdate5));
            columnValues.add(new ColumnValue(request.TargetColumnName6, request.Value6, request.IsUpdate6));
            columnValues.add(new ColumnValue(request.TargetColumnName7, request.Value7, request.IsUpdate7));
            columnValues.add(new ColumnValue(request.TargetColumnName8, request.Value8, request.IsUpdate8));
            columnValues.add(new ColumnValue(request.TargetColumnName9, request.Value9, request.IsUpdate9));
            columnValues.add(new ColumnValue(request.TargetColumnName10, request.Value10, request.IsUpdate10));
            for (Integer i = columnValues.size() - 1; i >= 0; i--) {
                if (!columnValues[i].isValid()) {
                    columnValues.remove(i);
                }
            }
            SheetData data = new SheetData(googleDrive.getSpreadsheetData(file.id, request.SheetName));
            //First we need to find the columns to write values to
            List<ColumnValue> updateValues = new List<ColumnValue>();
            for (Integer i = columnValues.size() - 1; i >= 0; i--) {
                ColumnValue columnValue = columnValues[i];
                CellValue cell = data.findCellByValue(columnValue.column);
                if (cell == null) {
                    Address addr = Address.parse(columnValue.column + '1');
                    if (addr.column > 1000) {
                        //For now we assume that there can't be too many columns
                        columnValues.remove(i);
                        continue;
                    }
                    cell = data.getValueByAddress(addr);
                }
                columnValue.headerCell = cell;
                if (columnValue.isUpdate) {
                    updateValues.add(columnValue);
                }
            }             
            Boolean isUpdate = updateValues.size() > 0;
            //Now, if this is update, we need to find the row with the matching index columns
            Boolean rowFound = false;      
            Integer headerRow = 0;            
            for (ColumnValue columnValue: columnValues) {
                if (columnValue.headerCell.addr.row > headerRow) {
                    headerRow = columnValue.headerCell.addr.row;
                }
            }    
            Integer row = headerRow + 1;
            if (isUpdate) {
                //We loop through all rows and check whether all index columns has values equals to the target ones
                for (Integer i = row; i < data.data.size(); i++) {
                    rowFound = true;
                    for (ColumnValue updateParameter : updateValues) {
                        if (!data.getValueByAddress(new Address(updateParameter.headerCell.addr.column, i)).value.equals(updateParameter.value)) {
                            rowFound = false;
                            break;
                        }
                    }
                    if (rowFound) {
                        row = i;
                        break;
                    }
                }
            }            
            if (!rowFound) {
                //If it was not update, or we just couldn't find a specified index, then we need to find the first empty row that is located below all column headers
                while (true) {
                    rowFound = true;
                    for (ColumnValue columnValue : columnValues) {
                        CellValue rowValue = data.getValueByAddress(new Address(columnValue.headerCell.addr.column, row));
                        if (!String.isBlank(rowValue.value)) {
                            rowFound = false;
                            break;
                        }
                    }
                    if (rowFound) {
                        break;
                    }
                    row++;
                }
            }
            List<CellValue> valuesToWrite = new List<CellValue>();
            for (ColumnValue columnValue : columnValues) {
                CellValue rowValue = new CellValue(new Address(columnValue.headerCell.addr.column, row), columnValue.value);
                valuesToWrite.add(rowValue);
            }
            System.debug(valuesToWrite);
            googleDrive.saveSpreadsheetData(file.id, request.SheetName, valuesToWrite);
        }
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }       
        return response;
    }

    private class ColumnValue {

        public String column;

        public String value;

        public Boolean isUpdate;

        public CellValue headerCell;

        public ColumnValue(String column, String value, Boolean isUpdate) {
            this.column = column;
            this.value = String.isBlank(value) ? '' : value;
            this.isUpdate = isUpdate == null ? false : isUpdate;
        }

        public Boolean isValid() {
            return !String.isBlank(column);
        }
    }

    global class Request {

        @InvocableVariable(required=True label='File Name' description='A name of the file or a path to the file')
        global String SpreadsheetName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found spreadsheet will be used')
        global String SheetName;

        @InvocableVariable(label='#1 Column Name')
        global String TargetColumnName1;

        @InvocableVariable(label='#1 Value')
        global String Value1;

        @InvocableVariable(label='#1 Use Value as Index for Updates')
        global Boolean IsUpdate1;

        @InvocableVariable(label='#2 Column Name')
        global String TargetColumnName2;

        @InvocableVariable(label='#2 Value')
        global String Value2;

        @InvocableVariable(label='#2 Use Value as Index for Updates')
        global Boolean IsUpdate2;

        @InvocableVariable(label='#3 Column Name')
        global String TargetColumnName3;

        @InvocableVariable(label='#3 Value')
        global String Value3;

        @InvocableVariable(label='#3 Use Value as Index for Updates')
        global Boolean IsUpdate3;

        @InvocableVariable(label='#4 Column Name')
        global String TargetColumnName4;

        @InvocableVariable(label='#4 Value')
        global String Value4;

        @InvocableVariable(label='#4 Use Value as Index for Updates')
        global Boolean IsUpdate4;

        @InvocableVariable(label='#5 Column Name')
        global String TargetColumnName5;

        @InvocableVariable(label='#5 Value')
        global String Value5;

        @InvocableVariable(label='#5 Use Value as Index for Updates')
        global Boolean IsUpdate5;

        @InvocableVariable(label='#6 Column Name')
        global String TargetColumnName6;

        @InvocableVariable(label='#6 Value')
        global String Value6;

        @InvocableVariable(label='#6 Use Value as Index for Updates')
        global Boolean IsUpdate6;

        @InvocableVariable(label='#7 Column Name')
        global String TargetColumnName7;

        @InvocableVariable(label='#7 Value')
        global String Value7;

        @InvocableVariable(label='#7 Use Value as Index for Updates')
        global Boolean IsUpdate7;

        @InvocableVariable(label='#8 Column Name')
        global String TargetColumnName8;

        @InvocableVariable(label='#8 Value')
        global String Value8;

        @InvocableVariable(label='#8 Use Value as Index for Updates')
        global Boolean IsUpdate8;

        @InvocableVariable(label='#9 Column Name')
        global String TargetColumnName9;

        @InvocableVariable(label='#9 Value')
        global String Value9;

        @InvocableVariable(label='#9 Use Value as Index for Updates')
        global Boolean IsUpdate9;

        @InvocableVariable(label='#10 Column Name')
        global String TargetColumnName10;

        @InvocableVariable(label='#10 Value')
        global String Value10;

        @InvocableVariable(label='#10 Use Value as Index for Updates')
        global Boolean IsUpdate10;
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
