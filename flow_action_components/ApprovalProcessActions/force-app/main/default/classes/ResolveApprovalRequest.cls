public with sharing class ResolveApprovalRequest {
    @InvocableMethod
    public static List<Results> execute(List<Requests> requests) {
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requests) {
            Results response = new Results();
            Approval.ProcessWorkitemRequest approvalWorkItem = new Approval.ProcessWorkitemRequest();
            approvalWorkItem.setComments(curRequest.comments);
            approvalWorkItem.setAction(curRequest.action);
            approvalWorkItem.setNextApproverIds(curRequest.nextApproverIds);
            approvalWorkItem.setWorkitemId(curRequest.approvalRequestId);
            
            // Submit the request for approval
            Approval.ProcessResult approvalResult =  Approval.process(approvalWorkItem);

            
            // Verify the results
            System.assert(approvalResult.isSuccess(), 'Result Status:'+ approvalResult.isSuccess());
            
            System.assertEquals(
                'Approved', approvalResult.getInstanceStatus(), 
                'Instance Status'+approvalResult.getInstanceStatus());
            

            response.isSuccess = approvalResult.isSuccess();
            Database.Error[] errors = approvalResult.getErrors();
            response.errorString = getErrorInfo(errors); //warning. only hacking out the first error
            response.currentApprovalProcessStatus = approvalResult.getInstanceStatus();

            //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
            responseWrapper.add(response);
        }
        return responseWrapper;

    }

    public static String getErrorInfo(Database.Error[] errors) {
        String errorStrings = '';
        if (errors != null) {
            for(Database.Error error : errors) {
                errorStrings = errorStrings + ' ' + error.getMessage();
            }
        }
        return errorStrings;
    }

     

    public class InvocableErrorException extends Exception {
    }


    public class Requests {

        @InvocableVariable
        public String approvalRequestId;

        @InvocableVariable
        public String comments;

        @InvocableVariable
        public String action; // 'Approved', 'Rejected'. 'Removed' https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ProcessWorkitemRequest.htm#apex_Approval_ProcessWorkitemRequest_setAction 
    
        @InvocableVariable
        public List<String> nextApproverIds;
    }

    public class Results {

        @InvocableVariable
        public Boolean isSuccess;

        @InvocableVariable
        public String errorString;

        @InvocableVariable
        public String currentApprovalProcessStatus;  //Approved, Rejected, Removed or Pending.

    }
}
