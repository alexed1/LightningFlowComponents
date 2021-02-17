/**
 * @description       : 
 * @author            : Mothith
 * @group             : 
 * @last modified on  : 02-16-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver      Date         Author         Modification
 * 1.0      07-16-2020  Mohith          Initial Version
 * 2.0.5    02-16-2021  Jack D. Pond    Fixed CDL Title (credit to Eric Schubert) Fix: #598
**/
public inherited sharing class SendBetterEmailAddAttachmentToEmail {
    //credit to https://digitalflask.com/blog/send-email-attachments-salesforce-apex/
    public static Messaging.SingleEmailMessage addAttachments(
        Messaging.SingleEmailMessage mail,
        List<ContentDocumentLink> contentDocumentLinks,
        Map<Id, List<ContentVersion>> mapContentDocumentIdByContentVersion
    ) {
        List<SObject> curAttachments = new List<SObject>();

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
                                Name = cv.Title,
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
}