public with sharing class WhatsAppMessageObjectValue {

		@AuraEnabled
        public String messaging_product {get;set;} 
		@AuraEnabled
        public WhatsAppMessageObjectMetadata metadata {get;set;} 
		@AuraEnabled
        public List<WhatsAppMessageObjectContacts> contacts {get;set;} 
		@AuraEnabled
        public List<WhatsAppMessageObjectMessages> messages {get;set;} 

		public WhatsAppMessageObjectValue(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'messaging_product') {
							messaging_product = parser.getText();
						} else if (text == 'metadata') {
							metadata = new WhatsAppMessageObjectMetadata(parser);
						} else if (text == 'contacts') {
							contacts = WhatsAppMessageObject.arrayOfContacts(parser);
						} else if (text == 'messages') {
							messages = WhatsAppMessageObject.arrayOfMessages(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Value consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	}
