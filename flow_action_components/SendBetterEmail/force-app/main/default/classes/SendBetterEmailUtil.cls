/**
 * @description       : SendBetterEmailUtil - helper utilities for SendBetterEmail
 * @author            : Refactored from Alex Edelstein
 * @group             : 
 * @last modified on  : 02-17-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver		Date		Author				Modification
 * 2.00.02	10-06-2020	Mohith Shrivastava  Refactored from SendBetterEmail
 * 2.00.05	02-17-2021	Jack Pond			Use Title.FileExtension instead of PathOnClient for attachment name
 * 2.00.05	02-17-2021	Jack Pond			Template Description empty causes error Fixes: #602
 * 
**/
public inherited sharing class SendBetterEmailUtil {
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
	public static Map<String, Object> generateMap(
		SendBetterEmailRequest request
	) {
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

	public static Map<Id, List<ContentVersion>> getMapContentDocumentIdByContentVersions(
		Set<Id> contentDocumentIds
	) {
		Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion = new Map<Id, List<ContentVersion>>();
		for (ContentVersion cv : [
			SELECT Id, PathOnClient, Title, VersionData, FileType, ContentDocumentId, FileExtension
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

	// Creates Map with template Name and list of all Email Templates with different languages
	public static Map<String, List<EmailTemplate>> getMapTemplateNameByEmailTemplates(
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

	public static String getTemplateIDFromName(
		String templateName,
		String templateLanguage,
		Map<String, List<EmailTemplate>> mapTemplateNameByEmailTemplates,
		String localKey
	) {
		String retTemplateID;
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
				if ( thisTemplate.Description != null &&
					thisTemplate.Description.contains(
						SendBetterEmailConstant.LANGUAGE_EQUAL
					)
				) {
					if (
						thisTemplate.Description.substringAfter(
								SendBetterEmailConstant.LANGUAGE_EQUAL
							)
							.substringBefore(
								SendBetterEmailConstant.DOUBLE_QUOTE
							) == templateLanguage
					) {
						retTemplateID = thisTemplate.Id;
						break;
					}
				} else {
					blankTemplate = (blankTemplate == null)
						? thisTemplate.Id
						: blankTemplate;
				}
			}
		}
		return (retTemplateID == null) ? blankTemplate : retTemplateID;
	}

	public static String getErrorString(
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

	public static String getDatabaseErrorString(
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

	public static Map<String, String> getMapRecordIdByName(
		List<String> targetObjectIds
	) {
		Map<String, String> mapRecordIdByName = new Map<String, String>();
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
				'Select Id, Name From ' +
				objectType.getDescribe().getName() +
				' WHERE Id IN : targetObjectIds'
			);
			lstRecords.addAll(recipientList);
		}

		for (Sobject rec : lstRecords) {
			if (rec.get('Name') != null) {
				mapRecordIdByName.put(
					(String) rec.get('Id'),
					(String) rec.get('Name')
				);
			}
		}

		return mapRecordIdByName;
	}
}