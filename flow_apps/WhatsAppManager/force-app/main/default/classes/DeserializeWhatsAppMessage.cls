public with sharing class DeserializeWhatsAppMessage {
    @invocableMethod 
    public static List <Response> execute (List<Request> requestList){
        List<Response> responseWrapper = new List<Response>();
        for (Request curRequest : requestList) {
            Response curResponse = new Response();

            String jsonResponse = curRequest.whatsappMessageJSON;
            jsonResponse = jsonResponse.replace('"object"', '"object_Z"');
            jsonResponse = jsonResponse.replace('"from"', '"from_Z"');
            System.debug('AFTER REPLACEMENT, json is: ' + jsonResponse);
            curResponse.whatsappMessageObject =  (WhatsAppMessageObject)JSON.deserialize(
                jsonResponse, WhatsAppMessageObject.class);  
            //add the output to the output list
            responseWrapper.add(curResponse);
        }
    //return the output list
    return responseWrapper; 
}
    
    public class Request{
        @InvocableVariable(required=true label='WhatsApp Message JSON' description='the raw JSON sent in with a Whatsapp Webhook')
            public String whatsappMessageJSON;

    }
    public class Response{
        @InvocableVariable( label='WhatsApp Message Object' description='An Apex Type that can be manipulated in Flow')
        public WhatsAppMessageObject whatsappMessageObject;
      
    }
}