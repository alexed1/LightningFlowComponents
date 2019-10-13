public with sharing class ConvertFilesToAttachments {

    @invocableMethod(label='Convert Files to Attachments')
    public static List<Response>  convert(List<Request> requests) {
        
      
        List<ContentDocumentLink> curContentDocumentLinks = requests[0].curContentDocumentLinks;
        String errors;
        //retrieve the corresponding content versions
        //first extract the ContentDocumentIds from the ContentDocumentLinks
        List<id> ContentDocumentids = new List<id>();
        if(curContentDocumentLinks != null) {
            for(contentDocumentLink CDLink : curContentDocumentLinks)
			   ContentDocumentids.add(CDLink.ContentDocumentid);    
        } else {
            errors = 'WARN: The ConvertFilesToAttachments action received null instead of a list of Content Document Links (file references)';
        }
            

        List<ContentVersion> curContentVersions = [SELECT title, FileType, versiondata 
											       FROM contentversion 
											       WHERE ContentDocumentId IN :ContentDocumentids  
											      ];

        //convert them into attachments
        List<Attachment> curAttachments = new List<Attachment>();
		for ( ContentVersion curContentVersion :  curContentVersions){
            Attachment curAttachment = generateAttachment(curContentVersion);
            curAttachments.add(curAttachment); 
        }			  
			  
        
        //report back the results
        Response response = new Response();
        response.curAttachments = curAttachments;
        response.errors = errors;
        
       
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }

    public static Attachment generateAttachment(ContentVersion curContentVersion) {
		Attachment curAttachment = new Attachment();
	    curAttachment.name = curContentVersion.title +'.' + curContentVersion.FileType;
	    curAttachment.body = curContentVersion.versiondata;
        return curAttachment;
    }


    public class Request {
        @invocableVariable
        public List<ContentDocumentLink> curContentDocumentLinks;

        

    }

    public class Response {
        @invocableVariable
        public List<Attachment> curAttachments; 

        @invocableVariable
        public Boolean isSuccess; 
        
        @invocableVariable
        public String errors;

    }
            
    public class InvocableActionException extends Exception {}
   
}
