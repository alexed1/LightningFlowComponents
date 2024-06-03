public class ApprovalChecker {
    @InvocableMethod (label='Check if a record is locked')
    public static List<Boolean> isLocked(List<Id> recordIdToCheck)	{
        List<Boolean> isLockedList = new List<Boolean>();
     	for (Id recordId : recordIdToCheck)	{
            isLockedList.add(system.Approval.isLocked(recordId));
            }
    return isLockedList;}
}