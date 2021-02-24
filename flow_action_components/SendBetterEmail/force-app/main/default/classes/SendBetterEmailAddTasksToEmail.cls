/**
 * @description       : SendBetterEmailAddTasksToEmail - helper
 * @author            : Mohith Shrivastava
 * @group             : 
 * @last modified on  : 02-14-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver		Date		Author				Modification
 * 2.00.02	10-12-2020	Mohith Shrivastava	Initial Version - separated and refactored 
**/
public inherited sharing class SendBetterEmailAddTasksToEmail {
	// Add task activities
	public static List<TaskWrapper> addTasks(
		SendBetterEmailRequest request,
		List<String> recipientList,
		Map<Id, EmailTemplate> mapIdByEmailTemplate,
		Map<String, String> mapRecordIdByName
	) {
		List<String> thisResultIds = new List<String>();
		String recipientListIds;
		string subject = request.subject;
		if (
			request.templateID != null &&
			subject == null &&
			mapIdByEmailTemplate.get(request.templateID) != null
		) {
			subject = mapIdByEmailTemplate.get(request.templateID).subject;
		}

		List<TaskWrapper> lstTaskWrapper = new List<TaskWrapper>();

		List<String> theseTargets = new List<String>{
			request.templateTargetObjectId
		};
		List<String> lstWhatIds = new List<String>{ request.recordId };

		if (request.emailMessageType == SendBetterEmailConstant.MASSEMAIL) {
			theseTargets = request.targetObjectIds;
			lstWhatIds = request.whatIds;
		} else {
			theseTargets = request.templateTargetObjectId == null
				? new List<String>()
				: new List<String>{ request.templateTargetObjectId };
			lstWhatIds = request.recordId == null
				? new List<String>()
				: new List<String>{ request.recordId };
			Integer j = 0;
			while (j < recipientList.size()) {
				if (String.isBlank(recipientList[j])) {
					recipientList.remove(j);
				} else {
					j++;
				}
			}
		}
		for (integer i = 0; i < lstWhatIds.size(); i++) {
			string thisRecipient;
			if (request.emailMessageType == SendBetterEmailConstant.MASSEMAIL) {
				if (mapRecordIdByName.get(lstWhatIds[i]) != null) {
					thisRecipient = mapRecordIdByName.get(lstWhatIds[i]);
				}
			} else {
				if (mapRecordIdByName.get(lstWhatIds[i]) != null) {
					thisRecipient = theseTargets.isEmpty()
						? string.join(recipientList, ',')
						: mapRecordIdByName.get(lstWhatIds[i]);
				}
			}
			TaskWrapper taskWrapper = new TaskWrapper();
			Task task = new Task(
				OwnerId = UserInfo.getUserId(),
				Subject = 'Sent Email: ' + subject,
				Description = 'Sent Email : ' +
					subject +
					' to recipient(s): ' +
					thisRecipient,
				Status = 'Closed',
				Priority = 'Normal',
				ActivityDate = Date.today(),
				WhatId = lstWhatIds[i]
			);
			taskWrapper.requestIndex = request.index;
			taskWrapper.taskRec = task;
			lstTaskWrapper.add(taskWrapper);
		}

		return lstTaskWrapper;
	}

	public inherited sharing class TaskWrapper {
		public Integer requestIndex; // Request Number
		public Task taskRec; //  Task Record Instance
	}
}