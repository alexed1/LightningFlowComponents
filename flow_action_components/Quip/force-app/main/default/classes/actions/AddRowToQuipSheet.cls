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
            //First we need to find the columns to write values to
            List<ColumnValue> updateValues = new List<ColumnValue>();
            for (Integer i = columnValues.size() - 1; i >= 0; i--) {
                ColumnValue columnValue = columnValues[i];
                ThreadCell cell = sheet.findCellByValue(columnValue.column);
                if (cell == null) {
                    Integer columnIndex = sheet.headers.indexOf(columnValue.column);
                    if (columnIndex == -1) {
                        columnValues.remove(i);
                        continue;
                    }
                    cell = sheet.findCellByAddress(new Address(columnIndex, -1));
                }
                columnValue.headerCell = cell;
                if (columnValue.isUpdate) {
                    updateValues.add(columnValue);
                }
            }
            Boolean isUpdate = updateValues.size() > 0;
            //Now, if this is update, we need to find the row with the matching index columns
            Boolean rowFound = false;      
            Integer headerRow = -1;            
            for (ColumnValue columnValue: columnValues) {
                if (columnValue.headerCell.addr.row > headerRow) {
                    headerRow = columnValue.headerCell.addr.row;
                }
            }      
            Integer row = headerRow + 1;
            if (isUpdate) {
                //We loop through all rows and check whether all index columns has values equals to the target ones
                for (Integer i = row; i < sheet.rows.size(); i++) {
                    rowFound = true;
                    for (ColumnValue updateParameter : updateValues) {
                        if (!sheet.rows[i].cells[updateParameter.headerCell.addr.column].value.equals(updateParameter.value)) {
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
                        ThreadCell rowValue = sheet.findCellByAddress(new Address(columnValue.headerCell.addr.column, row));
                        //This is very strange behavior by Apex. It doesn't treat Unicode 8203 (Zero-width Space) as space symbol
                        //Thus it doesn't consider a string with only this symbol to be an empty string
                        if (!String.isBlank(rowValue.value) && rowValue.value.length() != 1 && rowValue.value.codePointAt(0) != 8203) {
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
            List<ThreadCell> valuesToWrite = new List<ThreadCell>();
            for (ColumnValue columnValue : columnValues) {       
                Address addr = new Address(columnValue.headerCell.addr.column, row);        
                ThreadCell rowValue = sheet.findCellByAddress(addr);
                //If previously there was a checkbox in this cell
                //Boolean shouldBeCheckbox = rowValue.isCheckbox() || rowValue.valueTypeIsCheckbox;
                //if (!shouldBeCheckbox && String.isBlank(rowValue.value)) {
                //    ThreadCell cellAbove = sheet.findCellByAddress(addr.shiftBelow(-1));
                //    //Or this is a new row and a checkbox is in the cell above (most likely it means that the column should have only checkboxes)
                //    shouldBeCheckbox = cellAbove.isCheckbox() || cellAbove.valueTypeIsCheckbox;
                //}
                //And if new value is True or False then we save value as a checkbox
                //if (shouldBeCheckbox && (columnValue.value.equalsIgnoreCase('true') || columnValue.value.equalsIgnoreCase('false'))) {
                 //   rowValue.value = String.format('<span>{0}</span>',
                //        new List<String> { columnValue.value.equalsIgnoreCase('true') ? ThreadCell.TRUE_CHECK_BOX : ThreadCell.FALSE_CHECK_BOX });
                //} else {                    
                //    rowValue.value = columnValue.value;
                //}
                rowValue.value = columnValue.value;
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

    private class ColumnValue {

        public String column;

        public String value;

        public Boolean isUpdate;

        public ThreadCell headerCell;

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

        @InvocableVariable(required=True label='Document Name' description='Case-sensitive, no extension, name only')
        global String FileName;

        @InvocableVariable(label='Sheet Name' description='Case-sensitive. If left blank, the first sheet of the found document will be used')
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
