@isTest
public with sharing class GetGroupInfoTest {
  
    @isTest
    public static void canGetGroupInfo() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testuser1 = new User(Alias = 'test1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com.foobarious');
        User testuser2 = new User(Alias = 'test2', Email='standarduser2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@testorg.com.foobarious');
        Insert testuser1;
        Insert testuser2;
        List<User> inputUsers = new List<User>{testuser1, testuser2};


        //Create Parent Group
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 

        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = testuser1.Id;
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;

        //Create Group Member
        GroupMember grpMem2 = new GroupMember();
        grpMem2.UserOrGroupId = testuser2.Id;
        grpMem2.GroupId = grp.Id;
        Insert grpMem2;

        List<GetGroupInfo.Request> requestWrapper = new List<GetGroupInfo.Request>();
        GetGroupInfo.Request curRequest = new GetGroupInfo.Request();
        curRequest.groupId = grp.Id;
        requestWrapper.add(curRequest);
        List<GetGroupInfo.Result> results = GetGroupinfo.get(requestWrapper);
        List<User> resultUsers = results[0].users;
        System.assertEquals(resultUsers[0].Id, inputUsers[0].Id);
        System.assertEquals(resultUsers[1].Id, inputUsers[1].Id);
    }
}
