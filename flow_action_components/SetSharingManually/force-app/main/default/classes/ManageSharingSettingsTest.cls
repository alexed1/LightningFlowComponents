@IsTest
private class ManageSharingSettingsTest {
    static final String TEST_NAME = 'testrecordname@test.te';
    static final String MANAGER_NAME = 'ManageSharingSettings';
    static final String OBJECT_TYPE = 'User';
    static final Set<String> EXPECTED_ACTION_BUTTONS = new Set<String>{
            'Read', 'None', 'Read/Write'
    };

    @testSetup
    static void setup() {
        List<Profile> adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'test1', Email = 'testuser1@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = adminProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = TEST_NAME);
        insert testUser;
        UserRole testRole = new UserRole(DeveloperName = 'TestRole', Name = TEST_NAME);
        insert testRole;
    }

    @IsTest
    static void testHandleButtonAction() {
        Sharing_Test_Object__c acc = new Sharing_Test_Object__c(Name = TEST_NAME);
        insert acc;
        UserRole testRole = [SELECT Id FROM UserRole WHERE Name =: TEST_NAME];
        Group testGroup = [SELECT Id, Name FROM Group WHERE RelatedId = :testRole.Id AND Type = 'Role'];

//        Account acc = [SELECT Id, Name FROM Account WHERE Name = :TEST_NAME];
        User testUser = [SELECT Id FROM User WHERE Username = :TEST_NAME];

        //Checking if supported buttons are added
        List<RoleManagerController.ButtonSetting> supportedButtons = (List<RoleManagerController.ButtonSetting>) JSON.deserialize(RoleManagerController.getSupportedButtons(MANAGER_NAME,acc.Id), List<RoleManagerController.ButtonSetting>.class);
        Set<String> actualButtonNames = new Set<String>();
        for (RoleManagerController.ButtonSetting bs : supportedButtons) {
            actualButtonNames.add(bs.name);
            System.assertEquals(true, EXPECTED_ACTION_BUTTONS.contains(bs.name));
        }
        System.assertEquals(EXPECTED_ACTION_BUTTONS.size(), actualButtonNames.size());

        //Checking number of shares before clicking buttons
        List<RoleManagerController.MemberInfo> existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        Integer numberOfExistingMembers = existingMembers.size();

        //Adding new share
        RoleManagerController.handleButtonAction('Read', MANAGER_NAME, JSON.serialize(generateParamString(testUser.Id, acc.Id, OBJECT_TYPE)));

        //Checking list of shares after we added one
        existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        System.assertEquals(numberOfExistingMembers + 1, existingMembers.size());

        //***
        //Changing existing share
        RoleManagerController.handleButtonAction('Read/Write', MANAGER_NAME, JSON.serialize(generateParamString(testUser.Id, acc.Id, OBJECT_TYPE)));

        //Checking list of shares after we changed one
        existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        System.assertEquals(numberOfExistingMembers + 1, existingMembers.size());
        //***

        //Removing share
        RoleManagerController.handleButtonAction('None', MANAGER_NAME, JSON.serialize(generateParamString(testUser.Id, acc.Id, OBJECT_TYPE)));

        //Checking if share is actually removed
        existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        System.assertEquals(numberOfExistingMembers, existingMembers.size());

        //Checking Role Shares
        //Adding new share
        RoleManagerController.handleButtonAction('Read', MANAGER_NAME, JSON.serialize(generateParamString(testGroup.Id, acc.Id, OBJECT_TYPE)));

        //Change role access level
        RoleManagerController.handleButtonAction('Read/Write', MANAGER_NAME, JSON.serialize(generateParamString(testGroup.Id, acc.Id, OBJECT_TYPE)));
        existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        System.assertEquals(numberOfExistingMembers + 1, existingMembers.size());

        //Removing share
        RoleManagerController.handleButtonAction('None', MANAGER_NAME, JSON.serialize(generateParamString(testGroup.Id, acc.Id, OBJECT_TYPE)));

        //Checking if share is actually removed
        existingMembers = RoleManagerController.getExistingMembers(MANAGER_NAME, acc.Id);
        System.assertEquals(numberOfExistingMembers, existingMembers.size());
    }

    @IsTest
    static void testMissingManager() {
        String wrongManagerName = MANAGER_NAME + 'test';
        try {
            List<RoleManagerController.ButtonSetting> supportedButtons = (List<RoleManagerController.ButtonSetting>) JSON.deserialize(RoleManagerController.getSupportedButtons(wrongManagerName,''), List<RoleManagerController.ButtonSetting>.class);
        } catch (Exception ex) {
            System.assertEquals(true, ex.getMessage().contains('Manager "' + wrongManagerName + '" is not found'));
        }
    }

    private static Map<String, String> generateParamString(String userOrGroupID, String recordId, String type) {
        Map<String, String> result = new Map<String, String>();
        if (userOrGroupID != null) {
            result.put('userOrGroupID', userOrGroupID);
        }
        if (recordId != null) {
            result.put('recordId', recordId);
        }
        if (type != null) {
            result.put('type', type);
        }

        return result;
    }
}