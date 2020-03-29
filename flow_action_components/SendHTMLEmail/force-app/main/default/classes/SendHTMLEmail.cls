/**
 * @File Name          : SendHTMLEmail.cls
 * @Description        : Uses Spring/Summer '20 EmailTemplate Object + ContentVersion with multi-lingual
 * @Author             : various, including Salesforce, Alex Edelstein, https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
 * @Group              : unofficialSF
 * @Last Modified By   : jack.pond@psitex.com
 * @Last Modified On   : 3/22/2020, 9:08:33 AM
 * @Modification Log   : 
 * @License            : LICENSE found in https://github.com/alexed1/LightningFlowComponents
 * Ver       Date            Author      		    Modification
 * 1.32    2/5/2020   jack.pond@psitex.com      Modified for multi-lingual and to throw InvocableActionException on exceptions
 * 1.32    2/11/2020  alex@edelstein.org        Bulkified and Changed recordId to String
 * 1.33    3/22/2020  jack.pond@psitex.com      Added consistency checks, modified Labels and alphabetized params
**/

public without sharing class SendHTMLEmail {

    @invocableMethod(label='Send HTML Email')
    public static List<Response> SendEmail(List<Request> requests) {

        List<Response> responseList = new List<Response>();
		system.debug('Got here SendEmail');
        for (Request curRequest : requests) {
            Response response = new Response();

            String HTMLbody = curRequest.HTMLbody;
            String orgWideEmailAddressId = curRequest.orgWideEmailAddressId;
            String plainTextBody = curRequest.plainTextBody;
            String recordId = curRequest.recordId;
            String replyEmailAddress = curRequest.replyEmailAddress;
            String senderDisplayName = curRequest.senderDisplayName;
            String subject = curRequest.subject;
            String templateID = curRequest.templateID;
            String templateName = curRequest.templateName;
            String templateLanguage = curRequest.templateLanguage;
            String templateTargetObjectId = curRequest.templateTargetObjectId;
            Boolean useSalesforceSignature = curRequest.useSalesforceSignature == null?true:curRequest.useSalesforceSignature;
            Boolean saveAsActivity = curRequest.saveAsActivity == null?true:curRequest.saveAsActivity;
            if (recordId==null)saveAsActivity = curRequest.saveAsActivity == null?false:curRequest.saveAsActivity;
            if (subject != null && (subject.length() == 0) ) subject = null;
         
            //from https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm

            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            //Messaging.reserveSingleEmailCapacity(2);

            // Processes and actions involved in the Apex transaction occur next,
            // which conclude with sending a single email.

            // Now create a new single email message object
            // that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // Strings to hold the email addresses to which you are sending the email.
            //String[] toAddresses = new String[] {oneAddress}; 
            Map<String, Object> m = GenerateMap(curRequest);
            String[] toAddresses = BuildAddressList('TO',m); 
            String[] ccAddresses = BuildAddressList('CC',m); 
            String[] bccAddresses = BuildAddressList('BCC', m);
                

            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            mail.setBccAddresses(bccAddresses);

            //outgoing email can either use an orgWideEmailAddress or specify it here, but not both
            if (orgWideEmailAddressId != null && orgWideEmailAddressId != '') {
                mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            } else {
                // Specify the address used when the recipients reply to the email. 
                mail.setReplyTo(replyEmailAddress);

                // Specify the name used as the display name.
                mail.setSenderDisplayName(senderDisplayName);
            }

            // Specify the subject line for your email address.
            mail.setSubject(subject);

            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);

            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            // True by default unless the user passes a value in.
            mail.setUseSignature(useSalesforceSignature);
            mail = AddAttachments(mail, curRequest.contentDocumentAttachments, null);
            
            if (templateName != null && templateID != null)
                throw new InvocableActionException('You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).');

            if (templateName != null){
                templateID = getTemplateIdFromName(templateName,templateLanguage);
                if (templateID == null){
                    throw new InvocableActionException('Could not find email template named "'+templateName+'".  Please have your administrator check the name and/or accessibility of this template');
                }
                Response.templateUsed = TemplateId;
            }
            if (templateID != null && ((HTMLbody != null) || (plainTextBody != null)))
                throw new InvocableActionException('You\'re trying to pass in both a plaintext/html body and a template ID. Gotta pick one or the other. Make sure you\'re not confusing the Text Template resources in Flow, (which you can pass into either the HTMLBody or the plainTextBody) with the templateId, which represents a Salesforce Email Template (either Classic or Lightning).');
            
            if (templateID == null  && HTMLbody == null && plainTextBody == null)
                throw new InvocableActionException('Body text must be provided to Send HTML Email Action, either via HTMLbody, plainTextBody, or a templateId');
                
            if (saveAsActivity == true && recordId == null) {
                throw new InvocableActionException('In order to log this email send to activity history, you need to pass in a recordId');
            }
            
            Boolean completed = true;
            String error;
            Messaging.SendEmailResult[] emailResponse;
            if (templateTargetObjectId != NULL) mail.setTargetObjectId(templateTargetObjectId);
            System.debug('recordId is: ' + recordId);
            if (recordId != null) {
                mail.setWhatId(ID.valueOf(recordId));
            }
               
            
            // Specify the text content of the email.
            if (plainTextBody != NULL) mail.setPlainTextBody(plainTextBody);
            if (HTMLbody != NULL) mail.setHtmlBody(HTMLbody);
            if (saveAsActivity != NULL) mail.setSaveAsActivity(saveAsActivity);
            if (templateID != NULL){
                try {
                    mail.setTemplateID(templateID);
                } catch (Exception e){
                    completed = false;
                    error = e.getMessage();
                    throw new InvocableActionException(e.getMessage());
                }
            }
            // Send the email you have created.
            try {

                emailResponse = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                completed = true;
            } catch (Exception e){
                completed = false;
                error = e.getMessage();
                throw new InvocableActionException(e.getMessage());
            }
            //report back the results
            if (completed) {
                if (emailResponse[0].isSuccess() != true) {
                    Messaging.SendEmailError[] curErrors = emailResponse[0].getErrors();
                    String errorReport = '';
                    for(Messaging.SendEmailError curError : curErrors ) {
                        errorReport = errorReport + curError.getMessage() + '/n';
                    }
                    response.errors = errorReport;
                    response.isSuccess = false;
                } else {
                    response.isSuccess = true;
                }
                if (saveAsActivity == true) {
                    try {
                        createActivity(recordId, subject, toAddresses + ',' + ccAddresses + ',' + bccAddresses);
                    } catch (Exception e) {
                        response.errors = e.getMessage();
                        response.isSuccess = false;
                        throw new InvocableActionException(e.getMessage());
                    }
                }
            } else {
                response.errors = error;
                response.isSuccess = false;
            }

        responseList = new List<Response>();
        responseList.add(response);
    }

    
    return responseList;

    }

    //credit to https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
    public static Messaging.SingleEmailMessage AddAttachments(Messaging.SingleEmailMessage mail, List<ContentDocumentLink> contentDocumentLinks, String staticResourceNames) {
        List<SObject> curAttachments = new List<SObject>();
        if (staticResourceNames != null) {
            List<String> staticResourceNamesList = staticResourceNames.replaceAll('[^A-Z0-9]+//ig', ',').split(',');
            curAttachments.addAll([SELECT Id, Body, Name, ContentType FROM StaticResource WHERE Name IN:staticResourceNamesList]);
        }
        if (contentDocumentLinks != null && !contentDocumentLinks.isEmpty()) {
            Set<Id> cdIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                cdIds.add(cdl.ContentDocumentId);
            }

            for (ContentVersion cv : [SELECT Id, PathOnClient, VersionData, FileType FROM ContentVersion WHERE ContentDocumentId IN:cdIds]) {
                curAttachments.add(new StaticResource(Name = cv.PathOnClient, Body = cv.VersionData));
            }
        }
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        if (curAttachments != null) {
            for (SObject file : curAttachments) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName((String) file.get('Name'));
                efa.setBody((BLOB) file.get('Body'));
                efa.setContentType((String) file.get('ContentType'));
                attachments.add(efa);
            }
            mail.setFileAttachments(attachments);
        } 
        return mail;
    }

    public static String[] BuildAddressList(string type, Map<String, Object> m) {
        String[] addressList = new List<String>();
        String curEmail;
        //build address list
        //handle individual addresses
        String oneAddress = (String)m.get('Send' + type + 'thisOneEmailAddress');
        if ( oneAddress != null) {
            addressList.add(oneAddress);
        }
        //handle inputs involving collections of String addresses
        List<String> stringAddresses = (List<String>)m.get('Send' + type + 'thisStringCollectionOfEmailAddresses');
        if (stringAddresses != null) {
            addressList.addAll(stringAddresses);
        }
        //handle inputs involving collections of Contacts
        List<Contact> curContacts = (List<Contact>)m.get('Send' + type + 'theEmailAddressesFromThisCollectionOfContacts');        
        if (curContacts != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (Contact curContact : curContacts) {
                curEmail = curContact.email;
                if (curEmail != null) extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }
        
        //handle inputs involving collections of Users
        List<User> curUsers = (List<User>)m.get('Send' + type + 'theEmailAddressesFromThisCollectionOfUsers');
        if (curUsers != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (User curUser : curUsers) {
                curEmail = curUser.email;
                if (curEmail != null) extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }
        
        //handle inputs involving collections of Leads
        List<Lead> curLeads = (List<Lead>)m.get('Send' + type + 'theEmailAddressesFromThisCollectionOfLeads');
        if (curLeads != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (Lead curLead : curLeads) {
                curEmail = curLead.email;
                if (curEmail != null) extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }
       return addressList;
    }

    //this map makes it easier to efficiently use the same code to handle To, CC, and BCC.
    //by making the lookup a string, we can composite the string in the m.get lines above
    private static Map<String, Object> GenerateMap(Request request) {
       
        return new Map<String, Object>{
           'SendTOthisOneEmailAddress' => request.SendTOthisOneEmailAddress,
           'SendTOthisStringCollectionOfEmailAddresses'  => request.SendTOthisStringCollectionOfEmailAddresses,
           'SendTOtheEmailAddressesFromThisCollectionOfContacts' => request.SendTOtheEmailAddressesFromThisCollectionOfContacts,
           'SendTOtheEmailAddressesFromThisCollectionOfUsers' => request.SendTOtheEmailAddressesFromThisCollectionOfUsers,
           'SendTOtheEmailAddressesFromThisCollectionOfLeads' => request.SendTOtheEmailAddressesFromThisCollectionOfLeads,
           'SendCCthisOneEmailAddress' => request.SendCCthisOneEmailAddress,
           'SendCCthisStringCollectionOfEmailAddresses'  => request.SendCCthisStringCollectionOfEmailAddresses,
           'SendCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendCCtheEmailAddressesFromThisCollectionOfContacts,
           'SendCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendCCtheEmailAddressesFromThisCollectionOfUsers,
           'SendCCtheEmailAddressesFromThisCollectionOfLeads' => request.SendCCtheEmailAddressesFromThisCollectionOfLeads,
           'SendBCCthisOneEmailAddress' => request.SendBCCthisOneEmailAddress,
           'SendBCCthisStringCollectionOfEmailAddresses'  => request.SendBCCthisStringCollectionOfEmailAddresses,
           'SendBCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendBCCtheEmailAddressesFromThisCollectionOfContacts,
           'SendBCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendBCCtheEmailAddressesFromThisCollectionOfUsers,
           'SendBCCtheEmailAddressesFromThisCollectionOfLeads' => request.SendBCCtheEmailAddressesFromThisCollectionOfLeads 
        };
    }

    private static void createActivity(Id recordId, String subject, String recipientList) {
        Task t = new Task(OwnerId = UserInfo.getUserId(),
                Subject = 'Sent Email: ' + subject,
                Description = 'Sent Email : ' + subject + ' to recipient(s): ' + recipientList.replaceAll('[()]|,\\(\\)+', ''),
                Status = 'Closed',
                Priority = 'Normal',
                WhatId = recordId);
        insert t;
    }
    private static String getTemplateIdFromName(String templateName, String templateLanguage){
        String retTemplateId;
        String blankTemplate;
        List<EmailTemplate> et = [SELECT Id,Description FROM EmailTemplate WHERE Name=:templateName AND isActive = TRUE];
        system.debug('TemplateNames: '+ et);
        if (et.size() > 0){
            String localeKey = [Select LanguageLocaleKey From Organization Limit 1].LanguageLocaleKey;
            if (templateLanguage == NULL) templateLanguage = [Select LanguageLocaleKey From Organization limit 1].LanguageLocaleKey;
            for (EmailTemplate thisTemplate: et){
                if (thisTemplate.Description.Contains('Language="')){
                    if (thisTemplate.Description.substringAfter('Language="').substringBefore('"') == templateLanguage){
                        retTemplateID = thisTemplate.Id;
                        break;
                    }
                }else{
                    blankTemplate = (blankTemplate == NULL) ? thisTemplate.Id : blankTemplate;
                }
            }
        }
        return (retTemplateId == NULL)? blankTemplate : retTemplateId;
    }

    public class Request {
        @invocableVariable
        public List<ContentDocumentLink> contentDocumentAttachments;

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

        @invocableVariable(description='Defaults to True unless recordId is null')
        public Boolean saveAsActivity;

        @invocableVariable
        public String subject;
        
        @invocableVariable
        public String templateID;
        
        @invocableVariable(label='Template Name' description='Used in conjunction with Template Language. Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.')
        public String templateName;
        
        @invocableVariable(label='Template Language' description='Used in conjunction with Template Name, Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.  Template Selection criteria order first found Name with: 1)If empty, Org LanguageLocaleKey 2)Language found in Description 3)First without \'Language="\'')
        public String templateLanguage;
        
        @invocableVariable(label='Template Target Record Id' description='If you are passing in a template Id, you need to also pass in the Id of context record. It can be a Contact, Lead, or User. It will determine which data gets merged into the template')
        public String templateTargetObjectId;

        @invocableVariable(description='True unless otherwise specified')
        public Boolean UseSalesforceSignature;
    }

    public class Response {
        @invocableVariable
        public Boolean isSuccess; 
        
        @invocableVariable
        public String templateUsed; 
        
        @invocableVariable
        public String errors;

    }

    public class InvocableActionException extends Exception {}
}