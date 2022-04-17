public with sharing class DatoramaReports {
    public DatoramaReports() {

    }

    @auraEnabled 
    public List<DatoramaReport> reports {get;set;} 



	
	
	public static List<DatoramaReport> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfDatoramaReports(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<DatoramaReport> arrayOfDatoramaReports(System.JSONParser p) {
        List<DatoramaReport> res = new List<DatoramaReport>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DatoramaReport(p));
        }
        return res;
    }


}
