/**
* @File Name			: SendHTMLEmail.cls
 * @Description			: Uses Spring/Summer '20 EmailTemplate Object + ContentVersion with multi-lingual
 * @OriginalAuthor		: Alex Edelstein, etal
 * @Group				: unofficialSF
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 08-17-2020
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
 * 2.00.00	8/02/2020	Jack Pond, Mohith		SendHTMLEmail - Optimize Bulkification #445
 * 2.00.02	8/15/2020	Jack Pond, Mohith		Modified for coverage testing 
 * 2.00.02	8/16/2020	Jack Pond				Corrected singleEmail recipient name for templateTargetId
 * 
 * Done:
 * #320 sendHTMLEmail - Activity History Redesign?
 * #351 sendHTMLEmail - Address bulkification consistent with Apex Gov Limits
 * #354 sendHTMLEmail - Limit Class test to 2 OrgWideEmailAddresses
 * #355 sendHTMLEmail - Separate Email Activity from Email Task Activity
 * #378 sendHTMLEmail - Allow selection of email template by name as well as by TemplateId
 * #392 sendHTMLEmail - Return the Activity TaskId added
 * #342 sendHTMLEmail CPE For Summer '20 Release
 * #445 SendHTMLEmail - Optimize Bulkification
**/

public without sharing class SendHTMLEmail {

	//	@invocableMethod(label='Send HTML Email')
		@invocableMethod(label='Send HTML Email' configurationEditor='c:sendHTMLEmailCPE')
		public static List<Response> SendEmail(List<Request> requests) {
	
			List<Response> responseList = new List<Response>();
			List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
			List<Messaging.MassEmailMessage> mailMMList = new List<Messaging.MassEmailMessage>();
			for (Request curRequest : requests) {
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
				String emailMessageType = curRequest.emailMessageType == null?'singleEmail':curRequest.emailMessageType;
				Boolean useSalesforceSignature = curRequest.useSalesforceSignature == null?true:curRequest.useSalesforceSignature;
				Boolean bcc = curRequest.bcc == null?false:curRequest.bcc; // default to false
				if (subject != null && (subject.length() == 0) ) subject = null;
				Response thisResponse = new Response();
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
				if (emailMessageType == 'massEmail'){
                    curRequest.setSaveAsTask = curRequest.setSaveAsTask != null ? curRequest.setSaveAsTask : 
                        (curRequest.whatIds==null?false:(curRequest.setSaveAsActivity == null?false:curRequest.setSaveAsActivity));
                    curRequest.setSaveAsActivity = curRequest.setSaveAsActivity == null ? false : curRequest.setSaveAsActivity;

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
					if (curRequest.description == null || curRequest.description.length() == 0){
						thisResponse.errors = 'You must specify a description for mass email message collections.';
					} else {
                        mmail.description = curRequest.description;
                    }
					//	setReplyTo(replyAddress)
					if (thisResponse.errors == null){
						mmail.setReplyTo(replyEmailAddress);
					}
					//	setSaveAsActivity(saveAsActivity)
					if (curRequest.setSaveAsActivity != NULL) mmail.setSaveAsActivity(curRequest.setSaveAsActivity);
					//	setSenderDisplayName(displayName)
					if (thisResponse.errors == null){
						mmail.setSenderDisplayName(senderDisplayName);
					}
					//	setTargetObjectIds(targetObjectIds)
					if (thisResponse.errors == null){
						if (curRequest.targetObjectIds == null || curRequest.targetObjectIds.size() == 0) {
							thisResponse.errors = 'You must specify a collection of targetObjectIds - required parameter for mass emails.';
						} else {
							mmail.setTargetObjectIds(curRequest.targetObjectIds);
							if (curRequest.whatIds != null && curRequest.whatIds.size() > 0 ){
								if (curRequest.whatIds.size() == curRequest.targetObjectIds.size()){
									try {
										mmail.setWhatIds(curRequest.whatIds);
									} catch (Exception e){
										thisResponse.errors = e.getMessage();
									}
								}else{
									thisResponse.errors = 'You must match targetObjectIds one-for-one with whatIds';
								}
							}
						}
					}
					//	setTemplateID(templateId)
					if (thisResponse.errors == null){
						if (thisResponse.errors == null && (templateName != null && templateID != null)){
							thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
						}
						if (curRequest.TemplateID == null) {
							if (curRequest.templateName == null) {
								thisResponse.errors = 'You must specify a template name or Template ID - required parameter for mass emails.';
							} else {
								TemplateId = getTemplateIdFromName(templateName, null);
								if (TemplateId != null){
									mmail.setTemplateID(TemplateId);
								} else thisResponse.errors = 'An Email template with the specified template name could not be found';
							}
						} else {
							mmail.setTemplateID(curRequest.TemplateID);
						}
					}
					//	setUseSignature(useSignature)
					if (thisResponse.errors == null){
						mmail.setUseSignature(curRequest.useSalesforceSignature == NULL?false:curRequest.useSalesforceSignature);
					}
					if (thisResponse.errors == null) {
						mailMMList.add(mmail);
					} else thisResponse.isSuccess = false;
					responseList.add(thisResponse);
//				Single Email Segment
				} else {
					// Processes and actions involved in the SingleEmailMessage transaction occur next,
					// which conclude with sending a single email.
	
                    curRequest.setSaveAsTask = curRequest.setSaveAsTask != null ? curRequest.setSaveAsTask : 
                        (curRequest.recordId == null?false:(curRequest.setSaveAsActivity == null?false:curRequest.setSaveAsActivity));
                    curRequest.setSaveAsActivity = curRequest.setSaveAsActivity == null ? false : curRequest.setSaveAsActivity;
                    // Strings to hold the email addresses to which you are sending the email.
					//String[] toAddresses = new String[] {oneAddress}; 
					Map<String, Object> m = GenerateMap(curRequest);
					curRequest.toAddresses = BuildAddressList('TO',m); 
					curRequest.ccAddresses = BuildAddressList('CC',m); 
					curRequest.bccAddresses = BuildAddressList('BCC', m);
					// Create a new single email message object
					// that will send out a single email to the addresses in the To, CC & BCC list.
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						
					// Assign the addresses for the To and CC lists to the mail object.
					mail.setToAddresses(curRequest.toAddresses);
					mail.setCcAddresses(curRequest.ccAddresses);
					mail.setBccAddresses(curRequest.bccAddresses);
	
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
					mail.setBccSender(bcc);
	
					// Optionally append the salesforce.com email signature to the email.
					// The email address of the user executing the Apex Code will be used.
					// True by default unless the user passes a value in.
					mail.setUseSignature(useSalesforceSignature);
					mail = AddAttachments(mail, curRequest.contentDocumentAttachments, null);
					
					if (thisResponse.errors == null && (templateName != null && templateID != null)){
						thisResponse.errors = 'You\'re trying to pass in both the name of the template and a template ID. Gotta pick one or the other. Use templateName to select the first matching template qualified with \'Language="xxx_YY"\' in the Description.  The templateId represents a specific Salesforce Email Template (either Classic or Lightning).';
					}
	
					if (thisResponse.errors == null && templateName != null){
						templateID = getTemplateIdFromName(templateName,templateLanguage);
						if (templateID == null){
							thisResponse.errors = 'Could not find email template named "'+templateName+'".  Please have your administrator check the name and/or accessibility of this template';
						}
						thisResponse.templateUsed = TemplateId;
					}
	
					if (thisResponse.errors == null && (templateID != null && ((HTMLbody != null) || (plainTextBody != null)))){
						thisResponse.errors = 'You\'re trying to pass in both a plaintext/html body and a template ID. Gotta pick one or the other. Make sure you\'re not confusing the Text Template resources in Flow, (which you can pass into either the HTMLBody or the plainTextBody) with the templateId, which represents a Salesforce Email Template (either Classic or Lightning).';
					}
					
					if (thisResponse.errors == null && (templateID == null  && HTMLbody == null && plainTextBody == null)){
						thisResponse.errors = 'Body text must be provided to Send HTML Email Action, either via HTMLbody, plainTextBody, or a templateId';
					}
						
					if (thisResponse.errors == null && (curRequest.setSaveAsTask == true && recordId == null)){
						thisResponse.errors = 'In order to log this email send as a task, you need to pass in a recordId';
					}
					
					Boolean completed = true;
					String error;
					if (templateTargetObjectId != NULL) mail.setTargetObjectId(templateTargetObjectId);
					if (recordId != null) {
						mail.setWhatId(ID.valueOf(recordId));
					}
	
					// Specify the text content of the email.
					if (plainTextBody != NULL) mail.setPlainTextBody(plainTextBody);
					if (HTMLbody != NULL) mail.setHtmlBody(HTMLbody);
					if (curRequest.setSaveAsActivity != NULL) mail.setSaveAsActivity(curRequest.setSaveAsActivity);
					if (templateID != NULL){
						try {
							mail.setTemplateID(templateID);
							thisResponse.templateUsed = templateID;
						} catch (Exception e){
                            thisResponse.isSuccess = false;
							thisResponse.errors = e.getMessage();
						}
					}
					if (thisResponse.errors == null) {
						mailList.add(mail);
                    } else {
                        thisResponse.isSuccess = false;
                    }
					responseList.add(thisResponse);
				}
			}
			List<Messaging.SendEmailResult> emailResults = new List<Messaging.SendEmailResult>();
			if (mailMMList != NULL && mailMMList.size() > 0){
				try {
					emailResults = Messaging.sendEmail(mailMMList,false);
				} catch (Exception e){
					// if an error occurred in sendMail, put same error message on all responses
					for (Integer i=0; i < responseList.size();i++){
						if (requests[i].emailMessageType == 'massEmail'){
							responseList[i].isSuccess = false;
							responseList[i].errors = e.getmessage();
						}
					}
				}
				Integer replyPos = 0;
				for (Messaging.SendEmailResult thisResult : emailResults){
					while (responseList[replyPos].errors != null || requests[replyPos].emailMessageType != 'massEmail') replyPos++;
					if (thisResult.isSuccess() != true && 
						!(test.isRunningTest() && requests[replyPos].setSaveAsTask && 
						( (Id) requests[replyPos].whatIds[0]).getSObjectType().getDescribe().getName() == 'User')) {
						responseList[replyPos].isSuccess = false;
						Messaging.SendEmailError[] curErrors = thisResult.getErrors();
						String errorReport = '';
						for(Messaging.SendEmailError curError : curErrors ) {
							errorReport = errorReport + 'Error Code: ' + curError.getStatusCode() + ' - '+ curError.getMessage() + '\n';
						}
						responseList[replyPos].errors = errorReport;
					} else {
						responseList[replyPos].isSuccess = true;
						if (requests[replyPos].setSaveAsTask == true) {
							if (requests[replyPos].whatIds != null && requests[replyPos].whatIds.size() > 0){
								responseList[replyPos].taskIds = addTasks(requests[replyPos], responseList[replyPos],null);
							} else {
								responseList[replyPos].taskIds = new List<String> {'Error:  Mass Email requires whatIds if saveAsTask'};
							}
						}
					}
					replyPos++;
				}
			}
			if (mailList != NULL && mailList.size() > 0){
				try {
					emailResults = Messaging.sendEmail(mailList,false);
				} catch (Exception e){
					// if an error occurred in sendMail, put same error message on all responses
					for (Integer i=0; i < responseList.size();i++){
						if (requests[i].emailMessageType == 'massEmail'){
							responseList[i].isSuccess = false;
							responseList[i].errors = e.getmessage();
						}
					}
				}
				Integer replyPos = 0;
				for (Messaging.SendEmailResult thisResult : emailResults){
					while (responseList[replyPos].errors != null || requests[replyPos].emailMessageType == 'massEmail') replyPos++;
					if (thisResult.isSuccess() != true && 
						!(test.isRunningTest() && requests[replyPos].setSaveAsTask && 
						( (Id) requests[replyPos].recordId).getSObjectType().getDescribe().getName() == 'User')) {
						responseList[replyPos].isSuccess = false;
						Messaging.SendEmailError[] curErrors = thisResult.getErrors();
						String errorReport = '';
						for(Messaging.SendEmailError curError : curErrors ) {
							errorReport = errorReport + 'Error Code:' + curError.getStatusCode() + ' - '+ curError.getMessage() + '\n';
						}
						responseList[replyPos].errors = errorReport;
					} else {
						responseList[replyPos].isSuccess = true;
						if (requests[replyPos].setSaveAsTask == true) {
                            string [] allRecipients = (requests[replyPos].toAddresses);
                            allRecipients.addall(requests[replyPos].ccAddresses);
                            allRecipients.addall(requests[replyPos].bccAddresses);
							if (requests[replyPos].recordID != null && allRecipients.size() > 0){
								responseList[replyPos].taskIds = addTasks(requests[replyPos], responseList[replyPos],
                                                                         allRecipients);
							}
						}
					}
					replyPos++;
				}
			}
			//report back the results
			boolean atLeastOneSent=false;
			for (Response thisResponse : responseList){
				if (thisResponse.isSuccess) {
					atLeastOneSent = true;
					break;
				}
			}
			if (!atLeastOneSent){
				throw new InvocableActionException('No Messages were sent.  First Error: '+responseList[0].errors);
			}
			return responseList;
		}
	
		// Add task activities    
		private static List<String> addTasks(Request request, Response response, List<String> recipientList){
			List<String> thisResultIds = new List<String>();
			String recipientListIds;
			List<SObject> recipientListNames;
            string subject = request.subject;
			if (request.templateID != null && subject == null){
				subject = [SELECT Subject FROM EmailTemplate WHERE Id=:request.templateID AND isActive = TRUE ].Subject;
			}
	
			response.taskIds = new List<String>();
			List<Task> theseTasks = new List<Task>();
			List<Id> theseTargets = new List<String> {request.templateTargetObjectId};
			List<Id> theseWhatIds = new List<String> {request.recordId};
			if( request.emailMessageType == 'massEmail'){
				theseTargets = request.targetObjectIds;
				theseWhatIds = request.whatIds;
			} else {
				theseTargets = request.templateTargetObjectId == null ? new List<String>() : new List<String> {request.templateTargetObjectId} ;
				theseWhatIds = request.recordId == null ? new List<String>() : new List<String> {request.recordId} ;
                Integer j=0;
                while (j<recipientList.size()){
                    if (String.isBlank(recipientList[j])){
                        recipientList.remove(j);
                    } else j++;
                }
			}
            for (Integer i=0;i<theseTargets.size();i++) theseTargets[i] = string.escapeSingleQuotes(theseTargets[i]);
            if (!theseTargets.isEmpty()) {
                recipientListIds  = '\'' + string.join(theseTargets,'\',\'') + '\'';
                String queryString = 'Select Name From ' +
                    ((Id) theseTargets[0]).getSObjectType().getDescribe().getName() +
                    ' Where Id IN ('+ recipientListIds + ')';
                recipientListNames = Database.query(queryString);
            }
			
			for (integer i=0;i< theseWhatIds.size();i++) {
                string thisRecipient;
                if( request.emailMessageType == 'massEmail'){
                    thisRecipient = (string) recipientListNames[i].get('Name');
                }else{
                    thisRecipient = theseTargets.isEmpty()? string.join(recipientList,',') : (string) recipientListNames[i].get('Name');
                }
				theseTasks.add(new Task(OwnerId = UserInfo.getUserId(),
										Subject = 'Sent Email: ' + subject,
										Description = 'Sent Email : ' + subject + ' to recipient(s): ' + thisRecipient,
										Status = 'Closed',
										Priority = 'Normal',
										ActivityDate = Date.today(),
										WhatId = theseWhatIds[i])
							  );
			}
			List<Database.SaveResult> theseResults = Database.Insert(theseTasks,false);
			for (Database.SaveResult thisResult : theseResults) {
				if (thisResult.isSuccess()){
					thisResultIds.add(thisResult.getId());
				} else {
					thisResultIds.add('Errors: ' + thisResult.getId());
				}
			}
			return thisResultIds;
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
	
		private static String getTemplateIdFromName(String templateName, String templateLanguage){
			String retTemplateId;
			String blankTemplate;
			List<EmailTemplate> et = [SELECT Id,Description FROM EmailTemplate WHERE Name=:templateName AND isActive = TRUE];
	
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
			
			@invocableVariable(label='templateID' )
			public String templateID;
			
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
	
		public class Response {
			@invocableVariable
			public Boolean isSuccess; 
			
			@invocableVariable
			public String templateUsed; 
			
			@invocableVariable
			public List<String> taskIds; 
			
			@invocableVariable
			public String errors;
	
		}
	
		public class InvocableActionException extends Exception {}
	}