global class SendEmailviaSendGrid {
    
    @InvocableMethod
    global static void Send(List<SendEmailViaSendGridRequest> requests) { 
        System.debug('requests is:' + requests);
		SendEmailViaSendGridRequest request = requests[0];
        SendGrid sendgrid = new SendGrid(request.username,request.password);
        
        SendGrid.email email = new SendGrid.Email();
        email.addTo(request.toRecipient);
        email.setFrom(request.fromEmail);
        email.setSubject(request.subject);
        email.setText(request.bodyText);
        email.setHtml(request.bodyHTML);
        
        SendGrid.SendGridResponse response = sendgrid.send(email);
    }
    
    global class SendEmailViaSendGridRequest {

        @InvocableVariable(required=true)
        global String username;
            
        @InvocableVariable(required=true)
        global String password;   
        
        @InvocableVariable(required=true)
        global String subject;   
        
        @InvocableVariable(required=true)
        global String toRecipient;
            
        @InvocableVariable(required=true)
        global String fromEmail; 
            
        @InvocableVariable(required=false)
        global String bodyText; 
            
        @InvocableVariable(required=false)
        global String bodyHTML; 
    }   

}