public with sharing class WhatsAppMessageObjectMetadata {

	

		@AuraEnabled
        public String display_phone_number {get;set;} 
		@AuraEnabled
        public String phone_number_id {get;set;} 

		public WhatsAppMessageObjectMetadata(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'display_phone_number') {
							display_phone_number = parser.getText();
						} else if (text == 'phone_number_id') {
							phone_number_id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
							WhatsAppMessageObject.consumeObject(parser);
						}
					}
				}
			}
		}
	
}