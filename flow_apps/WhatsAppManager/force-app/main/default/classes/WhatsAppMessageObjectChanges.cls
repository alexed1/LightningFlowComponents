public with sharing class WhatsAppMessageObjectChanges {

        @AuraEnabled
		public String field {get;set;} 
		@AuraEnabled
        public WhatsAppMessageObjectValue value {get;set;} 

		public WhatsAppMessageObjectChanges(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'field') {
							field = parser.getText();
						} else if (text == 'value') {
							value = new WhatsAppMessageObjectValue(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Changes consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	
	
}