/**
* @author       : Tamar Erlich
* @date         : October 07, 2020
* @description  : Invocable method that given opportunityId and accountId, returns a list of opportunity partners to display on opportunity plan record page
* Note          : This class is called by the Flow.
* *************************************************
*       <runTest>GetOpportunityPartnersActionTest<runTest>
* *************************************************
* @History
* -------
* VERSION | AUTHOR                | DATE               | DESCRIPTION
* 1.0     | Tamar Erlich          | October 07, 2020   | Created
**/
global with sharing class GetOpportunityPartnersAction {

    // Attributes passed in from the Flow
    global class Requests {

        @InvocableVariable(label='OpportunityId' required=true)
        global String opportunityId;
        
        @InvocableVariable(label='AccountId' required=true)
        global String accountId;
    }

    // Attributes passed back to the Flow
    global class Results {

        public Results() {
            
        }
        @InvocableVariable
        global String errors;

        @InvocableVariable
        global String successful;

        @InvocableVariable
        public List<OpportunityPartnersWrapper> outputCollection;

        @InvocableVariable
        public String outputString;
        
    }

    // custom exception class
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod
        global static List <Results> get(List<Requests> requestList) {
            // initialize variables
            Results response = new Results();
            List<Results> responseWrapper = new List<Results>();
            String errors;
            String success = 'true';
            String stringOutput;
            String accountId = requestList[0].accountId;
            String opportunityId = requestList[0].opportunityId;
            List<OpportunityPartner> opportunityPartners = new List<OpportunityPartner>();
            List<OpportunityPartnersWrapper> partners = new List<OpportunityPartnersWrapper>();

// BEGIN APEX ACTION PROCESSING LOGIC
            try {

                if (accountId == null || opportunityId == null){

                    throw new InvocableActionException ('No Account or Opportunity ID');

                }

                if (!accountId.startsWith('001')|| !opportunityId.startsWith('006')){

                    throw new InvocableActionException ('Invalid Account or Opportunity ID');

                }

                if (accountId != null && opportunityId != null){
                   
                opportunityPartners = [SELECT AccountTo.Name, IsPrimary, Role 
                                        FROM OpportunityPartner 
                                        WHERE OpportunityId =: opportunityId and AccountToId !=: accountId];
                
                }

                // populate the Apex defined wrapper type with opportunity partner information
                for (opportunityPartner op : opportunityPartners) {

                    OpportunityPartnersWrapper opw = new OpportunityPartnersWrapper();

                    opw.accountName = op.AccountTo.Name;
                    opw.partnerRole = op.Role;
                    opw.isPrimary = op.IsPrimary;
                    opw.accountLink = '/'+op.AccountToId;

                    partners.add(opw);

                }

                // Convert Record Collection to Serialized String
                stringOutput = JSON.serialize(partners);

            } catch (InvocableActionException e){
                System.debug ('exception occured: ' + e.getMessage());
                
                errors = e.getMessage();
                success = 'false';
            } catch (exception ex){
                System.debug ('exception occured: ' + ex.getMessage());
                
                errors = ex.getMessage();
                success = 'false';
            }
// END APEX ACTION PROCESSING LOGIC

            // Prepare the response to send back to the Flow
            // Set Output Values
            response.errors = errors;
            response.successful = success;
            response.outputCollection = partners;
            response.outputString = stringOutput;
            
            responseWrapper.add(response);
    
            // Return values back to the Flow
            return responseWrapper;

        }



}