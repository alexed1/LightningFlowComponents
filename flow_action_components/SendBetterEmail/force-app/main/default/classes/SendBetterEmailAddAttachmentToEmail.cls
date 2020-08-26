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
}
