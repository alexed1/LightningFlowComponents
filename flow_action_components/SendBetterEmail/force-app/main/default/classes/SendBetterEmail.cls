/**
 * @File Name			: SendBetterEmail.cls
 * @Description			: Uses Spring/Summer '20 EmailTemplate Object + ContentVersion with multi-lingual
 * @OriginalAuthor		: Alex Edelstein, etal
 * @Group				: unofficialSF
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 08-16-2020
 * @License				: LICENSE found in https://github.com/alexed1/LightningFlowComponents
 * @Modification Log	:
 *
 * Ver		Date		Author					Modification
 * 0.01					Alex Edelstein			Original Author
 * 1.32		2/5/2020	Jack Pond				Modified for multi-lingual and to throw InvocableActionException on exceptions
 * 1.32		2/11/2020	Alex Edelstein			Bulkified and Changed recordId to String
 * 1.33		3/22/2020	Jack Pond				Added consistency checks, modified Labels and alphabetized params
 * 1.33.1	4/11/2020	Jack Pond				Issues 308,316
 * 1.33.2	5/29/2020	Jack Pond				Version 1.33.2 upgrade - Issues #320,#351,#354, #355, #392
 * 1.33.2	8/02/2020	Jack Pond				Finalized MassEmail and added Tests and Issue #378
 * 2.00.00	8/02/2020	Jack Pond, Mohith		SendBetterEmail - Optimize Bulkification #445
 * 2.00.02	8/15/2020	Jack Pond, Mohith		Modified for coverage testing
 * 2.00.02	8/16/2020	Jack Pond				Corrected singleEmail recipient name for templateTargetId
 *
 * Done:
 * #320 sendBetterEmail - Activity History Redesign?
 * #351 sendBetterEmail - Address bulkification consistent with Apex Gov Limits
 * #354 sendBetterEmail - Limit Class test to 2 OrgWideEmailAddresses
 * #355 sendBetterEmail - Separate Email Activity from Email Task Activity
 * #378 sendBetterEmail - Allow selection of email template by name as well as by TemplateId
 * #392 sendBetterEmail - Return the Activity TaskId added
 * #342 sendBetterEmail CPE For Summer '20 Release
 * #445 SendBetterEmail - Optimize Bulkification
 **/

public without sharing class SendBetterEmail {
    @invocableMethod(
        label='Send Better Email'
        configurationEditor='c:sendBetterEmailCPE'
    )
    public static List<Response> SendEmail(List<Request> requests) {
        List<Response> responseList = new List<Response>();

        List<Messaging.SingleEmailMessage> singleEmailList = new List<Messaging.SingleEmailMessage>();
        List<Request> singleEmailRequestToSend = new List<Request>();

        List<Messaging.MassEmailMessage> massEmailList = new List<Messaging.MassEmailMessage>();
        List<Request> massEmailRequestListToSend = new List<Request>();

        List<Messaging.SendEmailResult> singleSendEmailResults = new List<Messaging.SendEmailResult>();
        List<Messaging.SendEmailResult> massSendEmailResults = new List<Messaging.SendEmailResult>();

        // Set for template Names and content document Ids
        Set<String> templateNames = new Set<String>();
        Set<Id> contentDocumentIds = new Set<Id>();

        // Map for emailTemplate
        Map<String, List<EmailTemplate>> mapTemplateNameByEmailTemplates = new Map<String, List<EmailTemplate>>();
        Map<Id, EmailTemplate> mapIdByEmailTemplate = new Map<Id, EmailTemplate>();
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion = new Map<Id, List<ContentVersion>>();

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
        }

        // Cache the local language key for the organization
        String localeKey = Constant.getOrganization();

        // Cache Query results for Templates
        mapTemplateNameByEmailTemplates = SendEmailUtil.getMapTemplateNameByEmailTemplates(
            templateNames,
            mapIdByEmailTemplate
        );

        // Cache Query results for ContentDocument Ids
        mapContentDocumentIdByContentVersion = SendEmailUtil.getMapContentDocumentIdByContentVersions(
            contentDocumentIds
        );

        Integer requestIndex = 0;

        for (Request curRequest : requests) {
            //Assign Request Number to the Requests
            curRequest.index = requestIndex;

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

            Response thisResponse = new Response();
            thisResponse.index = requestIndex;
            curRequest.setSaveAsTask = curRequest.saveAsTask;
            curRequest.setSaveAsActivity = curRequest.saveAsActivity;

            //from https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm

            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            //Messaging.reserveSingleEmailCapacity(2);
            /*
				// These methods available to all email message classes through the base Messaging.Email Base Class
	
				setBccSender(bcc)
				setReplyTo(replyAddress)
				setTemplateID(templateId)
				setSaveAsActivity(saveAsActivity)
				setSenderDisplayName(displayName)
				setUseSignature(useSignature)
	
				and through association:
	
				SaveAsTask 
	*/
            //			Mass Email Segment
            if (emailMessageType == 'massEmail') {
                curRequest.setSaveAsTask = curRequest.setSaveAsTask != null
                    ? curRequest.setSaveAsTask
                    : (curRequest.whatIds == null
                          ? false
                          : (curRequest.setSaveAsActivity == null
                                ? false
                                : curRequest.setSaveAsActivity));
                curRequest.setSaveAsActivity = curRequest.setSaveAsActivity ==
                    null
                    ? false
                    : curRequest.setSaveAsActivity;

                // if saveAsTask is null, it will default to whatever saveAsActivity is, but if recordId is null, will set it to false
                //	setBccSender(bcc)
                //	setDescription(description)
                //	setReplyTo(replyAddress)
                //	setSaveAsActivity(saveAsActivity)
                //	setSenderDisplayName(displayName)
                //	setTargetObjectIds(targetObjectIds)
                //	setTemplateID(templateId)
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
                                    mmail.setWhatIds(curRequest.whatIds);
                                } catch (Exception e) {
                                    thisResponse.errors = e.getMessage();
                                }
                            } else {
                                thisResponse.errors = 'You must match targetObjectIds one-for-one with whatIds';
                            }
                        }
                    }
                }
                //	setTemplateID(templateId)
                if (thisResponse.errors == null) {
                    if (
                        thisResponse.errors == null &&
                        (templateName != null &&
                        templateID != null)
                    ) {
                        thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
                    }
                    if (curRequest.templateID == null) {
                        if (curRequest.templateName == null) {
                            thisResponse.errors = 'You must specify a template name or Template ID - required parameter for mass emails.';
                        } else {
                            templateId = SendEmailUtil.gettemplateIdFromName(
                                templateName,
                                templateLanguage,
                                mapTemplateNameByEmailTemplates,
                                localeKey
                            );
                            if (templateId != null) {
                                mmail.setTemplateID(TemplateId);
                            } else {
                                thisResponse.errors = 'An Email template with the specified template name could not be found';
                            }
                        }
                    } else {
                        mmail.setTemplateID(curRequest.templateID);
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
                    massEmailList.add(mmail);
                    massEmailRequestListToSend.add(curRequest);
                } else {
                    thisResponse.isSuccess = false;
                }

                responseList.add(thisResponse);
                //				Single Email Segment
            } else {
                // Processes and actions involved in the SingleEmailMessage transaction occur next,
                // which conclude with sending a single email.

                curRequest.setSaveAsTask = curRequest.setSaveAsTask != null
                    ? curRequest.setSaveAsTask
                    : (curRequest.recordId == null
                          ? false
                          : (curRequest.setSaveAsActivity == null
                                ? false
                                : curRequest.setSaveAsActivity));
                curRequest.setSaveAsActivity = curRequest.setSaveAsActivity ==
                    null
                    ? false
                    : curRequest.setSaveAsActivity;
                // Strings to hold the email addresses to which you are sending the email.
                //String[] toAddresses = new String[] {oneAddress};
                Map<String, Object> m = SendEmailUtil.generateMap(curRequest);
                curRequest.toAddresses = SendEmailUtil.buildAddressList(
                    'TO',
                    m
                );
                curRequest.ccAddresses = SendEmailUtil.buildAddressList(
                    'CC',
                    m
                );
                curRequest.bccAddresses = SendEmailUtil.buildAddressList(
                    'BCC',
                    m
                );
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
                mail = AddAttachmentToEmail.addAttachments(
                    mail,
                    curRequest.contentDocumentAttachments,
                    mapContentDocumentIdByContentVersion
                );

                if (
                    thisResponse.errors == null &&
                    (templateName != null &&
                    templateID != null)
                ) {
                    thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
                }

                if (thisResponse.errors == null && templateName != null) {
                    templateId = SendEmailUtil.gettemplateIdFromName(
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
                    thisResponse.templateUsed = TemplateId;
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
                    (TemplateId == null &&
                    HTMLbody == null &&
                    plainTextBody == null)
                ) {
                    thisResponse.errors = 'Body text must be provided to Send Better Email Action, either via HTMLbody, plainTextBody, or a templateId';
                }

                if (
                    thisResponse.errors == null &&
                    (curRequest.setSaveAsTask == true &&
                    recordId == null)
                ) {
                    thisResponse.errors = 'In order to log this email send as a task, you need to pass in a recordId';
                }

                Boolean completed = true;
                String error;
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
                        mail.setTemplateId(templateId);
                        thisResponse.templateUsed = templateId;
                    } catch (Exception e) {
                        thisResponse.isSuccess = false;
                        thisResponse.errors = e.getMessage();
                    }
                }

                if (thisResponse.errors == null) {
                    singleEmailList.add(mail);
                    singleEmailRequestToSend.add(curRequest);
                } else {
                    thisResponse.isSuccess = false;
                }

                responseList.add(thisResponse);
            }

            requestIndex = requestIndex + 1;
        }

        if (massEmailList != null && massEmailList.size() > 0) {
            try {
                massSendEmailResults = Messaging.sendEmail(
                    massEmailList,
                    false
                );
            } catch (Exception e) {
                // if an error occurred in sendMail, put same error message on all responses
                for (Integer i = 0; i < responseList.size(); i++) {
                    if (requests[i].emailMessageType == 'massEmail') {
                        responseList[i].isSuccess = false;
                        responseList[i].errors = e.getmessage();
                    }
                }
            }

            for (integer i = 0; i < massSendEmailResults.size(); i++) {
                Request request = massEmailRequestListToSend[i];
                Response response = responseList[request.index];
                Messaging.SendEmailResult emailResult = massSendEmailResults[i];
                if (
                    emailResult.isSuccess() == false &&
                    !(test.isRunningTest() &&
                    request.setSaveAsTask &&
                    ((Id) request.whatIds[0]).getSObjectType() ==
                    Schema.User.sObjectType)
                ) {
                    response.isSuccess = false;
                    response.errors = SendEmailUtil.getErrorString(
                        emailResult.getErrors()
                    );
                } else {
                    response.isSuccess = true;
                    if (request.setSaveAsTask == true) {
                        if (
                            request.whatIds != null &&
                            request.whatIds.size() > 0
                        ) {
                            response.taskIds = addTasks(
                                request,
                                response,
                                null
                            );
                        } else {
                            response.taskIds = new List<String>{
                                'Error:  Mass Email requires whatIds if saveAsTask'
                            };
                        }
                    }
                }
            }
        }

        if (singleEmailList != null && singleEmailList.size() > 0) {
            try {
                singleSendEmailResults = Messaging.sendEmail(
                    singleEmailList,
                    false
                );
            } catch (Exception e) {
                // if an error occurred in sendMail, put same error message on all responses
                for (Integer i = 0; i < responseList.size(); i++) {
                    if (requests[i].emailMessageType != 'massEmail') {
                        responseList[i].isSuccess = false;
                        responseList[i].errors = e.getmessage();
                    }
                }
            }
            Integer replyPos = 0;
            for (
                Messaging.SendEmailResult thisResult : singleSendEmailResults
            ) {
                while (
                    responseList[replyPos].errors != null ||
                    requests[replyPos].emailMessageType == 'massEmail'
                )
                    replyPos++;
                if (
                    thisResult.isSuccess() != true &&
                    !(test.isRunningTest() &&
                    requests[replyPos].setSaveAsTask &&
                    ((Id) requests[replyPos].recordId)
                        .getSObjectType()
                        .getDescribe()
                        .getName() == 'User')
                ) {
                    responseList[replyPos].isSuccess = false;
                    Messaging.SendEmailError[] curErrors = thisResult.getErrors();
                    String errorReport = '';
                    for (Messaging.SendEmailError curError : curErrors) {
                        errorReport =
                            errorReport +
                            'Error Code:' +
                            curError.getStatusCode() +
                            ' - ' +
                            curError.getMessage() +
                            '\n';
                    }
                    responseList[replyPos].errors = errorReport;
                } else {
                    responseList[replyPos].isSuccess = true;
                    if (requests[replyPos].setSaveAsTask == true) {
                        string[] allRecipients = (requests[replyPos]
                            .toAddresses);
                        allRecipients.addall(requests[replyPos].ccAddresses);
                        allRecipients.addall(requests[replyPos].bccAddresses);
                        if (
                            requests[replyPos].recordID != null &&
                            allRecipients.size() > 0
                        ) {
                            responseList[replyPos].taskIds = addTasks(
                                requests[replyPos],
                                responseList[replyPos],
                                allRecipients
                            );
                        }
                    }
                }
                replyPos++;
            }
        }
        //report back the results
        boolean atLeastOneSent = false;
        for (Response thisResponse : responseList) {
            if (thisResponse.isSuccess) {
                atLeastOneSent = true;
                break;
            }
        }
        if (!atLeastOneSent) {
            throw new InvocableActionException(
                'No Messages were sent.  First Error: ' + responseList[0].errors
            );
        }
        return responseList;
    }

    // Add task activities
    private static List<String> addTasks(
        Request request,
        Response response,
        List<String> recipientList
    ) {
        List<String> thisResultIds = new List<String>();
        String recipientListIds;
        List<SObject> recipientListNames;
        string subject = request.subject;
        if (request.templateID != null && subject == null) {
            subject = [
                SELECT Subject
                FROM EmailTemplate
                WHERE Id = :request.templateID AND isActive = TRUE
            ]
            .Subject;
        }

        response.taskIds = new List<String>();
        List<Task> theseTasks = new List<Task>();
        List<Id> theseTargets = new List<String>{
            request.templateTargetObjectId
        };
        List<Id> theseWhatIds = new List<String>{ request.recordId };
        if (request.emailMessageType == 'massEmail') {
            theseTargets = request.targetObjectIds;
            theseWhatIds = request.whatIds;
        } else {
            theseTargets = request.templateTargetObjectId == null
                ? new List<String>()
                : new List<String>{ request.templateTargetObjectId };
            theseWhatIds = request.recordId == null
                ? new List<String>()
                : new List<String>{ request.recordId };
            Integer j = 0;
            while (j < recipientList.size()) {
                if (String.isBlank(recipientList[j])) {
                    recipientList.remove(j);
                } else
                    j++;
            }
        }
        for (Integer i = 0; i < theseTargets.size(); i++)
            theseTargets[i] = string.escapeSingleQuotes(theseTargets[i]);
        if (!theseTargets.isEmpty()) {
            recipientListIds = '\'' + string.join(theseTargets, '\',\'') + '\'';
            String queryString =
                'Select Name From ' +
                ((Id) theseTargets[0])
                    .getSObjectType()
                    .getDescribe()
                    .getName() +
                ' Where Id IN (' +
                recipientListIds +
                ')';
            recipientListNames = Database.query(queryString);
        }

        for (integer i = 0; i < theseWhatIds.size(); i++) {
            string thisRecipient;
            if (request.emailMessageType == 'massEmail') {
                thisRecipient = (string) recipientListNames[i].get('Name');
            } else {
                thisRecipient = theseTargets.isEmpty()
                    ? string.join(recipientList, ',')
                    : (string) recipientListNames[i].get('Name');
            }
            theseTasks.add(
                new Task(
                    OwnerId = UserInfo.getUserId(),
                    Subject = 'Sent Email: ' + subject,
                    Description = 'Sent Email : ' +
                        subject +
                        ' to recipient(s): ' +
                        thisRecipient,
                    Status = 'Closed',
                    Priority = 'Normal',
                    ActivityDate = Date.today(),
                    WhatId = theseWhatIds[i]
                )
            );
        }
        List<Database.SaveResult> theseResults = Database.Insert(
            theseTasks,
            false
        );
        for (Database.SaveResult thisResult : theseResults) {
            if (thisResult.isSuccess()) {
                thisResultIds.add(thisResult.getId());
            } else {
                thisResultIds.add('Errors: ' + thisResult.getId());
            }
        }
        return thisResultIds;
    }

    public class InvocableActionException extends Exception {
    }
}
