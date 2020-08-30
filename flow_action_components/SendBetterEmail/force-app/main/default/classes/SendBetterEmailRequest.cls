public inherited sharing class SendBetterEmailRequest {

    public String[] toAddresses; 
    public String[] ccAddresses; 
    public String[] bccAddresses;
    public Boolean setSaveAsActivity;
    public Boolean setSaveAsTask;
    public Integer index; // This is internal Id for the requests and will be in sequence

    @invocableVariable(label='bcc' description='Indicates whether the email sender receives a copy of the email that is sent. For a mass mail, the sender is only copied on the first email sent.')
    public Boolean bcc;

    @invocableVariable
    public List<ContentDocumentLink> contentDocumentAttachments;

    @invocableVariable(label='description' description='The description of the email used in results notification.')
    public String description;

    @invocableVariable(label='emailMessageType' description='\'singleEmail\'(default) or \'massEmail\'.  MassEmailMessage can send mails related to multiple records (WhatId and TargetObjectId), but is severely limited for other configuration purposes.')
    public String emailMessageType;

    @invocableVariable
    public String HTMLbody;

    @invocableVariable
    public String orgWideEmailAddressId;

    @invocableVariable
    public String plainTextBody;
    
    @invocableVariable(label='Related Record ID(whatId/recordId)' description='If you specify a contact for the targetObjectId field, you can specify an optional whatId as well. This helps to further ensure that merge fields in the template contain the correct data. This is used for merge fields and for associating activities and attachments.')
    public String recordId;

    @invocableVariable
    public String replyEmailAddress;
    
    @invocableVariable
    public String senderDisplayName;

    @invocableVariable
    public String SendTOthisOneEmailAddress;

    @invocableVariable
    public List<String> SendTOthisStringCollectionOfEmailAddresses;

    @invocableVariable
    public List<Contact> SendTOtheEmailAddressesFromThisCollectionOfContacts;

    @invocableVariable
    public List<User> SendTOtheEmailAddressesFromThisCollectionOfUsers;
    
    @invocableVariable
    public List<Lead> SendTOtheEmailAddressesFromThisCollectionOfLeads;

    @invocableVariable
    public String SendCCthisOneEmailAddress;

    @invocableVariable
    public List<String> SendCCthisStringCollectionOfEmailAddresses;

    @invocableVariable
    public List<Contact> SendCCtheEmailAddressesFromThisCollectionOfContacts;

    @invocableVariable
    public List<User> SendCCtheEmailAddressesFromThisCollectionOfUsers;
    
    @invocableVariable
    public List<Lead> SendCCtheEmailAddressesFromThisCollectionOfLeads;

    @invocableVariable
    public String SendBCCthisOneEmailAddress;

    @invocableVariable
    public List<String> SendBCCthisStringCollectionOfEmailAddresses;

    @invocableVariable
    public List<Contact> SendBCCtheEmailAddressesFromThisCollectionOfContacts;

    @invocableVariable
    public List<User> SendBCCtheEmailAddressesFromThisCollectionOfUsers;
    
    @invocableVariable
    public List<Lead> SendBCCtheEmailAddressesFromThisCollectionOfLeads;
    
    /*
        Static resources do not store file extensions, thus email attachments will have file names without extensions,
        which is inconvenient for an end user. Disabling this option for now.
        Possible workarounds:
        1. Specify full file name in Description of static resource
        2. Let the user pass file names together with static resource names
     */
//        @invocableVariable
//        public String staticResourceAttachmentNames;

    @invocableVariable(description='Defaults to True')
    public Boolean saveAsActivity;

    @invocableVariable(description='Defaults to True unless recordId/whatId is null')
    public Boolean saveAsTask;

    @invocableVariable
    public String subject;
    
    @invocableVariable(label='targetObjectIds' description='A list of IDs of the contacts, leads, or users to which the email will be sent. The IDs you specify set the context and ensure that merge fields in the template contain the correct data. The objects must be of the same type (all contacts, all leads, or all users)')
    public List<String> targetObjectIds;
    
    @invocableVariable(label='templateId' )
    public String templateId;
    
    @invocableVariable(label='Template Language' description='Used in conjunction with Template Name, Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.  Template Selection criteria order first found Name with: 1)If empty, Org LanguageLocaleKey 2)Language found in Description 3)First without \'Language="\'')
    public String templateLanguage;
    
    @invocableVariable(label='Template Name' description='Used in conjunction with Template Language. Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.')
    public String templateName;
    
    @invocableVariable(label='Template Target Record Id' description='If you are passing in a template Id, you need to also pass in the Id of context record. It can be a Contact, Lead, or User. It will determine which data gets merged into the template')
    public String templateTargetObjectId;

    @invocableVariable(label='UseSalesforceSignature' description='True unless otherwise specified')
    public Boolean UseSalesforceSignature;

    @invocableVariable(label='whatIds' description='For MassEmail, if you specify a list of contacts for the targetObjectIds field, you can specify a list of whatIds as well. This helps to further ensure that merge fields in the template contain the correct data.')
    public List<String> whatIds;
}

