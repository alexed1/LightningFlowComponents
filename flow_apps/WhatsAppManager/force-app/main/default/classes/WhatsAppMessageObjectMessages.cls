public with sharing class WhatsAppMessageObjectMessages {

		@AuraEnabled
        public String from_Z {get;set;} // in json: from
		@AuraEnabled
        public String id {get;set;} 
		@AuraEnabled
        public String timestamp {get;set;} 
		@AuraEnabled
        public String type {get;set;} 
		@AuraEnabled
        public WhatsAppMessageObjectText text {get;set;} 

		public WhatsAppMessageObjectMessages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String curText = parser.getText(); //renaming to curText because the Text object is conflicting with this Text string
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (curText == 'from') {
							from_Z = parser.getText();
						} else if (curText == 'id') {
							id = parser.getText();
						} else if (curText == 'timestamp') {
							timestamp = parser.getText();
						} else if (curText == 'type') {
							type = parser.getText();
						} else if (curText == 'text') {
							text = new WhatsAppMessageObjectText(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Messages consuming unrecognized property: '+curText);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	
}