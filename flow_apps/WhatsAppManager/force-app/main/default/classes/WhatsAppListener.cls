//credit for the Get and Post handling code to SFDC Panther https://www.youtube.com/watch?v=55RznL0pvbQ&list=PL3Rr8DM87XnBeFSkT1ogMw5Cw6G0niBsu&index=6

@RestResource(urlMapping='/whatsapp')
global class WhatsAppListener {

    private static Final String SIGNATURE_VALID_MESSAGE = 'Signature Verified';
    private static Final String SIGNATURE_NOT_VALID_MESSAGE = 'Signature could not be verified';


    @HttpGet
    global static Void doGet() {
        System.debug('entered doGet');
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        System.debug('verify token is: ' + request.params.get('hub.verify_token'));
        if(request.params.get('hub.verify_token') == 'WHATSAPPTOKEN'){
            System.debug('hub.verify_token DOES equal whatapptoken');

            response.responseBody = Blob.valueOf( request.params.get('hub.challenge') );
            System.debug('hub.challenge in request is: ' + request.params.get('hub.challenge'));
            System.debug('responsebody = ' + response.responseBody.toString());
            //return response.responseBody.toString();
            //return request.params.get('hub.challenge');
        } else
        {
            System.debug('hub.verify_token does NOT equal whatapptoken');
            System.debug('request is: ' + request.requestBody );
        }
    }

     @HttpPost
    global static void handleIncomingPost() {
        System.debug('entered handleIncomingPost');

        //prepare success response for Whatsapp
        RestResponse response = RestContext.response;
        response.addHeader('Content-type', 'application/json');
        String responseString = RestContext.request.requestBody.toString();
        Map<String,String> headers = RestContext.request.headers;
        String responseValid = validateWhatsAppSignature(RestContext.request, responseString);

        if (responseValid == SIGNATURE_VALID_MESSAGE){
            System.debug('Headers Response from WhatsApp \n ' + JSON.serialize(headers));
            System.debug('Response From WhatsApp \n ' + responseString);
        } else {
            response.responseBody = Blob.valueOf('{success:false, event: "Unknown", "message:" ' + responseValid+ '"}');
            response.statusCode = 401;
            return;
        }

        RestRequest request = RestContext.request;
        System.debug('request is: ' + request.requestBody );
        
    }

    private static String validateWhatsAppSignature(RestRequest request, String responseString) {
        Map<String, String> headers = request.headers;
        String whatsAppSignature = headers.get('X-Hub-Signature-256');
        String whatsAppPayload = RestContext.request.requestBody.toString();

        //Verify the sigature using hmacSHA256. Assumes the Webhook App secret is stored in a Custom Label
        String whatsAppSecret = System.Label.WhatsAppSecret;
        Blob signedPayload = Crypto.generateMac('hmacSHA256', Blob.valueOf(whatsAppPayload), Blob.valueOf(whatsAppSecret));

        String encodedPayload = 'sha256=' +EncodingUtil.convertToHex(signedPayload);

        String response = (encodedPayload == whatsAppSignature)? SIGNATURE_VALID_MESSAGE : SIGNATURE_NOT_VALID_MESSAGE;
        return response;
    }
}