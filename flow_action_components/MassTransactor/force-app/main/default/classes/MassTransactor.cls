/**
 * @description       : Invocable for doing large batch DML from Flow
 * @author            : Matt Comer, Kyle Kim, Ward Wood, Adam White
 * @group             : 
 * @last modified on  : 
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author                                Modification
 * 1.0   08-06-2020   Matt Comer, Kyle Kim, Ward Wood       Initial Version
 * 1.1   08-20-2020   Adam White                            Added email inputs / send on complete

**/
global with sharing class MassTransactor {
    
    public static Integer MAX_BATCH_SIZE = 2000;
    // If no Batch size is specified from the flow - batch size defaults to DEFAULT_BATCH_SIZE
    public static Integer DEFAULT_BATCH_SIZE = 200;


    //Main Method to acting as an orchestration layer. 
    @InvocableMethod (label='DML Records Asynchronously')
    public static List<InvocableApexAsyncBatchResponse> InvocableApexCreateAsyncController(List<InvocableApexAsyncBatchRequest> RequestList){
        
        // NOTE that this action is currently not bulkified due to the nature of what it does.
        // Creating and submitting multiple independent batch jobs would not properly scale.
        InvocableApexAsyncBatchRequest request = RequestList[0];
        ValidationObject vo = ValidateRequestObject(request);

        InvocableApexAsyncBatchResponse response = new InvocableApexAsyncBatchResponse();
        List<InvocableApexAsyncBatchResponse> result = new List<InvocableApexAsyncBatchResponse>();
        result.add(response);

        if (vo.Validity) {
            Integer batchSize = request.BatchSizeIsNull() ? DEFAULT_BATCH_SIZE : request.BatchSize;
            MassTransactorBatchHelper bh;
            if (request.EmailToAddress != null) {
                SimpleEmailOnFinishAction fa = new SimpleEmailOnFinishAction(request.EmailToAddress,
                                                                                request.EmailSubject,
                                                                                   request.EmailBody);
                bh = new MassTransactorBatchHelper(request.RequestList, 
                                                             request.OperationType,
                                                             fa);
            } else {
                bh = new MassTransactorBatchHelper(request.RequestList, 
                                                             request.OperationType);
            }
            response.jobId = Database.executeBatch(bh, batchSize);
            response.success = true;
        } else {
            response.success = false;
            response.errorMessage = vo.ResponseMessage;
        }
  

        return result;
    }

    //Method & Main controller for Error handling. utlizes two different methods. 
    public static ValidationObject ValidateRequestObject(InvocableApexAsyncBatchRequest RequestPayload){
        ValidationObject MasterValidationObject = new ValidationObject();
        
        ValidatePayloadSize(RequestPayload, MasterValidationObject);
        
        if (MasterValidationObject.Validity == false){
            return MasterValidationObject;
        }
        else{   
            //run another check on items if math is good then we can return it and let the controller do it's magic
            ValidatePayloadItems(RequestPayload, MasterValidationObject);            
            return MasterValidationObject;

        }
    }

    //Method scans the payload and ensure that the items in the batch are okay
    //We need to ensure Deletes are parsed as [{ids}]
    //Everything else [{any fields in there. map it correctly when assigning it though..}]
    public static void ValidatePayloadItems (InvocableApexAsyncBatchRequest RequestPayload, ValidationObject MasterValidationObject){

        
        //Variables to establish Constants ()
        Schema.sObjectType ObjectType = RequestPayload.RequestList.get(0).getSObjectType();

        //Parse out all IDs into a set(de-dup if someone did something silly).
        Set <Id> IDSet = new Set <ID>();
        for(sObject cursor : RequestPayload.RequestList){
            if(cursor.Id != null || cursor.Id != ''){
                IDSet.add(cursor.Id);
            }
        }

        String queryString = 'Select ID from ' +  String.valueOf(ObjectType) + ' where ID in :IDSet';
        
        List <sObject> ValidationList = Database.query(queryString);

        //based on the operation type        
        switch on RequestPayload.OperationType.toUpperCase(){
            //Make sure IDs do not exist.
            when 'CREATE'{       
                if(ValidationList.size() > 0) {
                    MasterValidationObject.Validity = false;
                    MasterValidationObject.ResponseMessage = 'There are IDs that exis. Cannot create records with existing Ids.';
                    MasterValidationObject.ResponseCode = 403;
                }
     
            }
            //update and delete, make sure all Ids Exist. 
            when else {
                if(ValidationList.size() != RequestPayload.RequestList.size()){
                    MasterValidationObject.Validity = false;
                    MasterValidationObject.ResponseMessage = 'There are records in this collection with IDs that do not exist. Cannot execute delete or updates on Ids that do not exist';
                    MasterValidationObject.ResponseCode = 405;
                }
            }
        
        }
        if(MasterValidationObject.Validity != false){
            MasterValidationObject.Validity = true;
            MasterValidationObject.ResponseMessage = 'Valid Payload';
            MasterValidationObject.ResponseCode = 200;
        }
    
    }
    // Method scans the payload, and ensures that the batch size is okay
    public static void ValidatePayloadSize (InvocableApexAsyncBatchRequest RequestPayload, ValidationObject MasterValidationObject){
        if(RequestPayload.RequestList.size() == 0 || RequestPayload.RequestList == null) {
            
            MasterValidationObject.Validity = false;
			MasterValidationObject.ResponseMessage = 'There are no records to process.';
			MasterValidationObject.ResponseCode = 66;
            
        } 
        else {
            //If there is no batchsize set it to the max
            Integer BatchSize = RequestPayload.BatchSize = RequestPayload.BatchSizeIsNull() ? DEFAULT_BATCH_SIZE : RequestPayload.BatchSize;
    
            //check if batch size reaches limit || Check if too many batches || Check if no batches...
            if(BatchSize > MAX_BATCH_SIZE || BatchSize <= 0){
                MasterValidationObject.Validity = false;
                MasterValidationObject.ResponseCode = 401; 
                MasterValidationObject.ResponseMessage = 'Batch size needs to be between 0 and 2000';
            }
            else {
                MasterValidationObject.Validity = true;
                MasterValidationObject.ResponseCode = 200; 
                MasterValidationObject.ResponseMessage = 'Success';
            }
        }
    }

    //Request and Response Objects.
    public class InvocableApexAsyncBatchRequest{
        @InvocableVariable(label='Operation Type' description='CUD operation Create Delete Update' required=true)
        public String OperationType;
    
        @InvocableVariable(label='Records for Input' description='Flexible List to pass objects' required=true)
        public List<sObject> RequestList;

        @InvocableVariable(label='Batch Size' description='Size of Batch for each job' required=false)
        public Integer BatchSize;
        
        @InvocableVariable(label='Finish Notification Email Address' description='A single email address to send the finish email to')
        public String EmailToAddress;

        @InvocableVariable(label='Body of the email' description='What the email will contain upon completion')
        public String EmailBody;

        @InvocableVariable(label='Subject of the email' description='Subject of the email upon completion')
        public String EmailSubject;

        //Boolean to check if this is null or empty.
        public Boolean BatchSizeIsNull(){
            if(this.BatchSize == null || this.BatchSize == 0){
                return true;
            }
            else{
                return false;
            }
        }

    }

    //Response object - not sure if we need this
    public class InvocableApexAsyncBatchResponse {
        @InvocableVariable(label='Submission Results' description='True if the batch was succesfully submitted, false if not')
        public Boolean success;

        @InvocableVariable(label='JobId' description='The jobId of the batch processing the DML')
        public String jobId;

        @InvocableVariable(label='Error message' description='If success is false, the validation error which occured')
        public String errorMessage;
    }

    public class ValidationObject {
        public boolean Validity;
        public String ResponseMessage;
        public Integer ResponseCode;
    }

    public class SimpleEmailOnFinishAction implements MassTransactorBatchHelper.OnFinishAction {
        private String emailTo;
        private String subject;
        private String body;
        public SimpleEmailOnFinishAction(String emailTo, String subject, String body) {
            this.emailTo = emailTo;
            this.subject = subject;
            this.body = body;
        }
        public void onFinish(Id finishedJobId) {
            If(this.emailTo != null && this.subject != null && this.body != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new List<String>();
                toAddresses.add(this.emailTo);
                mail.setToAddresses(toAddresses);
                mail.setSubject(this.subject);
                mail.setPlainTextBody(this.body);
        
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }

}