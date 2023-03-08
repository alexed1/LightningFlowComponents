

@RestResource(urlMapping='/whatsapp')
global class WhatsAppListener {
    @HttpGet
    global static String doGet() {
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
            return request.params.get('hub.challenge');
        } else
        {
            System.debug('hub.verify_token does NOT equal whatapptoken');
            return 'I am hooked';
        }
    }
}