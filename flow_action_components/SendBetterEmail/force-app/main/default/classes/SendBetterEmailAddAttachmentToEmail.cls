/**
 * @description
 * @author            Alex Edelstein
 * @author            Jack Pond
 * @author            Michael Kraus
 * @group             SendBetterEmail
 * @since  09-01-2021
 * @author  : Michael Kraus
 * Modifications Log
 * Ver      Date        Author              Modification
 * 1.0      02-16-2021  Alex Edelstein      Initial Version
 * 2.0.5    02-16-2021  Jack D. Pond        Use Title instead of PathOnClient for attachment name
 * 2.1.7    09-01-2021  Michael Kraus       Use setEntityAttachments() instead of setFileAttachments()
 *
 **/
@SuppressWarnings('PMD')
public inherited sharing class SendBetterEmailAddAttachmentToEmail {
    //credit to https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
    public static Messaging.SingleEmailMessage addAttachments(
        Messaging.SingleEmailMessage mail,
        List<ContentDocumentLink> contentDocumentLinks,
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion
    ) {
        Set<Id> contentVersionIds = new Set<Id>();

        if (contentDocumentLinks != null && !contentDocumentLinks.isEmpty()) {
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                Id contentDocumentId = cdl.ContentDocumentId;
                if (
                    mapContentDocumentIdByContentVersion.get(contentDocumentId) != null &&
                    mapContentDocumentIdByContentVersion.get(contentDocumentId).size() > 0
                ) {
                    for (
                        ContentVersion cv : mapContentDocumentIdByContentVersion.get(
                            contentDocumentId
                        )
                    ) {
                        contentVersionIds.add(cv.Id);
                    }
                }
            }
        }

        if (contentVersionIds.size() > 0) {
            mail.setEntityAttachments(new List<Id>(contentVersionIds));
        }

        return mail;
    }
}