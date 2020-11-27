/**
* @author       : Tamar Erlich
* @date         : October 07, 2020
* @description  : Wrapper class for opportunity partners
* Note          : This class is called by the GetOpportunityPartnersAction.
* *************************************************
*       <runTest><runTest>
* *************************************************
* @History
* -------
* VERSION | AUTHOR                | DATE               | DESCRIPTION
* 1.0     | Tamar Erlich          | October 07, 2020   | Created
**/
public with sharing class OpportunityPartnersWrapper {

    // @AuraEnabled annotation exposes the methods to Lightning Components and Flows
    @AuraEnabled
    public String accountName;
 
    @AuraEnabled
    public String partnerRole;
 
    @AuraEnabled
    public Boolean isPrimary;

    @AuraEnabled
    public String accountLink;

    // Define the structure of the Apex-Defined Variable
    public OpportunityPartnersWrapper(
            String accountName,
            String partnerRole,
            Boolean isPrimary,
            String accountLink
    ) {
        this.accountName = accountName;
        this.partnerRole = partnerRole;
        this.isPrimary = isPrimary;
        this.accountLink = accountLink;
    }
 
    // Required no-argument constructor
    public OpportunityPartnersWrapper() {}

}