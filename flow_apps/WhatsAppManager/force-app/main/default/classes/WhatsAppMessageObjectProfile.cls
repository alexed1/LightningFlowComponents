public with sharing class WhatsAppMessageObjectProfile {
	

		@AuraEnabled
        public String name {get;set;} 

		public WhatsAppMessageObjectProfile(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Profile consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	
}