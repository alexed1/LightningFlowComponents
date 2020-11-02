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
  // Expose this Action to the Flow
  @InvocableMethod
  global static List<Results> get(List<Requests> requestList) {
    // initialize variables
    Results response = new Results();
    List<Results> responseWrapper = new List<Results>();
    String errors;
    String success = 'true';
    String stringOutput;
    List<OpportunityPartner> opportunityPartners = new List<OpportunityPartner>();
    List<OpportunityPartnersWrapper> opportunityPartnersSet = new List<OpportunityPartnersWrapper>();
    Set<Id> setOppIds = new Set<Id>();
    Set<Id> setAccIDs = new Set<Id>();
    Map<Id, List<OpportunityPartner>> mapOppOppPartners = new Map<Id, List<OpportunityPartner>>();

    // create sets of Ids to use as bind variables in the query
    for (Requests rq : requestList) {
      setOppIds.add(rq.opportunityId);
      setAccIds.add(rq.accountId);
    }

    // query all request opportunities and their partners and create a map with opportunityId as the key and a list of parrtners as the values
    for (Opportunity opp : [
      SELECT
        Id,
        (
          SELECT AccountTo.Name, IsPrimary, Role
          FROM OpportunityPartnersFrom
          WHERE OpportunityId = :setOppIds AND AccountToId != :setAccIds
        )
      FROM Opportunity
    ]) {
      mapOppOppPartners.put(opp.Id, opp.OpportunityPartnersFrom);
    }

    for (Requests curRequest : requestList) {
      String accountId = curRequest.accountId;
      String opportunityId = curRequest.opportunityId;

      try {
        if (accountId == null || opportunityId == null) {
          throw new InvocableActionException(
            'When using the GetOpportunityPartners action, you need to provide BOTH an Account Id AND an Opportunity Id'
          );
        }

        if (!accountId.startsWith('001') || !opportunityId.startsWith('006')) {
          throw new InvocableActionException(
            'Invalid Account or Opportunity ID'
          );
        }
        // get the list of opportunity partners matching the current opportunityId from the map
        if (accountId != null && opportunityId != null) {
          opportunityPartners = mapOppOppPartners.get(opportunityId);
        }

        // populate the Apex defined wrapper type with opportunity partner information
        for (opportunityPartner op : opportunityPartners) {
          OpportunityPartnersWrapper opw = new OpportunityPartnersWrapper();

          opw.accountName = op.AccountTo.Name;
          opw.partnerRole = op.Role;
          opw.isPrimary = op.IsPrimary;
          opw.accountLink = '/' + op.AccountToId;

          opportunityPartnersSet.add(opw);
        }

        // Convert Record Collection to Serialized String
        stringOutput = JSON.serialize(opportunityPartnersSet);
      } catch (InvocableActionException e) {
        System.debug('exception occured: ' + e.getMessage());

        errors = e.getMessage();
        success = 'false - custom exception occured';
      } catch (exception ex) {
        System.debug('exception occured: ' + ex.getMessage());

        errors = ex.getMessage();
        success = 'false - exception occured';
      }

      // Prepare the response to send back to the Flow
      // Set Output Values
      response.errors = errors;
      response.successful = success;
      response.outputCollection = opportunityPartnersSet;
      response.outputString = stringOutput;

      responseWrapper.add(response);
    }

    // Return values back to the Flow
    return responseWrapper;
  }

  // Attributes passed in from the Flow
  global class Requests {
    @InvocableVariable(label='Input the Related OpportunityId' required=true)
    global String opportunityId;

    @InvocableVariable(label='Input the Opportunity\'s AccountId' required=true)
    global String accountId;
  }

  // Attributes passed back to the Flow
  global class Results {
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
  global class InvocableActionException extends Exception {
  }
}
