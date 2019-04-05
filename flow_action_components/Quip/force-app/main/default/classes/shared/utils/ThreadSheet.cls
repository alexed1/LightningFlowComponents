public class ThreadSheet {

    public String title;

    public List<ThreadRow> rows;

    public List<String> headers;

    public ThreadSheet() {
        rows = new List<ThreadRow>();
        headers = new List<String>();
    }

    private static final Pattern bodyPattern = Pattern.compile('(?s)<tbody.*?\\/tbody>');

    private static final Pattern rowPattern = Pattern.compile('(?s)<tr.*?\\/tr>');

    private static final Pattern headerPattern = Pattern.compile('(?s)<th.*?\\/th>');

    private static final Pattern cellPattern = Pattern.compile('(?s)<td.*?\\/td>');

    private static final Pattern cellContentPattern = Pattern.compile('(?s)<span.*?\\/span>');

    private static final Pattern titlePattern = Pattern.compile('(?s)title=[\'"](.*?)[\'"]');

    private static final Pattern idPattern = Pattern.compile('(?s)id=[\'"](.*?)[\'"]');

    //Due to the way Quip stores its data, we can't parse its HTML using Dom.Xml* classes
    //E.g. it may look like this "<tr><td><span><b>Bold</b> not bold</span></td></tr>"
    //This example is not valid XML although it is valid HTML but Dom.XmlNode will capture only 'Bold' part of the text ignoring what goes after
    public static ThreadSheet parseHtml(String htmlTable) {
        //Sheet title
        ThreadSheet result = new ThreadSheet();
        Matcher titleMatcher = titlePattern.matcher(htmlTable);
        if (titleMatcher.find()) {
            String title = titleMatcher.group().substringBetween('\'');
            title = title == null ? titleMatcher.group().substringBetween('"') : title;
            result.title = title;
        }
        //Table headers
        Matcher headerMatcher = headerPattern.matcher(htmlTable);
        while (headerMatcher.find()) {
            String header = headerMatcher.group().replaceAll('<.*?>', '').unescapeHtml4();
            result.headers.add(header.trim());
        }
        //Table body
        Matcher bodyMatcher = bodyPattern.matcher(htmlTable);
        String tableBody = '';
        if (bodyMatcher.find()) {
            tableBody = bodyMatcher.group();
        }
        //Table rows
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
                //Latest version of API returns fake cell which represents row header
                //This cell has no Id and thus you can't reference it inside API calls
                //But it should be fine because Quip also doesn't allow to edit it in web UI
                if (!cellIdMatcher.find()) {
                    continue;
                }
                String cellId = cellIdMatcher.group().substring(4, cellIdMatcher.group().length()- 1);
                Matcher cellContentMatcher = cellContentPattern.matcher(cellHtml);
                cellContentMatcher.find();
                //Here we extract the cell contents (Quip packs the cell content into span nested into td)
                //Then we strip all html tags from it (e.g. anchors, bold, italic etc) and unescape things like &lt;
                //to get the text visible to the user
                String cellContent = cellContentMatcher.group().replaceAll('<.*?>', '').unescapeHtml4();
                Boolean isCheckbox = cellContent == ThreadCell.TRUE_CHECK_BOX || cellContent == ThreadCell.FALSE_CHECK_BOX;
                cellContent = cellContent == ThreadCell.TRUE_CHECK_BOX
                                ? 'True' 
                                : cellContent == ThreadCell.FALSE_CHECK_BOX ? 'False' : cellContent;
                Address addr = new Address(colIndex, rowIndex);                
                ThreadCell cell = new ThreadCell(addr, cellId, cellContent);
                //cell.valueTypeIsCheckbox = isCheckbox;
                row.cells.add(cell);
                colIndex++;
            }
            result.rows.add(row);  
            rowIndex++;          
        }
        return result;
    }

    public ThreadCell findCellByValue(String value) {
        List<ThreadCell> result = findCellsByValue(value);
        return result.size() > 0 ? result[0] : null;
    }

    public List<ThreadCell> findCellsByValue(String value) {
        List<ThreadCell> result = new List<ThreadCell>();
        for (Integer rowIndex = 0; rowIndex < rows.size(); rowIndex++) {
            List<ThreadCell> row = rows[rowIndex].cells;
            for (Integer colIndex = 0; colIndex < row.size(); colIndex++) {
                if (row[colIndex].value.equals(value)) {
                    result.add(row[colIndex]);
                }
            }
        }
        return result;
    }

    public ThreadCell findCellByAddress(Address address) {
        if (address.row == -1) {
            if (address.column >= 0 && address.column < headers.size()) {
                return new ThreadCell(address, null, headers[address.column]);
            }
        }   
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

    public ThreadCell findCell(String addr, String rightOf, String belowOf) {
        ThreadCell result = null;
        if (!String.isBlank(addr)) {
            return findCellByAddress(Address.parse(addr, this));
        } else {
            List<ThreadCell> rightTargets = String.isBlank(rightOf) ? new List<ThreadCell>() : findCellsByValue(rightOf);
            List<ThreadCell> belowTargets = String.isBlank(belowOf) ? new List<ThreadCell>() : findCellsByValue(belowOf);
            //In this case we need to get all cells that lies in the specific direction from the target values
            //and take the first one that satisfies both criteria
            Set<ThreadCell> intersectionValue = new Set<ThreadCell>();
            if (rightTargets.size() > 0 && belowTargets.size() > 0) {
                for (ThreadCell rightTarget: rightTargets) {
                    ThreadRow row = rows[rightTarget.addr.row];
                    for (Integer col = rightTarget.addr.column + 1; col < row.cells.size(); col++) {
                        intersectionValue.add(row.cells[col]);
                    }
                }

                for (ThreadCell belowTarget: belowTargets) {
                    for (Integer row = belowTarget.addr.row + 1; row < rows.size(); row++) {
                        ThreadCell intersection = rows[row].cells[belowTarget.addr.column];
                        if (intersectionValue.contains(intersection)) {
                            return intersection;
                        }
                    }
                }
            } else if (rightTargets.size() > 0) {
                return findCellByAddress(rightTargets[0].addr.shiftRight());
            } else {
                return findCellByAddress(belowTargets[0].addr.shiftBelow());
            }
        }
        //This is the scenario when we have both 'Right' and 'Below' directions, but they don't intersect
        return null;
    }
}
