public class ThreadSheet {

    public String title;

    public List<ThreadRow> rows;

    public ThreadSheet() {
        rows = new List<ThreadRow>();
    }

    private static final Pattern bodyPattern = Pattern.compile('(?s)<tbody.*?\\/tbody>');

    private static final Pattern rowPattern = Pattern.compile('(?s)<tr.*?\\/tr>');

    private static final Pattern cellPattern = Pattern.compile('(?s)<td.*?\\/td>');

    private static final Pattern cellContentPattern = Pattern.compile('(?s)<span.*?\\/span>');

    private static final Pattern titlePattern = Pattern.compile('(?s)title=[\'"](.*?)[\'"]');

    private static final Pattern idPattern = Pattern.compile('(?s)id=[\'"](.*?)[\'"]');

    //Due to the way Quip stores its data, we can't parse its HTML using Dom.Xml* classes
    //E.g. it may look like this "<tr><td><span><b>Bold</b> not bold</span></td></tr>"
    //This example is not valid XML although it is valid HTML but Dom.XmlNode will capture only 'Bold' part of the text ignoring what goes after
    public static ThreadSheet parseHtml(String htmlTable) {
        ThreadSheet result = new ThreadSheet();
        Matcher titleMatcher = titlePattern.matcher(htmlTable);
        if (titleMatcher.find()) {
            String title = titleMatcher.group().substringBetween('\'');
            title = title == null ? titleMatcher.group().substringBetween('"') : title;
            result.title = title;
        }
        Matcher bodyMatcher = bodyPattern.matcher(htmlTable);
        String tableBody = '';
        if (bodyMatcher.find()) {
            tableBody = bodyMatcher.group();
        }
        Matcher rowMatcher = rowPattern.matcher(tableBody);
        Integer rowIndex = 0;
        while (rowMatcher.find()) {
            String rowHtml = rowMatcher.group();
            Matcher rowIdMatcher = idPattern.matcher(rowHtml);
            rowIdMatcher.find();
            ThreadRow row = new ThreadRow(rowIdMatcher.group().substring(4, rowIdMatcher.group().length() - 1));
            Matcher cellMatcher = cellPattern.matcher(rowHtml);
            Integer colIndex = 0;
            while (cellMatcher.find()) {
                String cellHtml = cellMatcher.group();
                Matcher cellIdMatcher = idPattern.matcher(cellHtml);
                cellIdMatcher.find();
                String cellId = cellIdMatcher.group().substring(4, cellIdMatcher.group().length()- 1);
                Matcher cellContentMatcher = cellContentPattern.matcher(cellHtml);
                cellContentMatcher.find();
                //Here we extract the cell contents (Quip packs the cell content into span nested into td)
                //Then we strip all html tags from it (e.g. anchors, bold, italic etc) and unescape things like &lt;
                //to get the text visible to the user
                String cellContent = cellContentMatcher.group().replaceAll('<.*?>', '').unescapeHtml4();
                Address addr = new Address(colIndex, rowIndex);
                ThreadCell cell = new ThreadCell(addr, cellId, cellContent);
                row.cells.add(cell);
                colIndex++;
            }
            result.rows.add(row);  
            rowIndex++;          
        }
        return result;
    }

    public ThreadCell findCellByValue(String value) {
        for (Integer rowIndex = 0; rowIndex < rows.size(); rowIndex++) {
            List<ThreadCell> row = rows[rowIndex].cells;
            for (Integer colIndex = 0; colIndex < row.size(); colIndex++) {
                if (row[colIndex].value.equalsIgnoreCase(value)) {
                    return row[colIndex];
                }
            }
        }
        return null;
    }    

    public Address findAddressByValue(String value) {
        ThreadCell cell = findCellByValue(value);
        if (cell == null) {
            return null;
        }
        return cell.addr;
    }

    public ThreadCell findCellByAddress(Address address) {   
        ThreadCell result = null; 
        if (address.row >= 0 && address.row < rows.size()) {
            List<ThreadCell> row = rows[address.row].cells;     
            if (address.column >= 0 && address.column < row.size()) {
                return row[address.column];
            }
        }
        if (result == null) {
            result = new ThreadCell(address, null, '');
        }
        return result;
    }
}
