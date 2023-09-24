public with sharing class WhatsAppMessageObjectEntry {

        @AuraEnabled
		public String id {get;set;} 
        @AuraEnabled
		public List<WhatsAppMessageObjectChanges> changes {get;set;} 

		public WhatsAppMessageObjectEntry(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'changes') {
							changes = WhatsAppMessageObject.arrayOfChanges(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Entry consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}


}
   

