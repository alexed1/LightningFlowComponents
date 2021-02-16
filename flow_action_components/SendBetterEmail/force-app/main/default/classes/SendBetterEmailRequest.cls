/**
 * @description       : SendBetterEmailRequest definition for flow parameters
 * @author            : Alex Edelstein - etal
 * @license           
 * @group             : 
 * @last modified on  : 02-16-2021
 * @last modified by  : Jack D. Pond
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 * Modifications Log 
 * Ver		Date		Author				Modification
 * 2.00.02	10-12-2020	Mohith Shrivastava	Separated from sendBetterEmail (code refactoring)
 * 2.00.02	10-12-2020	Jack D. Pond		Reverted names for backward compatibility
 * 2.00.05	02-12-2021	Jack D. Pond		setTreatTargetObjectAsRecipient Fix: #586,ReplyEmail with SendBetterEmail #595
**/
public inherited sharing class SendBetterEmailRequest {

	public String[] toAddresses; 
	public String[] ccAddresses; 
	public String[] bccAddresses;
	public Boolean setSaveAsActivity;
	public Boolean setSaveAsTask;
	public Integer index; // This is internal Id for the requests and will be in sequence

	@invocableVariable(label='bcc' description='Indicates whether the email sender receives a copy of the email that is sent. For a mass mail, the sender is only copied on the first email sent.')
	@AuraEnabled
	public Boolean bcc;

	@invocableVariable
	@AuraEnabled
	public List<ContentDocumentLink> contentDocumentAttachments;

	@invocableVariable(label='description' description='The description of the email used in results notification.')
	@AuraEnabled
	public String description;

	@invocableVariable(label='emailMessageType' description='\'singleEmail\'(default) or \'massEmail\'.  MassEmailMessage can send mails related to multiple records (WhatId and TargetObjectId), but is severely limited for other configuration purposes.')
	@AuraEnabled
	public String emailMessageType;

	@invocableVariable
	@AuraEnabled
	public String HTMLbody;

	@invocableVariable(label='MessageId List of existing email if this is InReplyTo' description='Use the MessageId of an existing email to add this message to that email thread')
	@AuraEnabled
	public List<String> InReplyTo;

	@invocableVariable
	@AuraEnabled
	public String orgWideEmailAddressId;

	@invocableVariable
	@AuraEnabled
	public String plainTextBody;
	
	@invocableVariable(label='Related Record ID(whatId/recordId)' description='If you specify a contact for the targetObjectId field, you can specify an optional whatId as well. This helps to further ensure that merge fields in the template contain the correct data. This is used for merge fields and for associating activities and attachments.')
	@AuraEnabled
	public String recordId;

	@invocableVariable
	@AuraEnabled
	public String replyEmailAddress;
	
	@invocableVariable
	@AuraEnabled
	public String senderDisplayName;

	@invocableVariable
	@AuraEnabled
	public String SendTOthisOneEmailAddress;

	@invocableVariable
	@AuraEnabled
	public List<String> SendTOthisStringCollectionOfEmailAddresses;

	@invocableVariable
	@AuraEnabled
	public List<Contact> SendTOtheEmailAddressesFromThisCollectionOfContacts;

	@invocableVariable
	@AuraEnabled
	public List<User> SendTOtheEmailAddressesFromThisCollectionOfUsers;
	
	@invocableVariable
	@AuraEnabled
	public List<Lead> SendTOtheEmailAddressesFromThisCollectionOfLeads;

	@invocableVariable
	@AuraEnabled
	public String SendCCthisOneEmailAddress;

	@invocableVariable
	@AuraEnabled
	public List<String> SendCCthisStringCollectionOfEmailAddresses;

	@invocableVariable
	@AuraEnabled
	public List<Contact> SendCCtheEmailAddressesFromThisCollectionOfContacts;

	@invocableVariable
	@AuraEnabled
	public List<User> SendCCtheEmailAddressesFromThisCollectionOfUsers;
	
	@invocableVariable
	@AuraEnabled
	public List<Lead> SendCCtheEmailAddressesFromThisCollectionOfLeads;

	@invocableVariable
	@AuraEnabled
	public String SendBCCthisOneEmailAddress;

	@invocableVariable
	@AuraEnabled
	public List<String> SendBCCthisStringCollectionOfEmailAddresses;

	@invocableVariable
	@AuraEnabled
	public List<Contact> SendBCCtheEmailAddressesFromThisCollectionOfContacts;

	@invocableVariable
	@AuraEnabled
	public List<User> SendBCCtheEmailAddressesFromThisCollectionOfUsers;
	
	@invocableVariable
	@AuraEnabled
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
	@AuraEnabled
	public Boolean saveAsActivity;

	@invocableVariable(description='Defaults to True unless recordId/whatId is null')
	@AuraEnabled
	public Boolean saveAsTask;

	@invocableVariable(description='Treat the target as a recipient. Defaults to True')
	@AuraEnabled
	public Boolean setTreatTargetObjectAsRecipient;

	@invocableVariable(description='!(Treat the target as a recipient).')
	@AuraEnabled
	public String cb_setTreatTargetObjectAsRecipient;

 	@invocableVariable
	@AuraEnabled
	public String subject;
	
	@invocableVariable(label='targetObjectIds' description='A list of IDs of the contacts, leads, or users to which the email will be sent. The IDs you specify set the context and ensure that merge fields in the template contain the correct data. The objects must be of the same type (all contacts, all leads, or all users)')
	@AuraEnabled
	public List<String> targetObjectIds;
	
	@invocableVariable(label='templateID' )
	@AuraEnabled
	public String templateID;
	
	@invocableVariable(label='Template Language' description='Used in conjunction with Template Name, Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.  Template Selection criteria order first found Name with: 1)If empty, Org LanguageLocaleKey 2)Language found in Description 3)First without \'Language="\'')
	@AuraEnabled
	public String templateLanguage;
	
	@invocableVariable(label='Template Name' description='Used in conjunction with Template Language. Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.')
	@AuraEnabled
	public String templateName;
	
	@invocableVariable(label='Template Target Record Id' description='If you are passing in a template Id, you need to also pass in the Id of context record. It can be a Contact, Lead, or User. It will determine which data gets merged into the template')
	@AuraEnabled
	public String templateTargetObjectId;

	@invocableVariable(label='UseSalesforceSignature' description='True unless otherwise specified')
	@AuraEnabled
	public Boolean UseSalesforceSignature;

	@invocableVariable(label='whatIds' description='For MassEmail, if you specify a list of contacts for the targetObjectIds field, you can specify a list of whatIds as well. This helps to further ensure that merge fields in the template contain the correct data.')
	@AuraEnabled
	public List<String> whatIds;
}