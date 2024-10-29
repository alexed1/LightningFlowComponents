public with sharing class WhatsAppMessageObjectContacts {

		@AuraEnabled
        public WhatsAppMessageObjectProfile profile {get;set;} 
		@AuraEnabled
        public String wa_id {get;set;} 

		public WhatsAppMessageObjectContacts(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'profile') {
							profile = new WhatsAppMessageObjectProfile(parser);
						} else if (text == 'wa_id') {
							wa_id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Contacts consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	}
