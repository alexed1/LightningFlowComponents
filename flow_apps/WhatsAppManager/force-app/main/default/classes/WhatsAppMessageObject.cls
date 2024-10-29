public with sharing class WhatsAppMessageObject {
 
//this is the json sent by WhatsApp when a message happens or changes. See https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/components
 /*    {
        "object": "whatsapp_business_account",
        "entry": [
            {
                "id": "0",
                "changes": [
                    {
                        "field": "messages",
                        "value": {
                            "messaging_product": "whatsapp",
                            "metadata": {
                                "display_phone_number": "16505551111",
                                "phone_number_id": "123456123"
                            },
                            "contacts": [
                                {
                                    "profile": {
                                        "name": "test user name"
                                    },
                                    "wa_id": "16315551181"
                                }
                            ],
                            "messages": [
                                {
                                    "from": "16315551181",
                                    "id": "ABGGFlA5Fpa",
                                    "timestamp": "1504902988",
                                    "type": "text",
                                    "text": {
                                        "body": "this is a text message"
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        ]
    } */


    //this code allows the above JSON to be serialized into an Apex object that Flow can use.
	@AuraEnabled
    public String object_Z {get;set;} // in json: object
    
    @AuraEnabled
	public List<WhatsAppMessageObjectEntry> entry {get;set;} 
	
    

	public WhatsAppMessageObject(JSONParser parser) {
        System.debug('ENTERING WHATSAPPMESSAGEOBJECT PARSER');
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'object') {
                        System.debug('yes, text of object is detected');
						object_Z = parser.getText();
					} else if (text == 'entry') {
						entry = arrayOfEntry(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WhatsAppMessageObject consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	
	public static WhatsAppMessageObject parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WhatsAppMessageObject(parser);
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
	
    
    public static List<WhatsAppMessageObjectEntry> arrayOfEntry(System.JSONParser p) {
        List<WhatsAppMessageObjectEntry> res = new List<WhatsAppMessageObjectEntry>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WhatsAppMessageObjectEntry(p));
        }
        return res;
    }


    public static List<WhatsAppMessageObjectChanges> arrayOfChanges(System.JSONParser p) {
        List<WhatsAppMessageObjectChanges> res = new List<WhatsAppMessageObjectChanges>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WhatsAppMessageObjectChanges(p));
        }
        return res;
    }

    public static List<WhatsAppMessageObjectContacts> arrayOfContacts(System.JSONParser p) {
        List<WhatsAppMessageObjectContacts> res = new List<WhatsAppMessageObjectContacts>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WhatsAppMessageObjectContacts(p));
        }
        return res;
    }


    public static List<WhatsAppMessageObjectMessages> arrayOfMessages(System.JSONParser p) {
        List<WhatsAppMessageObjectMessages> res = new List<WhatsAppMessageObjectMessages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WhatsAppMessageObjectMessages(p));
        }
        return res;
    }







}