/**
 * @File Name			: SendHTMLEmail.cls
 * @Description			: Uses Spring/Summer '20 EmailTemplate Object + ContentVersion with multi-lingual
 * @Author				: Jack D. Pond
 * @Group				: unofficialSF
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 08-02-2020
 * @Modification Log	:
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 *
 * Ver		Date		Author					Modification
 * 1.32		2/5/2020	Jack Pond				Modified for multi-lingual and to throw InvocableActionException on exceptions
 * 1.32		2/11/2020	Alex Edelstein			Bulkified and Changed recordId to String
 * 1.33		3/22/2020	Jack Pond				Added consistency checks, modified Labels and alphabetized params
 * 1.33.1	4/11/2020	Jack Pond				Issues 308,316
 * 1.33.2	5/29/2020	Jack Pond				Version 1.33.2 upgrade - Issues #320,#351,#354, #355, #392
 * 1.33.2	6/02/2020	Jack Pond				Finalized MassEmail and added Tests and Issue #378
 * 1.33.3   08/08/2020  Mohith Shrivastava      Bulkified all queries, DML and has better error handling
 *
 * Done:
 * #320 sendHTMLEmail - Activity History Redesign?
 * #351 sendHTMLEmail - Address bulkification consistent with Apex Gov Limits
 * #354 sendHTMLEmail - Limit Class test to 2 OrgWideEmailAddresses
 * #355 sendHTMLEmail - Separate Email Activity from Email Task Activity
 * #378 sendHTMLEmail - Allow selection of email template by name as well as by templateId
 * #392 sendHTMLEmail - Return the Activity TaskId added
 *
 * To do:
 * #342 sendHTMLEmail CPE For Summer '20 Release
 **/

public without sharing class SendHTMLEmail {
    //	@invocableMethod(label='Send HTML Email')
    @invocableMethod(
        label='Send HTML Email'
        configurationEditor='c:sendHTMLEmailCPE'
    )
    public static List<Response> SendEmail(List<Request> requests) {
        // Final Response to return to user
        List<Response> outputResponseList = new List<Response>();

        // This has valid email requests to send
        List<Request> validRequestsToSendEmail = new List<Request>();

        // This holds Messaging.SingleEmailMessage or Messaging.MassEmailMessage to send Email
        List<Messaging.Email> emailList = new List<Messaging.Email>();

        // List of Tasks to Insert
        List<Task> lstTasks = new List<Task>();

        // Set for template Names and content document Ids
        Set<String> templateNames = new Set<String>();
        Set<Id> contentDocumentIds = new Set<Id>();

        // Map for emailTemplate
        Map<String, List<EmailTemplate>> mapTemplateNameByEmailTemplates = new Map<String, List<EmailTemplate>>();
        Map<Id, EmailTemplate> mapIdByEmailTemplate = new Map<Id, EmailTemplate>();
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion = new Map<Id, List<ContentVersion>>();

        // Email Results List
        List<Messaging.SendEmailResult> emailResults = new List<Messaging.SendEmailResult>();

        // Target objectIds List
        List<String> listTargetObjectIds = new List<String>();

        // Map of recordId via Email
        Map<String, String> mapRecordIdByEmail = new Map<String, String>();

        // Cache the local language key for the organization
        String localeKey = [SELECT LanguageLocaleKey FROM Organization LIMIT 1]
        .LanguageLocaleKey;

        // Collect all inputs for SOQL
        for (Request curRequest : requests) {
            if (curRequest.templateName != null) {
                templateNames.add(curRequest.templateName);
            }
            // Collect ContentDocument Link
            if (curRequest.contentDocumentAttachments != null) {
                for (
                    ContentDocumentLink contentLink : curRequest.contentDocumentAttachments
                ) {
                    contentDocumentIds.add(contentLink.ContentDocumentId);
                }
            }
            // Cache all Target Object Ids in
            if (curRequest.emailMessageType == 'MassEmailMessage') {
                if (curRequest.targetObjectIds.size() > 0) {
                    listTargetObjectIds.addAll(curRequest.targetObjectIds);
                }
            } else {
                if (curRequest.templateTargetObjectId != null) {
                    listTargetObjectIds.add(curRequest.templateTargetObjectId);
                }
            }
        }

        // Cache Query results for Templates
        mapTemplateNameByEmailTemplates = getMapTemplateNameByEmailTemplates(
            templateNames,
            mapIdByEmailTemplate
        );

        // Cache Query results for ContentDocument Ids
        mapContentDocumentIdByContentVersion = getMapContentDocumentIdByContentVersions(
            contentDocumentIds
        );

        // Cache a Map of targetObjectIds(Contact, Lead, User or other Custom Objects)
        mapRecordIdByEmail = getMapRecordIdByEmail(listTargetObjectIds);

        for (Request curRequest : requests) {
            // output Response
            Response thisResponse = new Response();

            String HTMLbody = curRequest.HTMLbody;
            String orgWideEmailAddressId = curRequest.orgWideEmailAddressId;
            String plainTextBody = curRequest.plainTextBody;
            String recordId = curRequest.recordId;
            String replyEmailAddress = curRequest.replyEmailAddress;
            String senderDisplayName = curRequest.senderDisplayName;
            String subject = curRequest.subject;
            String templateId = curRequest.templateId;
            String templateName = curRequest.templateName;
            String templateLanguage = curRequest.templateLanguage;
            String templateTargetObjectId = curRequest.templateTargetObjectId;

            String emailMessageType = curRequest.emailMessageType == null
                ? 'singleEmail'
                : curRequest.emailMessageType;

            Boolean useSalesforceSignature = curRequest.useSalesforceSignature ==
                null
                ? true
                : curRequest.useSalesforceSignature;

            Boolean bcc = curRequest.bcc == null ? false : curRequest.bcc; // default to false

            if (subject != null && (subject.length() == 0)) {
                subject = null;
            }

            curRequest.setSaveAsActivity = curRequest.saveAsActivity == null
                ? true
                : curRequest.saveAsActivity;

            if (recordId == null) {
                curRequest.setSaveAsActivity = curRequest.saveAsActivity == null
                    ? false
                    : curRequest.setSaveAsActivity;
            }
            // saveAsTask will default to whatever saveAsActivity is, but if recordId is null, will set it to false
            curRequest.setSaveAsTask = curRequest.saveAsTask == null
                ? curRequest.setSaveAsActivity
                : curRequest.saveAsTask;

            if (recordId == null) {
                curRequest.setSaveAsTask = curRequest.setSaveAsTask == null
                    ? false
                    : curRequest.setSaveAsTask;
            }
            //from https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm

            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            //Messaging.reserveSingleEmailCapacity(2);
            // These methods available to all email message classes through the base Messaging.Email Base Class

            //setBccSender(bcc)
            //setReplyTo(replyAddress)
            //settemplateId(templateId)
            //setSaveAsActivity(saveAsActivity)
            //setSenderDisplayName(displayName)
            //setUseSignature(useSignature)

            //and through association:

            //SaveAsTask
            //Mass Email Segment
            if (emailMessageType == 'massEmail') {
                //	setBccSender(bcc)
                //	setDescription(description)
                //	setReplyTo(replyAddress)
                //	setSaveAsActivity(saveAsActivity)
                //	setSenderDisplayName(displayName)
                //	setTargetObjectIds(targetObjectIds)
                //	settemplateId(templateId)
                //	setUseSignature(useSignature)
                //	setWhatIds(whatIds)
                Messaging.MassEmailMessage mmail = new Messaging.MassEmailMessage();
                // Set to True if you want to BCC yourself on the email.
                mmail.setBccSender(bcc);
                //	setDescription(description)
                if (
                    curRequest.description == null ||
                    curRequest.description.length() == 0
                ) {
                    thisResponse.errors = 'You must specify a description for mass email message collections.';
                } else {
                    mmail.description = curRequest.description;
                }
                //	setReplyTo(replyAddress)
                if (thisResponse.errors == null) {
                    mmail.setReplyTo(replyEmailAddress);
                }
                //	setSaveAsActivity(saveAsActivity)
                if (curRequest.setSaveAsActivity != null) {
                    mmail.setSaveAsActivity(curRequest.setSaveAsActivity);
                }
                //	setSenderDisplayName(displayName)
                if (thisResponse.errors == null) {
                    mmail.setSenderDisplayName(senderDisplayName);
                }
                //	setTargetObjectIds(targetObjectIds)
                if (thisResponse.errors == null) {
                    if (
                        curRequest.targetObjectIds == null ||
                        curRequest.targetObjectIds.size() == 0
                    ) {
                        thisResponse.errors = 'You must specify a collection of targetObjectIds - required parameter for mass emails.';
                    } else {
                        mmail.setTargetObjectIds(curRequest.targetObjectIds);
                        if (
                            curRequest.whatIds != null &&
                            curRequest.whatIds.size() > 0
                        ) {
                            if (
                                curRequest.whatIds.size() ==
                                curRequest.targetObjectIds.size()
                            ) {
                                try {
                                    mmail.setTargetObjectIds(
                                        curRequest.whatIds
                                    );
                                } catch (Exception e) {
                                    thisResponse.errors = e.getMessage();
                                }
                            } else {
                                thisResponse.errors = 'You must match targetObjectIds one-for-one with whatIds';
                            }
                        }
                    }
                }
                //	settemplateId(templateId)
                if (thisResponse.errors == null) {
                    if (
                        thisResponse.errors == null &&
                        (templateName != null &&
                        templateId != null)
                    ) {
                        thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
                    }
                    if (curRequest.templateId == null) {
                        if (curRequest.templateName == null) {
                            thisResponse.errors = 'You must specify a template name or Template ID - required parameter for mass emails.';
                        } else {
                            templateId = gettemplateIdFromName(
                                templateName,
                                templateLanguage,
                                mapTemplateNameByEmailTemplates,
                                localeKey
                            );
                            if (templateId != null) {
                                mmail.settemplateId(templateId);
                            } else
                                thisResponse.errors = 'An Email template with the specified template name could not be found';
                        }
                    } else {
                        mmail.settemplateId(curRequest.templateId);
                    }
                }
                //	setUseSignature(useSignature)
                if (thisResponse.errors == null) {
                    mmail.setUseSignature(
                        curRequest.useSalesforceSignature == null
                            ? false
                            : curRequest.useSalesforceSignature
                    );
                }
                if (thisResponse.errors == null) {
                    emailList.add(mmail);
                    validRequestsToSendEmail.add(curRequest);
                } else {
                    thisResponse.isSuccess = false;
                    outputResponseList.add(thisResponse);
                }
            } else {
                //Single Email Segment
                // Strings to hold the email addresses to which you are sending the email.
                //String[] toAddresses = new String[] {oneAddress};
                Map<String, Object> m = generateMap(curRequest);
                curRequest.toAddresses = buildAddressList('TO', m);
                curRequest.ccAddresses = buildAddressList('CC', m);
                curRequest.bccAddresses = buildAddressList('BCC', m);
                // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                // Assign the addresses for the To and CC lists to the mail object.
                mail.setToAddresses(curRequest.toAddresses);
                mail.setCcAddresses(curRequest.ccAddresses);
                mail.setBccAddresses(curRequest.bccAddresses);

                //outgoing email can either use an orgWideEmailAddress or specify it here, but not both
                if (
                    orgWideEmailAddressId != null &&
                    orgWideEmailAddressId != ''
                ) {
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
                mail.setBccSender(bcc);

                // Optionally append the salesforce.com email signature to the email.
                // The email address of the user executing the Apex Code will be used.
                // True by default unless the user passes a value in.
                mail.setUseSignature(useSalesforceSignature);
                mail = addAttachments(
                    mail,
                    curRequest.contentDocumentAttachments,
                    mapContentDocumentIdByContentVersion,
                    null
                );

                if (
                    thisResponse.errors == null &&
                    (templateName != null &&
                    templateId != null)
                ) {
                    thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
                }

                if (thisResponse.errors == null && templateName != null) {
                    templateId = gettemplateIdFromName(
                        templateName,
                        templateLanguage,
                        mapTemplateNameByEmailTemplates,
                        localeKey
                    );
                    if (templateId == null) {
                        thisResponse.errors =
                            'Could not find email template named "' +
                            templateName +
                            '".  Please have your administrator check the name and/or accessibility of this template';
                    }
                    thisResponse.templateUsed = templateId;
                    curRequest.templateUsed = templateId;
                }

                if (
                    thisResponse.errors == null &&
                    (templateId != null &&
                    ((HTMLbody != null) || (plainTextBody != null)))
                ) {
                    thisResponse.errors = 'You\'re trying to pass in both a plaintext/html body and a template ID. Gotta pick one or the other. Make sure you\'re not confusing the Text Template resources in Flow, (which you can pass into either the HTMLBody or the plainTextBody) with the templateId, which represents a Salesforce Email Template (either Classic or Lightning).';
                }

                if (
                    thisResponse.errors == null &&
                    (templateId == null &&
                    HTMLbody == null &&
                    plainTextBody == null)
                ) {
                    thisResponse.errors = 'Body text must be provided to Send HTML Email Action, either via HTMLbody, plainTextBody, or a templateId';
                }

                if (
                    thisResponse.errors == null &&
                    (curRequest.setSaveAsTask == true &&
                    recordId == null)
                ) {
                    thisResponse.errors = 'In order to log this email send as a task, you need to pass in a recordId';
                }

                if (templateTargetObjectId != null) {
                    mail.setTargetObjectId(templateTargetObjectId);
                }

                if (recordId != null) {
                    mail.setWhatId(ID.valueOf(recordId));
                }
                // Specify the text content of the email.
                if (plainTextBody != null) {
                    mail.setPlainTextBody(plainTextBody);
                }

                if (HTMLbody != null) {
                    mail.setHtmlBody(HTMLbody);
                }

                if (curRequest.setSaveAsActivity != null) {
                    mail.setSaveAsActivity(curRequest.setSaveAsActivity);
                }

                if (templateId != null) {
                    try {
                        mail.settemplateId(templateId);
                        thisResponse.templateUsed = templateId;
                        curRequest.templateUsed = templateId;
                    } catch (Exception e) {
                        thisResponse.errors = e.getMessage();
                    }
                }

                if (thisResponse.errors == null) {
                    emailList.add(mail);
                    validRequestsToSendEmail.add(curRequest);
                } else {
                    thisResponse.isSuccess = false;
                    outputResponseList.add(thisResponse);
                }
            }
        }

        try {
            emailResults = Messaging.sendEmail(emailList, false);
        } catch (Exception e) {
            // if an error occurred in sendMail, put same error message on all responses
            for (Integer i = 0; i < emailList.size(); i++) {
                Response errorResponse = new Response();
                errorResponse.isSuccess = false;
                errorResponse.errors = e.getmessage();
                errorResponse.templateUsed = validRequestsToSendEmail[i]
                    .templateUsed;
                outputResponseList.add(errorResponse);
            }
        }

        if (emailResults.size() > 0) {
            // collect partial error from the Messaging.sendEmail
            for (integer i = 0; i < emailResults.size(); i++) {
                Response systemResponse = new Response();
                if (emailResults[i].isSuccess() == true) {
                    systemResponse.isSuccess = true;
                    systemResponse.recordId = validRequestsToSendEmail[i]
                        .recordId;
                    systemResponse.templateUsed = validRequestsToSendEmail[i]
                        .templateUsed;
                    if (validRequestsToSendEmail[i].setSaveAsTask == true) {
                        // check if this is for Single Email or Mass Email
                        if (
                            validRequestsToSendEmail[i].emailMessageType ==
                            'massEmail'
                        ) {
                            List<String> recipientList = new List<String>();
                            for (
                                String recId : validRequestsToSendEmail[i]
                                    .targetObjectIds
                            ) {
                                if (mapRecordIdByEmail.get(recId) != null) {
                                    recipientList.add(
                                        mapRecordIdByEmail.get(recId)
                                    );
                                }
                            }
                            Task taskRecord = addTask(
                                validRequestsToSendEmail[i].templateId,
                                validRequestsToSendEmail[i].subject,
                                validRequestsToSendEmail[i].recordId,
                                recipientList,
                                mapIdByEmailTemplate
                            );
                            lstTasks.add(taskRecord);
                        } else {
                            // logic for Single Email Task creation
                            List<String> recipientList = validRequestsToSendEmail[
                                    i
                                ]
                                .toAddresses;
                            if (recipientList.size() == 0) {
                                if (
                                    mapRecordIdByEmail.get(
                                        validRequestsToSendEmail[i]
                                            .templateTargetObjectId
                                    ) != null
                                ) {
                                    validRequestsToSendEmail[i]
                                        .toAddresses.add(
                                            mapRecordIdByEmail.get(
                                                validRequestsToSendEmail[i]
                                                    .templateTargetObjectId
                                            )
                                        );
                                }
                            }
                            recipientList.addAll(
                                validRequestsToSendEmail[i].ccAddresses
                            );
                            recipientList.addAll(
                                validRequestsToSendEmail[i].bccAddresses
                            );
                            Task taskRecord = addTask(
                                validRequestsToSendEmail[i].templateId,
                                validRequestsToSendEmail[i].subject,
                                validRequestsToSendEmail[i].recordId,
                                recipientList,
                                mapIdByEmailTemplate
                            );
                            lstTasks.add(taskRecord);
                        }
                    }
                } else {
                    systemResponse.isSuccess = false;
                    systemResponse.errors = getErrorString(
                        emailResults[i].getErrors()
                    );
                }
                outputResponseList.add(systemResponse);
            }
        }

        // Insert Tasks
        List<Database.SaveResult> insertResults = Database.insert(
            lstTasks,
            false
        );

        // Maps to link back the Task insert result
        Map<String, String> mapWhatIdByTaskId = new Map<String, String>();
        Map<String, String> mapWhatIdByError = new Map<String, String>();

        for (integer i = 0; i < insertResults.size(); i++) {
            if (insertResults[i].isSuccess()) {
                mapWhatIdByTaskId.put(
                    lstTasks[i].WhatId,
                    (String) insertResults.get(i).getId()
                );
            } else if (!insertResults[i].isSuccess()) {
                // DML operation failed
                mapWhatIdByError.put(
                    lstTasks[i].WhatId,
                    getDatabaseErrorString(insertResults[i].getErrors())
                );
            }
        }

        // report back the results
        boolean atLeastOneSent = false;
        for (integer i = 0; i < outputResponseList.size(); i++) {
            if (outputResponseList[i].recordId != null) {
                if (
                    mapWhatIdByTaskId.get(outputResponseList[i].recordId) !=
                    null
                ) {
                    outputResponseList[i].taskId = mapWhatIdByTaskId.get(
                        outputResponseList[i].recordId
                    );
                }
                if (
                    mapWhatIdByError.get(outputResponseList[i].recordId) != null
                ) {
                    outputResponseList[i]
                        .taskCreationError = mapWhatIdByError.get(
                        outputResponseList[i].recordId
                    );
                }
            }
            if (outputResponseList[i].isSuccess) {
                atLeastOneSent = true;
            }
        }
        if (!atLeastOneSent) {
            throw new InvocableActionException(
                'No Messages were sent.  First Error: ' +
                outputResponseList[0].errors
            );
        }
        return outputResponseList;
    }

    private static String getDatabaseErrorString(
        List<Database.Error> curErrors
    ) {
        String errorReport;
        for (Database.Error curError : curErrors) {
            errorReport =
                errorReport +
                'Error Code:' +
                curError.getStatusCode() +
                ' - ' +
                curError.getMessage() +
                '\n';
        }
        return errorReport;
    }

    private static String getErrorString(
        List<Messaging.SendEmailError> curErrors
    ) {
        String errorReport;
        for (Messaging.SendEmailError curError : curErrors) {
            errorReport =
                errorReport +
                'Error Code:' +
                curError.getStatusCode() +
                ' - ' +
                curError.getMessage() +
                '\n';
        }
        return errorReport;
    }

    private static Map<String, String> getMapRecordIdByEmail(
        List<String> targetObjectIds
    ) {
        Map<String, String> mapRecordIdByEmail = new Map<String, String>();
        Set<Schema.SObjectType> setSobjectTypes = new Set<Schema.SObjectType>();
        List<Sobject> lstRecords = new List<Sobject>();
        for (String recId : targetObjectIds) {
            if (recId.length() == 15 || recId.length() == 18) {
                setSobjectTypes.add(((Id) recId).getSobjectType());
            }
        }
        // Query is in loop here, however the query is per Object.
        for (Schema.SObjectType objectType : setSobjectTypes) {
            List<Sobject> recipientList = new List<Sobject>();
            recipientList = Database.query(
                'Select Id, Email From ' +
                objectType.getDescribe().getName() +
                ' WHERE Id IN : targetObjectIds'
            );
            lstRecords.addAll(recipientList);
        }

        for (Sobject rec : lstRecords) {
            if (rec.get('Email') != null) {
                mapRecordIdByEmail.put(
                    (String) rec.get('Id'),
                    (String) rec.get('Email')
                );
            }
        }

        return mapRecordIdByEmail;
    }

    // Add a task activity
    private static Task addTask(
        Id templateId,
        String subject,
        Id recordId,
        List<String> recipientList,
        Map<Id, EmailTemplate> mapIdByEmailTemplate
    ) {
        // Capture activities to insert
        if (
            templateId != null &&
            subject == null &&
            mapIdByEmailTemplate.get(templateId) != null
        ) {
            subject = mapIdByEmailTemplate.get(templateId).subject;
        }
        return createTask(recordId, subject, recipientList);
    }

    //credit to https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
    public static Messaging.SingleEmailMessage addAttachments(
        Messaging.SingleEmailMessage mail,
        List<ContentDocumentLink> contentDocumentLinks,
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion,
        String staticResourceNames
    ) {
        List<SObject> curAttachments = new List<SObject>();

        // Comment out the code for now since Static Resource option is disabled for now
        // In future bulkify this query and move out else this will be SOQL inside for loop
        //if (staticResourceNames != null) {
        // List<String> staticResourceNamesList = staticResourceNames.replaceAll('[^A-Z0-9]+//ig', ',').split(',');
        // curAttachments.addAll([SELECT Id, Body, Name, ContentType FROM StaticResource WHERE Name IN:staticResourceNamesList]);
        //}

        if (contentDocumentLinks != null && !contentDocumentLinks.isEmpty()) {
            Set<Id> cdIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                cdIds.add(cdl.ContentDocumentId);
            }
            for (Id contentDocumentId : cdIds) {
                if (
                    mapContentDocumentIdByContentVersion.get(
                        contentDocumentId
                    ) != null &&
                    mapContentDocumentIdByContentVersion.get(contentDocumentId)
                        .size() > 0
                ) {
                    for (
                        ContentVersion cv : mapContentDocumentIdByContentVersion.get(
                            contentDocumentId
                        )
                    ) {
                        curAttachments.add(
                            new StaticResource(
                                Name = cv.PathOnClient,
                                Body = cv.VersionData
                            )
                        );
                    }
                }
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

    public static String[] buildAddressList(
        string type,
        Map<String, Object> m
    ) {
        String[] addressList = new List<String>();
        String curEmail;

        //build address list
        //handle individual addresses
        String oneAddress = (String) m.get(
            'Send' +
            type +
            'thisOneEmailAddress'
        );
        if (oneAddress != null) {
            addressList.add(oneAddress);
        }

        //handle inputs involving collections of String addresses
        List<String> stringAddresses = (List<String>) m.get(
            'Send' +
            type +
            'thisStringCollectionOfEmailAddresses'
        );
        if (stringAddresses != null) {
            addressList.addAll(stringAddresses);
        }
        //handle inputs involving collections of Contacts
        List<Contact> curContacts = (List<Contact>) m.get(
            'Send' +
            type +
            'theEmailAddressesFromThisCollectionOfContacts'
        );
        if (curContacts != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (Contact curContact : curContacts) {
                curEmail = curContact.email;
                if (curEmail != null)
                    extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }

        //handle inputs involving collections of Users
        List<User> curUsers = (List<User>) m.get(
            'Send' +
            type +
            'theEmailAddressesFromThisCollectionOfUsers'
        );
        if (curUsers != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (User curUser : curUsers) {
                curEmail = curUser.email;
                if (curEmail != null)
                    extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }

        //handle inputs involving collections of Leads
        List<Lead> curLeads = (List<Lead>) m.get(
            'Send' +
            type +
            'theEmailAddressesFromThisCollectionOfLeads'
        );
        if (curLeads != null) {
            List<String> extractedEmailAddresses = new List<String>();
            for (Lead curLead : curLeads) {
                curEmail = curLead.email;
                if (curEmail != null)
                    extractedEmailAddresses.add(curEmail);
            }
            addressList.addAll(extractedEmailAddresses);
        }
        return addressList;
    }

    //this map makes it easier to efficiently use the same code to handle To, CC, and BCC.
    //by making the lookup a string, we can composite the string in the m.get lines above
    private static Map<String, Object> generateMap(Request request) {
        return new Map<String, Object>{
            'SendTOthisOneEmailAddress' => request.SendTOthisOneEmailAddress,
            'SendTOthisStringCollectionOfEmailAddresses' => request.SendTOthisStringCollectionOfEmailAddresses,
            'SendTOtheEmailAddressesFromThisCollectionOfContacts' => request.SendTOtheEmailAddressesFromThisCollectionOfContacts,
            'SendTOtheEmailAddressesFromThisCollectionOfUsers' => request.SendTOtheEmailAddressesFromThisCollectionOfUsers,
            'SendTOtheEmailAddressesFromThisCollectionOfLeads' => request.SendTOtheEmailAddressesFromThisCollectionOfLeads,
            'SendCCthisOneEmailAddress' => request.SendCCthisOneEmailAddress,
            'SendCCthisStringCollectionOfEmailAddresses' => request.SendCCthisStringCollectionOfEmailAddresses,
            'SendCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendCCtheEmailAddressesFromThisCollectionOfContacts,
            'SendCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendCCtheEmailAddressesFromThisCollectionOfUsers,
            'SendCCtheEmailAddressesFromThisCollectionOfLeads' => request.SendCCtheEmailAddressesFromThisCollectionOfLeads,
            'SendBCCthisOneEmailAddress' => request.SendBCCthisOneEmailAddress,
            'SendBCCthisStringCollectionOfEmailAddresses' => request.SendBCCthisStringCollectionOfEmailAddresses,
            'SendBCCtheEmailAddressesFromThisCollectionOfContacts' => request.SendBCCtheEmailAddressesFromThisCollectionOfContacts,
            'SendBCCtheEmailAddressesFromThisCollectionOfUsers' => request.SendBCCtheEmailAddressesFromThisCollectionOfUsers,
            'SendBCCtheEmailAddressesFromThisCollectionOfLeads' => request.SendBCCtheEmailAddressesFromThisCollectionOfLeads
        };
    }

    private static Task createTask(
        Id recordId,
        String subject,
        List<String> recipientList
    ) {
        String recipientListString = string.join(recipientList, ',');
        Task t = new Task(
            OwnerId = UserInfo.getUserId(),
            Subject = 'Sent Email: ' + subject,
            Description = 'Sent Email : ' +
                subject +
                ' to recipient(s): ' +
                recipientListString.replaceAll('[()]|,\\(\\)+', ''),
            Status = 'Closed',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            WhatId = recordId
        );
        return t;
    }

    // Creates Map with template Name and list of all Email Templates with different languages
    private static Map<String, List<EmailTemplate>> getMapTemplateNameByEmailTemplates(
        Set<String> templateNames,
        Map<Id, EmailTemplate> mapIdByEmailTemplate
    ) {
        Map<String, List<EmailTemplate>> mapTemplateNameByEmailTemplates = new Map<String, List<EmailTemplate>>();
        for (EmailTemplate et : [
            SELECT Id, Description, Name
            FROM EmailTemplate
            WHERE Name IN :templateNames AND isActive = TRUE
        ]) {
            if (!mapTemplateNameByEmailTemplates.containsKey(et.Name)) {
                mapTemplateNameByEmailTemplates.put(
                    et.Name,
                    new List<EmailTemplate>{ et }
                );
            } else {
                mapTemplateNameByEmailTemplates.get(et.Name).add(et);
            }
            mapIdByEmailTemplate.put(et.Id, et);
        }
        return mapTemplateNameByEmailTemplates;
    }

    private static Map<Id, List<ContentVersion>> getMapContentDocumentIdByContentVersions(
        Set<Id> contentDocumentIds
    ) {
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion = new Map<Id, List<ContentVersion>>();
        for (ContentVersion cv : [
            SELECT Id, PathOnClient, VersionData, FileType, ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocumentIds
        ]) {
            if (
                !mapContentDocumentIdByContentVersion.containsKey(
                    cv.ContentDocumentId
                )
            ) {
                mapContentDocumentIdByContentVersion.put(
                    cv.ContentDocumentId,
                    new List<ContentVersion>{ cv }
                );
            } else {
                mapContentDocumentIdByContentVersion.get(cv.ContentDocumentId)
                    .add(cv);
            }
        }
        return mapContentDocumentIdByContentVersion;
    }

    private static String gettemplateIdFromName(
        String templateName,
        String templateLanguage,
        Map<String, List<EmailTemplate>> mapTemplateNameByEmailTemplates,
        String localKey
    ) {
        String rettemplateId;
        String blankTemplate;
        if (
            mapTemplateNameByEmailTemplates.get(templateName) != null &&
            mapTemplateNameByEmailTemplates.get(templateName).size() > 0
        ) {
            if (templateLanguage == null) {
                templateLanguage = localKey;
            }
            for (
                EmailTemplate thisTemplate : mapTemplateNameByEmailTemplates.get(
                    templateName
                )
            ) {
                if (thisTemplate.Description.contains('Language="')) {
                    if (
                        thisTemplate.Description.substringAfter('Language="')
                            .substringBefore('"') == templateLanguage
                    ) {
                        rettemplateId = thisTemplate.Id;
                        break;
                    }
                } else {
                    blankTemplate = (blankTemplate == null)
                        ? thisTemplate.Id
                        : blankTemplate;
                }
            }
        }
        return (rettemplateId == null) ? blankTemplate : rettemplateId;
    }

    private class TaskAttached {
        private String errorMsg;
        private String taskId;
    }

    public class Request {
        public String[] toAddresses;
        public String[] ccAddresses;
        public String[] bccAddresses;
        public Boolean setSaveAsActivity;
        public Boolean setSaveAsTask;
        public ID templateUsed;

        @invocableVariable(
            label='bcc'
            description='Indicates whether the email sender receives a copy of the email that is sent. For a mass mail, the sender is only copied on the first email sent.'
        )
        public Boolean bcc;

        @invocableVariable
        public List<ContentDocumentLink> contentDocumentAttachments;

        @invocableVariable(
            label='description'
            description='The description of the email used in results notification.'
        )
        public String description;

        @invocableVariable(
            label='emailMessageType'
            description='\'singleEmail\'(default) or \'massEmail\'.  MassEmailMessage can send mails related to multiple records (WhatId and TargetObjectId), but is severely limited for other configuration purposes.'
        )
        public String emailMessageType;

        @invocableVariable
        public String HTMLbody;

        @invocableVariable
        public String orgWideEmailAddressId;

        @invocableVariable
        public String plainTextBody;

        @invocableVariable(
            label='Related Record ID(whatId/recordId)'
            description='If you specify a contact for the targetObjectId field, you can specify an optional whatId as well. This helps to further ensure that merge fields in the template contain the correct data. This is used for merge fields and for associating activities and attachments.'
        )
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

        @invocableVariable(description='Defaults to True')
        public Boolean saveAsActivity;

        @invocableVariable(
            description='Defaults to True unless recordId/whatId is null'
        )
        public Boolean saveAsTask;

        @invocableVariable
        public String subject;

        @invocableVariable(
            label='targetObjectIds'
            description='A list of IDs of the contacts, leads, or users to which the email will be sent. The IDs you specify set the context and ensure that merge fields in the template contain the correct data. The objects must be of the same type (all contacts, all leads, or all users)'
        )
        public List<String> targetObjectIds;

        @invocableVariable(label='templateId')
        public String templateId;

        @invocableVariable(
            label='Template Language'
            description='Used in conjunction with Template Name, Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.  Template Selection criteria order first found Name with: 1)If empty, Org LanguageLocaleKey 2)Language found in Description 3)First without \'Language="\''
        )
        public String templateLanguage;

        @invocableVariable(
            label='Template Name'
            description='Used in conjunction with Template Language. Finds templates with the name matching Template Name for \'Language="xxx_YY"\' in the Description.'
        )
        public String templateName;

        @invocableVariable(
            label='Template Target Record Id'
            description='If you are passing in a template Id, you need to also pass in the Id of context record. It can be a Contact, Lead, or User. It will determine which data gets merged into the template'
        )
        public String templateTargetObjectId;

        @invocableVariable(
            label='UseSalesforceSignature'
            description='True unless otherwise specified'
        )
        public Boolean UseSalesforceSignature;

        @invocableVariable(
            label='whatIds'
            description='For MassEmail, if you specify a list of contacts for the targetObjectIds field, you can specify a list of whatIds as well. This helps to further ensure that merge fields in the template contain the correct data.'
        )
        public List<String> whatIds;
    }

    public class Response {
        @invocableVariable
        public Boolean isSuccess;

        @invocableVariable
        public String templateUsed;

        @invocableVariable
        public String taskId;

        @invocableVariable
        public String errors;

        @invocableVariable
        public String taskCreationError;

        @invocableVariable
        public String recordId;
    }

    public class InvocableActionException extends Exception {
    }
}
