@IsTest
private class fbc_SearchUtilsTest {

    static final List<String> TYPES_TO_SEARCH = new List<String>{
            'User', 'Queue'
    };
    static final String TEST_RECORD_NAME = 'testrecordname@test.te';

    @testSetup
    static void setup() {
        List<Profile> adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'test1', Email = 'testuser1@example.com', EmailEncodingKey = 'UTF-8', LastName = TEST_RECORD_NAME, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = adminProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = TEST_RECORD_NAME);
        insert testUser;
        Group userGroup = new Group(Name = TEST_RECORD_NAME, type = 'Queue');
        insert userGroup;
        QueuesObject queue = new QueueSObject(QueueID = userGroup.id, SobjectType = 'lead');
        insert queue;
    }

    @IsTest
    static void testSearchMemberByType() {
        User testUser = [SELECT Id, Name, UserName FROM User WHERE Username = :TEST_RECORD_NAME];
        Group testQueue = [SELECT Id, Name,DeveloperName FROM Group WHERE Type = 'Queue' AND Name = :TEST_RECORD_NAME];

        Map<String, SObject> typeToObject = new Map<String, SObject>{
                'User' => testUser, 'Queue' => testQueue
        };
        Map<String, List<fbc_SearchUtils.Member>> searchResult = fbc_SearchUtils.searchMemberByType(TYPES_TO_SEARCH, TEST_RECORD_NAME);

        //We have added one record to each type, so expecting as many records as types
        System.assertEquals(TYPES_TO_SEARCH.size(), searchResult.size());

        //For each type checking if search worked fine
        for (String typeName : TYPES_TO_SEARCH) {
            System.assertEquals(typeToObject.get(typeName).get(fbc_SearchUtils.TYPE_TO_ID_FIELD.get(typeName)), searchResult.get(typeName)[0].value);
            System.assertEquals(typeToObject.get(typeName).get('Name'), searchResult.get(typeName)[0].label);
        }

        //Checking that get name by id works fine
        Map<String, Set<String>> typeToIds = new Map<String, Set<String>>{
                'User' => (new Set<String>{
                        testUser.UserName
                }), 'Queue' => (new Set<String>{
                        testQueue.DeveloperName
                })
        };
        Map<String, SObject> members = fbc_SearchUtils.getMembersByTypeAndId(typeToIds);

        System.assertEquals(TEST_RECORD_NAME, members.get(testUser.UserName).get('Name'));
        System.assertEquals(TEST_RECORD_NAME, members.get(testQueue.DeveloperName).get('Name'));
    }
}