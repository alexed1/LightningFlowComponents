@isTest
public with sharing class QuickRecordViewControllerTest {
    @testSetup
    static void setup(){
        insert new Case(Origin = 'Web', Status = 'New');
        insert new List<QuickRecordView__c>{
                                            new QuickRecordView__c(   ObjectName__c = 'Contact',
                                                                                                    Columns__c = 'FirstName, LastName, Email',
                                                                                                    Filter__c = '[' + 
                                                                                                                    '{"type": "text","fieldName": "FirstName", "label": "First Name"},' + 
                                                                                                                    '{"type": "text","fieldName": "LastName","label": "Last Name"}, ' +
                                                                                                                    '{"type": "text","fieldName": "Email", "label": "Email"} ' + 
                                                                                                                ']',
                                                                                                    Label__c = 'Contact',
                                                                                                    Query__c = ''),
                                            new QuickRecordView__c( ObjectName__c = 'Case',
                                                                                                    Columns__c = 'CaseNumber, Status',
                                                                                                    Filter__c = '[' + 
                                                                                                                    '{"type": "text","fieldName": "CaseNumber","label": "CaseNumber"},' + 
                                                                                                                    '{"type": "text","fieldName": "Site","label": "Account Site"}, ' +
                                                                                                                    '{"type": "text","fieldName": "Status","label": "Status"} ' + 
                                                                                                                ']',
                                                                                                    Label__c = 'Case',
                                                                                                    Query__c = 'WHERE Status = \'New\''),
                                            new QuickRecordView__c(  ObjectName__c = 'Opportunity',
                                                                                                    Columns__c = 'Owner, LastActivity, Amout, Stage',
                                                                                                    Filter__c = '['+
                                                                                                                    '{"type": "text","fieldName": "Owner", "label": "Owner"}, ' + 
                                                                                                                    '{"type": "text","fieldName": "LastActivity","label": "Last Activity"},' + 
                                                                                                                    '{"type": "text","fieldName": "Amount", "label": "Amount"}, ' +
                                                                                                                    '{"type": "text","fieldName": "Stage", "label": "Stage"}' +
                                                                                                                ']',
                                                                                                    Label__c = 'Opportunity',
                                                                                                    Query__c = ''),
                                            new QuickRecordView__c(  ObjectName__c = 'Account',
                                                                                                    Columns__c = 'Name, Site, Rating',
                                                                                                    Filter__c = '['+
                                                                                                                    '{"type": "text","fieldName": "Name","label": "Name"}, ' + 
                                                                                                                    '{"type": "text","fieldName": "Site","label": "Account Site"},' + 
                                                                                                                    '{"type": "text","fieldName": "Rating","label": "Rating"}, ' +
                                                                                                                ']',
                                                                                                    Label__c = 'Account',
                                                                                                    Query__c = ''),
                                            new QuickRecordView__c(  ObjectName__c = 'Account',
                                                                                                    Columns__c = 'Name, Site, Rating',
                                                                                                    Filter__c = '['+
                                                                                                                    '{"type": "text","fieldName": "Name","label": "Name"}, ' + 
                                                                                                                    '{"type": "text","fieldName": "Site","label": "Account Site"},' + 
                                                                                                                    '{"type": "text","fieldName": "Rating","label": "Rating"}, ' +
                                                                                                                ']',
                                                                                                    Label__c = 'Account',
                                                                                                    Query__c = ''),
                                            new QuickRecordView__c(   ObjectName__c = 'OrderItem',
                                                                                                    Columns__c = 'FirstName, LastName, Email',
                                                                                                    Filter__c = '[' + 
                                                                                                                    '{"type": "text","fieldName": "FirstName", "label": "First Name"},' + 
                                                                                                                    '{"type": "text","fieldName": "LastName","label": "Last Name"}, ' +
                                                                                                                    '{"type": "text","fieldName": "Email", "label": "Email"} ' + 
                                                                                                                ']',
                                                                                                    Label__c = 'OrderItem',
                                                                                                    Query__c = '')
        };
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

        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds('Contact');
        for (FilterObjectRepresentation contactFilterIterator : contactFilter){
            System.assert(fieldName.contains(contactFilterIterator.fieldName));
            System.assert(label.contains(contactFilterIterator.label));
            System.assert(type.contains(contactFilterIterator.type));
        }
    }

    // Retrieve any QuickRecordView that have a matching object name. If more than 1 result comes back, 
    // thrown an error.
     @isTest
     static void testMatchingObjectNameMoreThanOneResult() {
         try {
            QuickRecordViewController.searchFilterFileds('Account');
         } catch (Exception e){
            System.assertEquals('More than 1 QuickRecordView returned!', e.getMessage()); 
         }
     }

    // If input is null. 
    @isTest
    static void testNoObjectName() {
        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds(null);
        System.assertEquals(null, contactFilter);
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

        List <FilterObjectRepresentation> contactFilter = QuickRecordViewController.searchFilterFileds('QuickRecordView');

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
         String serializedString = JSON.serialize(QuickRecordViewController.getRecordDataString('Case', ''));
         System.assertEquals(null, QuickRecordViewController.getRecordDataString(null, null));
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
        System.assertEquals('WHERE Status  IN (\'New\',\' Working\')', response); 
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

}