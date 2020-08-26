public inherited sharing class SendEmailUtil {
    
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
    public static Map<String, Object> generateMap(SendBetterEmailRequest request) {
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

    public static String gettemplateIdFromName(
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
                if (thisTemplate.Description.contains(Constant.LANGUAGE_EQUAL)) {
                    if (
                        thisTemplate.Description.substringAfter(Constant.LANGUAGE_EQUAL)
                            .substringBefore(Constant.DOUBLE_QUOTE) == templateLanguage
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

}
