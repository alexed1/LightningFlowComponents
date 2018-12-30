@isTest
public class ThreadSheetTest {
    
    @isTest
    public static void parseHtml_ConvertsCheckBoxesToString() {
        String table = '<table><thead><tr id="h-row"><th id="col-0">Col 0</th></tr></thead><tbody><tr id="row-0"><td id="true"><span>☑</span></td></tr><tr id="row-1"><td id="false"><span>☐</span></td></tr></tbody></table>';
        ThreadSheet sheet = ThreadSheet.parseHtml(table);
        System.assertEquals('True', sheet.rows[0].cells[0].value);
        System.assertEquals('False', sheet.rows[1].cells[0].value);
    }

    @isTest
    public static void findCellByAddress_NegativeRowReturnsHeader() {
        ThreadSheet sheet = new ThreadSheet();
        sheet.headers.add('Test1');
        sheet.headers.add('Test2');
        ThreadCell cell = sheet.findCellByAddress(new Address(1, -1));
        System.assertEquals('Test2', cell.value);
    }
}
