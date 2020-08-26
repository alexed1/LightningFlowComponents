public inherited sharing class AddTasksToEmail {
    // Add task activities
    public static List<String> addTasks(
        Request request,
        Response response,
        List<String> recipientList,
        Map<Id, EmailTemplate> mapIdByEmailTemplate
    ) {
        List<String> thisResultIds = new List<String>();
        String recipientListIds;
        List<SObject> recipientListNames;
        string subject = request.subject;

        if (
            request.templateId != null &&
            subject == null &&
            mapIdByEmailTemplate.get(request.templateId) != null
        ) {
            subject = mapIdByEmailTemplate.get(request.templateId).subject;
        }

        response.taskIds = new List<String>();
        List<Task> theseTasks = new List<Task>();
        List<Id> theseTargets = new List<String>{
            request.templateTargetObjectId
        };
        List<Id> theseWhatIds = new List<String>{ request.recordId };
        if (request.emailMessageType == Constant.MASSEMAIL) {
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
            if (request.emailMessageType == Constant.MASSEMAIL) {
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
}
