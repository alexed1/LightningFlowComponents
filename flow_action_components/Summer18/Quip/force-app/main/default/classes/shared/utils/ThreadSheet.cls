public class ThreadSheet {
    
    public string title;

    public List<List<String>> data;

    public ThreadSheet() {
        data = new List<List<String>>();
    }

    private static final Pattern rowPattern = Pattern.compile('<tr.*?\\/tr>');

    private static final Pattern cellPattern = Pattern.compile('<span.*?\\/span>');

    private static final Pattern titlePattern = Pattern.compile('title=[\'"](.*?)[\'"]');

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
        Matcher rowMatcher = rowPattern.matcher(htmlTable);
        while (rowMatcher.find()) {
            List<String> dataRow = new List<String>();
            Matcher cellMatcher = cellPattern.matcher(rowMatcher.group());
            while (cellMatcher.find()) {
                //Here we extract the cell contents (Quip packs the cell content into span nested into td)
                //Then we strip all html tags from it (e.g. anchors, bold, italic etc) and unescape things like &lt;
                //to get the text visible to the user
                String cellHtml = cellMatcher.group().replaceAll('<.*?>', '').unescapeHtml4();
                dataRow.add(cellHtml);
            }
            result.data.add(dataRow);            
        }
        return result;
    }
}
