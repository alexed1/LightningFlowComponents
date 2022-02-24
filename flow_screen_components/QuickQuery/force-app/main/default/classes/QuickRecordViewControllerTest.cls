@isTest
public with sharing class QuickRecordViewControllerTest {
    @testSetup
    static void setup(){
        insert new Case(Origin = 'Web', Status = 'New');
        List<FlowTableViewDefinition__c> flowTableDefinitionList = new List<FlowTableViewDefinition__c>{
            new FlowTableViewDefinition__c(
                Field_API_Names__c = 'FirstName,LastName,Email',
                Object_API_Name__c = 'Contact',
                View_Name__c = 'Contact'),
            new FlowTableViewDefinition__c(
                Field_API_Names__c = 'CaseNumber,Status',
                Object_API_Name__c = 'Case',
                View_Name__c = 'Case'),
            new FlowTableViewDefinition__c( 
                Field_API_Names__c = 'Owner, LastActivity,Amout,Stage',
                Object_API_Name__c = 'Opportunity',
                View_Name__c = 'Opportunity'),
            new FlowTableViewDefinition__c(
                Field_API_Names__c = 'Name,Site,Rating',
                Object_API_Name__c = 'Account',
                View_Name__c = 'Account1'),
            new FlowTableViewDefinition__c(
                Field_API_Names__c = 'Name,Site,Rating',
                Object_API_Name__c = 'Account',
                View_Name__c = 'Account2'),
            new FlowTableViewDefinition__c(  
                Field_API_Names__c = 'FirstName,LastName,Email',
                Object_API_Name__c = 'OrderItem',
                View_Name__c = 'OrderItem')
        };
        insert flowTableDefinitionList;


        List<QuickQueryConfiguration__c> quickQueryConfigurationList = new List<QuickQueryConfiguration__c>();

        for(FlowTableViewDefinition__c flowDefinition : flowTableDefinitionList) {
            quickQueryConfigurationList.add(new QuickQueryConfiguration__c(
                Label__c = flowDefinition.Object_API_Name__c,
                ObjectName__c = flowDefinition.Object_API_Name__c,
                ViewUserId__c = UserInfo.getUserId(),
                FlowTableViewDefinition__c = flowDefinition.Id
            ));
        }

        insert quickQueryConfigurationList;
    }

    // Default behavior: when a change is made to the object name specified in the object lookup,
    // attempt to retrieve any QuickRecordView that have a matching object name. If more than 1 result comes back, 
    // thrown an error. If zero results come back, define a virtual QuickRecordView that uses as its columns Name, Owner, Create Date. 
    // The idea here is that any custom object should work, even if a view record doesn’t exist.

    // {"type": "text","fieldName": "FirstName", "label": "First Name"}
    // {"type": "text","fieldName": "LastName","label": "Last Name"}
    // {"type": "text","fieldName": "Email", "label": "Email"} 

    // Retrieve any QuickRecordView that have a matching object name
    @isTest
    static void testMatchingObjectName() {
        List<String> type = new List<String>{'text','text','text'};
        List<String> fieldName = new List<String>{'FirstName','LastName','Email'};
        List<String> label = new List<String>{'First Name','Last Name','Email'};
        FlowTableViewDefinition__c  flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c 
            FROM    FlowTableViewDefinition__c 
            WHERE   Object_API_Name__c = 'Contact'
            LIMIT   1
        ];

        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds(flowDef.Id, 'Contact');
        for (FilterObjectRepresentation contactFilterIterator : contactFilter){
            System.assert(fieldName.contains(contactFilterIterator.fieldName));
            System.assert(label.contains(contactFilterIterator.label));
            System.assert(type.contains(contactFilterIterator.type));
        }
    }

    // If input is null. 
    @isTest
    static void testNoObjectName() {

        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds(null, 'Account');

        System.assert(contactFilter.size() > 0);
    }

    // If zero results come back, define a virtual QuickRecordView that uses as its columns Name, Owner, Create Date. 
    // {"type": "text","fieldName": "Name","label": "Name"}, 
    // {"type": "datetime","fieldName": "CreatedDate","label": "Created Date"}, 
    // {"type": "text","fieldName": "Owner","label": "Owner"} 

    @isTest
    static void testDefaultBehaviourObjectName() {
        List<String> type = new List<String>{'text','datetime','text'};
        List<String> fieldName = new List<String>{'OwnerId','CreatedDate','Name'};
        List<String> label = new List<String>{'Owner','Created Date','Name'};

        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds('', 'Account');


        for (FilterObjectRepresentation contactFilterIterator : contactFilter){
            System.assert(fieldName.contains(contactFilterIterator.fieldName));
            System.assert(label.contains(contactFilterIterator.label));
            System.assert(type.contains(contactFilterIterator.type));
        }
    }


    // Convert operator testing. LWC component use text representation of operators like = - 'equal'
    @isTest
    static void testOperatorConverter() {
        Map<String, String> salesforceOperatorLWCComponentOperator = new Map<String, String>{   
                                                                                                'equals' => '=',
                                                                                                'not_equal_to' => '!=',
                                                                                                'greater_then' => '>',
                                                                                                'greater_or_equal' => '>=',
                                                                                                'less_then' => '<',
                                                                                                'less_or_equal' => '<=',
                                                                                                'contains' => 'IN',
                                                                                                'starts_with' => 'starts_with',
                                                                                                'end_with' => 'end_with'
                                                                                             };
        
        for (String key : salesforceOperatorLWCComponentOperator.keySet()){
            System.assertEquals(salesforceOperatorLWCComponentOperator.get(key), QuickRecordViewController.operatorConverter(key));
        }
        
        System.assertEquals(null, QuickRecordViewController.operatorConverter('Anything what is not operator return null.'));
    }

     // Convert operator testing. LWC component use text representation of operators like = - 'equal'
     @isTest
     static void testGetRecordDataString() {
         Account accnt = new Account(Name = 'TestAccount');
         insert accnt;
         String viewId = QuickRecordViewController.upsertView('', 'Test View Name', 'Account', new List<String>{'Name', 'CreatedDate', 'OwnerId'}, accnt.Id);
         String serializedString = JSON.serialize(QuickRecordViewController.getRecordDataString(viewId, '', 'Account', accnt.Id));

         System.assert(String.isNotEmpty(serializedString));
     }

    @isTest
    static void testPlaceQueryContainsTwoElement() {
        FilterObjectRepresentation filter = new FilterObjectRepresentation();
        filter.fieldName = 'Status';
        filter.label = 'Status';
        filter.operator = 'contains';
        filter.type = 'text';
        filter.value = 'New, Working';
        String response = QuickRecordViewController.placeQuery(JSON.serialize(new List<FilterObjectRepresentation>{filter}), 'Case');
        System.assertEquals('WHERE Status  LIKE  \'%New, Working%\'', response); 
    }

    @isTest
    static void testPlaceQueryStartWith() {
        FilterObjectRepresentation filter = new FilterObjectRepresentation();
        filter.fieldName = 'Status';
        filter.label = 'Status';
        filter.operator = 'starts_with';
        filter.type = 'text';
        filter.value = 'N';
        String response = QuickRecordViewController.placeQuery(JSON.serialize(new List<FilterObjectRepresentation>{filter}), 'Case');
        System.assertEquals('WHERE Status  LIKE \'N%\'', response); 
    }

    @isTest
    static void testPlaceQueryEndWith() {
        FilterObjectRepresentation filter = new FilterObjectRepresentation();
        filter.fieldName = 'Status';
        filter.label = 'Status';
        filter.operator = 'end_with';
        filter.type = 'text';
        filter.value = 'w';
        String response = QuickRecordViewController.placeQuery(JSON.serialize(new List<FilterObjectRepresentation>{filter}), 'Case');
        System.assertEquals('WHERE Status  LIKE \'%w\'', response); 
    }

    @isTest
    static void testUsertView() {
        Account accnt = new Account(Name = 'TestAccount');
        insert accnt;
        String viewId = QuickRecordViewController.upsertView('', 'Test View Name', 'Account', new List<String>{'Name', 'CreatedDate', 'OwnerId'}, accnt.Id);
        FlowTableViewDefinition__c  flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c 
            FROM    FlowTableViewDefinition__c 
            WHERE   Id = :viewId
            LIMIT   1
        ];

        System.assertEquals(flowDef.View_Name__c, 'Test View Name');
        viewId = QuickRecordViewController.upsertView(viewId, 'Test View Name2', 'Account', new List<String>{'Name', 'CreatedDate', 'OwnerId'}, accnt.Id);

        System.assertEquals(viewId, flowDef.Id);

        flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c 
            FROM    FlowTableViewDefinition__c 
            WHERE   Id = :viewId
            LIMIT   1
        ];

        System.assertEquals(flowDef.View_Name__c, 'Test View Name2');
    }

    @isTest
    static void tesGetFlowTableViewDefinition() {
        List<Map<String, String>> flowDefMap =  QuickRecordViewController.getFlowTableViewDefinition('Account');

        System.assert(flowDefMap.size() == 2);

        //for object that Flow Table View Definition record isn't existing
        flowDefMap =  QuickRecordViewController.getFlowTableViewDefinition('Lead');
        System.assert(flowDefMap.size() == 1);
    }

    @isTest
    static void testDefaultView() {
        Account accnt = new Account(Name = 'TestAccount');
        insert accnt;

        List<FlowTableViewDefinition__c>  flowDefList = [
            SELECT  Id, 
                    Name, 
                    View_Name__c 
            FROM    FlowTableViewDefinition__c 
            WHERE   Object_API_Name__c = 'Account'
            LIMIT   2
        ];

        Map<String, String> defaultView = QuickRecordViewController.getDefaultView(accnt.Id);

        System.assert(defaultView == null);

        List<SObject> recordList = QuickRecordViewController.getRecordDataString(flowDefList[0].Id, '', 'Account', accnt.Id);
        
        defaultView = QuickRecordViewController.getDefaultView(accnt.Id);

        System.assert(defaultView != null);
        System.assert(defaultView.get('objectName') == 'Account');
        System.assert(defaultView.get('viewId') == flowDefList[0].Id);



        recordList = QuickRecordViewController.getRecordDataString(flowDefList[1].Id, '', 'Account', accnt.Id);
        defaultView = QuickRecordViewController.getDefaultView(accnt.Id);

        System.assert(defaultView != null);
        System.assert(defaultView.get('objectName') == 'Account');
        System.assert(defaultView.get('viewId') == flowDefList[1].Id);

        List<FlowPersonalConfiguration__c> flowConfigurationList = [
            SELECT  Id,
                    ActorId__c,     LocationId__c,
                    Config1Name__c, Config1Value__c,
                    Config2Name__c, Config2Value__c,
                    Config3Name__c, Config3Value__c,
                    Config4Name__c, Config4Value__c,
                    Config5Name__c, Config5Value__c,
                    Config6Name__c, Config6Value__c,
                    Config7Name__c, Config7Value__c,
                    Config8Name__c, Config8Value__c,
                    Config9Name__c, Config9Value__c   
            FROM    FlowPersonalConfiguration__c
            WHERE   ActorId__c = : UserInfo.getUserId()
            AND     LocationId__c = :accnt.Id
            LIMIT   1      
        ];

        System.assert(!flowConfigurationList.isEmpty());

        flowConfigurationList[0].Config1Name__c = 'testName1';
        flowConfigurationList[0].Config2Name__c = 'testName2';
        flowConfigurationList[0].Config3Name__c = 'testName3';
        flowConfigurationList[0].Config4Name__c = 'testName4';
        flowConfigurationList[0].Config5Name__c = 'testName5';
        flowConfigurationList[0].Config6Name__c = 'testName6';
        flowConfigurationList[0].Config7Name__c = 'testName7';
        flowConfigurationList[0].Config8Name__c = 'testName8';

        update flowConfigurationList;


        recordList = QuickRecordViewController.getRecordDataString(flowDefList[1].Id, '', 'Account', accnt.Id);
        defaultView = QuickRecordViewController.getDefaultView(accnt.Id);

        System.assert(defaultView != null);
        System.assert(defaultView.get('objectName') == 'Account');
        System.assert(defaultView.get('viewId') == flowDefList[1].Id);
        
    } 

    @isTest
    static void testUpdateRecords(){

        Account accnt = new Account(Name = 'TestAccount');
        insert accnt;

        accnt.Name = 'New Test Name';
       

        QuickRecordViewController.updateRecords(JSON.serialize(new List<Account> {accnt}));

        Account accnt2 = [SELECT Id, Name FROM Account WHERE Id =: accnt.Id LIMIT 1];

        System.assert(accnt2.Name == 'New Test Name');
        
    }

    @isTest
    static void testDeleteRecords(){
        Account accnt = new Account(Name = 'TestAccount');
        insert accnt;

        QuickRecordViewController.deleteRecords(JSON.serialize(new List<Account> {accnt}));

        List<Account> accntList = [SELECT Id, Name FROM Account WHERE Id =: accnt.Id];

        System.assert(accntList.isEmpty());
        
    }



    @isTest
    static void testUpdateSorting() {
        FlowTableViewDefinition__c  flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c,
                    Field_Sorting__c
            FROM    FlowTableViewDefinition__c 
            WHERE   View_Name__c = 'Case'
            LIMIT   1
        ];

        String fieldSorting = '[{"field":"Subject","sortingDirection":"DESC"}]';

        QuickRecordViewController.updateSorting(flowDef.Id, null);

        
        flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c,
                    Field_Sorting__c
            FROM    FlowTableViewDefinition__c 
            WHERE   Id = :flowDef.Id
            LIMIT   1
        ];

        System.assert(flowDef.Field_Sorting__c == null);

        QuickRecordViewController.updateSorting(flowDef.Id, fieldSorting);

        flowDef = [
            SELECT  Id, 
                    Name, 
                    View_Name__c,
                    Field_Sorting__c
            FROM    FlowTableViewDefinition__c 
            WHERE   Id = :flowDef.Id
            LIMIT   1
        ];

        System.assert(flowDef.Field_Sorting__c == fieldSorting);


    }
}