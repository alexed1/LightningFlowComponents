public with sharing class InvocableApprovalHelper {
	@InvocableMethod(
		label='Approval Request (Action)'
		description='Submit Approval Request Actions via Flow action.'
		category='Approvals'
		iconName='slds:standard:approval'
	)
	public static List<Result> execute(List<Request> requests) {
		List<Result> results = new List<Result>();
		List<Approval.ProcessWorkitemRequest> approvalWorkItems = new List<Approval.ProcessWorkitemRequest>();

		// make ProcessWorkitemRequest from the submitted requests
		for (Request curRequest : requests) {
			Approval.ProcessWorkitemRequest approvalWorkItem = new Approval.ProcessWorkitemRequest();

			approvalWorkItem.setAction(curRequest.action);

			if (String.isNotBlank(curRequest.comments)) {
				approvalWorkItem.setComments(curRequest.comments);
			}

			if (curRequest.nextApproverIds != null && !curRequest.nextApproverIds.isEmpty()) {
				approvalWorkItem.setNextApproverIds(curRequest.nextApproverIds);
			}

			approvalWorkItem.setWorkitemId(
				String.isBlank(curRequest.approvalRequestId)
					? getApprovalRequestId(curRequest.recordId)
					: curRequest.approvalRequestId
			);

			system.debug('approvalWorkItem ' + approvalWorkItem);
			approvalWorkItems.add(approvalWorkItem);
		}

		// process all requests at once (allOrNone = false errors will be returned to the flow)
		List<Approval.ProcessResult> approvalResults = Approval.process(approvalWorkItems, false);

		// Process the results
		Integer i = 0;
		for (Request curRequest : requests) {
			Approval.ProcessResult approvalResult = approvalResults[i];
			// Submit the request for approval

			system.debug('ApprovalResult ' + approvalResult);

			//Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
			results.add(new Result(approvalResult));
			i++;
		}

		// return the results to the flow
		return results;
	}

	// create a string from the errors (if any)
	public static String getErrorInfo(List<Database.Error> errors) {
		if (errors == null || errors.isEmpty()) {
			// no errors
			return null;
		}

		String errorStrings = 'There was an error processing the approval request:';
		for (Database.Error error : errors) {
			errorStrings += '\n' + error.getMessage();
		}

		return errorStrings;
	}

	public static Id getapprovalRequestId(String recordId) {
		String objName = ((Id) recordId).getSobjectType().getDescribe().getLocalName();
		List<ProcessInstanceWorkitem> piws = [
			SELECT
				id,
				ActorId,
				CreatedDate,
				OriginalActorId,
				OriginalActor.name,
				ProcessInstanceId,
				ProcessInstance.Status,
				ProcessInstance.SubmittedById,
				ProcessInstance.ProcessDefinition.TableEnumOrId,
				ProcessInstance.ProcessDefinition.Type
			FROM ProcessInstanceWorkitem
			WHERE
				ProcessInstance.TargetObjectId = :recordId
				AND ProcessInstance.ProcessDefinition.Type = 'Approval'
				AND ProcessInstance.ProcessDefinition.TableEnumOrId = :objName
				AND ProcessInstance.Status = 'Pending'
			LIMIT 1
		];
		return piws.isEmpty() ? null : piws[0].Id;
	}

	public class Request {
		@InvocableVariable(label='1. Record Id (The current Approval Request Id will be found for you)')
		public String recordId;

		@InvocableVariable(label='2. Approval Request Id (use either this or the Record Id)')
		public String approvalRequestId;

		@InvocableVariable(
			label='3. Action, Valid values: \'Approve\', \'Reject\', \'Removed\' (Removed is for admins only)'
			required=true
		)
		public String action; // 'Approve', 'Reject'. 'Removed' https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ProcessWorkitemRequest.htm#apex_Approval_ProcessWorkitemRequest_setAction

		@InvocableVariable(label='4. Comments')
		public String comments;

		@InvocableVariable(label='5. Next Approver Ids')
		public List<String> nextApproverIds;
	}

	public class Result {
		@InvocableVariable(label='Success')
		public Boolean isSuccess;

		@InvocableVariable(label='Error')
		public String errorString;

		@InvocableVariable(
			label='Current Approval Process Status returns: \'Approved\', \'Rejected\', \'Removed\', \'Pending\')'
		)
		public String currentApprovalProcessStatus; //Approved, Rejected, Removed or Pending.

		public Result(Approval.ProcessResult approvalResult) {
			this.isSuccess = approvalResult.isSuccess();
			this.errorString = getErrorInfo(approvalResult.getErrors()); //warning. only hacking out the first error
			this.currentApprovalProcessStatus = approvalResult.getInstanceStatus();
		}
	}
}
