public with sharing class WhatsAppMessageObjectText {

	
		@AuraEnabled
        public String body {get;set;} 

		public WhatsAppMessageObjectText(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'body') {
							body = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Text consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	}
	