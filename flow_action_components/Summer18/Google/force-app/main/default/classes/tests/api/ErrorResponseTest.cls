@isTest
public class ErrorResponseTest {    

    @isTest
	static void testParse() {
		String json=		'{'+
		' "error": {'+
		'  "errors": ['+
		'   {'+
		'    "domain": "global",'+
		'    "reason": "invalid",'+
		'    "message": "Invalid Value",'+
		'    "locationType": "parameter",'+
		'    "location": "q"'+
		'   }'+
		'  ],'+
		'  "code": 400,'+
		'  "message": "Invalid Value"'+
		' }'+
		'}';
		ErrorResponse obj = ErrorResponse.parse(json);
		System.assert(obj != null);
	}
}
