public with sharing class GetGroupInfo {
    @InvocableMethod
    public static List<Result> get(List<Request> requestList) {
        System.debug('entering GetGroupInfo');
        List<Result> resultWrapper= new List<Result>();
        System.debug('requestList is: ' + requestList);
        for(Request curRequest : requestList) {
            Result result = new Result();
            String groupId = curRequest.groupId;
            System.debug ('groupId is: ' + groupId);
            String groupName = curRequest.groupName;
            if ((groupId == null && groupName == null) || (groupId != null && groupName != null))
                throw new InvocableActionException('You must provide either a groupId or a group Name, but not both');
            if (groupName != null ){
                Group targetGroup = [SELECT Id,Name FROM Group WHERE Name = :groupName];
                groupId = targetGroup.Id;
            }    
            List<User> allUsers = analyzeGroup(groupId);

            
            for(User curUser : allUsers){
                result.userEmailAddresses.add(curUser.Email);
                result.userIds.add(curUser.Id);
                result.userNames.add(curUser.Username);
                result.users.add(curUser);
            }
            resultWrapper.add(result);
            
        }
        System.debug ('resultWrapper is: ' + resultWrapper);
        return resultWrapper;

    }

    public static List<User> analyzeGroup(String groupId) {
        System.debug('starting analyzeGroup for groupId: ' + groupId  );
        //find all the Users in this group
        List<User>  groupUsers = [SELECT User.Id, User.Email, User.Username FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :groupId)];
   
        //find all the child Groups in this group, for recursive analysis
        List<Group> childGroups = [SELECT Group.Id FROM Group WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :groupId)];
        for(Group curChildGroup : childGroups) {
            groupUsers.addAll(analyzeGroup(curChildGroup.Id));
        }
        System.debug('returning groupUsers ' + groupUsers  );
        return groupUsers;

    }


    public class Request {
 

        @InvocableVariable 
        public String groupId;

        @InvocableVariable
        public String groupName;

      
        

    }

    public class Result {

        public Result() {
            userEmailAddresses = new List<String>();
            userNames = new List<String>();
            userIds = new List<String>();
            users = new List<User>();
        }

        @InvocableVariable
        public List<String> userEmailAddresses;

        @InvocableVariable
        public List<String> userNames;

        @InvocableVariable
        public List<String> userIds;

        @InvocableVariable
        public List<User> users;

    }
    public class InvocableActionException extends Exception {}
}
