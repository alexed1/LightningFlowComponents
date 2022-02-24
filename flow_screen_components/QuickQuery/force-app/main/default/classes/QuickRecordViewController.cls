public with sharing class QuickRecordViewController {
    public virtual class BaseException extends Exception {}

    final static String DEFAULT_QUICK_QUERY_CONFIGURATION = 'DefaultQuickQueryConfigurationName';

    final static Map<String, string> FORMULA_TYPE_MAP = new Map<String, String>{
        'BOOLEAN'  => 'boolean',
        'CURRENCY' =>'number',
        'DATE' =>'date',
        'DATETIME' =>'datetime',
        'DOUBLE' =>'number',
        'INTEGER' =>'number',
        'LONG' =>'number',
        'PERCENT' =>'number'
    };
    final static String STANDARD_FIELD_LIST = 'Id, Name, OwnerId, CreatedDate';
    final static String CASE_FIELD_LIST = 'Id, Subject, OwnerId, Description, Status';
    final static String KNOWLEDGE_FIELD_LIST = 'Id, Title, Summary, PublishStatus ';

    final static String STANDARD_FILTER_OBJECT_LIST ='[' +
            '{"type": "text","fieldName": "Name","label": "Name"}, ' + 
            '{"type": "datetime","fieldName": "CreatedDate","label": "Created Date"}, ' + 
            '{"type": "text","fieldName": "OwnerId","label": "Owner"} ' + 
        ']';
    final static String CASE_FILTER_OBJECT_LIST ='[' +
            '{"type": "text","fieldName": "Subject","label": "Subject"}, ' + 
            '{"type": "text","fieldName": "Description","label": "Description"}, ' + 
            '{"type": "text","fieldName": "OwnerId","label": "Owner"}, ' +
            '{"type": "text","fieldName": "Status","label": "Status"} ' + 
        ']';
    final static String KNOWLEDGE_FILTER_OBJECT_LIST ='[' +
            '{"type": "text","fieldName": "Title","label": "Title"}, ' + 
            '{"type": "text","fieldName": "Summary","label": "Summary"}, ' + 
            '{"type": "text","fieldName": "PublishStatus","label": "Status"} ' + 
        ']';

    @AuraEnabled
    public static List<SObject> getRecordDataString(String viewId, String whereCondition, String objectName, String recordId) {
        String viewName = '';
        List<FlowTableViewDefinition__c>  quickRecordViewRecordList = [
                                                                SELECT  Object_API_Name__c,
                                                                        View_Name__c,
                                                                        Field_API_Names__c,
                                                                        Field_Sorting__c
                                                                FROM    FlowTableViewDefinition__c
                                                                WHERE   Id =: viewId
                                                                LIMIT   1];
        String request;
        if (quickRecordViewRecordList.size() > 0){
            viewName = quickRecordViewRecordList[0].View_Name__c;
            request =   'SELECT ' + 
                                    quickRecordViewRecordList[0].Field_API_Names__c +
                        ' FROM '  + quickRecordViewRecordList[0].Object_API_Name__c;

            if (String.isNotEmpty(whereCondition)){
                request += ' ' + whereCondition;
            }

            List<FieldOrderSetting> fieldOrderList = new List<FieldOrderSetting>();
            if(String.isNotEmpty(quickRecordViewRecordList[0].Field_Sorting__c)) {
                fieldOrderList = (List<FieldOrderSetting>)JSON.deserialize(quickRecordViewRecordList[0].Field_Sorting__c, List<FieldOrderSetting>.class);
            }

            String fieldOrdersString = '';

            for(FieldOrderSetting fieldOrder : fieldOrderList) {
                if(String.isEmpty(fieldOrdersString)) {
                    fieldOrdersString += fieldOrder.field + ' ' + fieldOrder.sortingDirection; 
                } else {
                    fieldOrdersString += ',' + fieldOrder.field + ' ' + fieldOrder.sortingDirection; 
                }
            }

            if(String.isNotEmpty(fieldOrdersString)) {
                request += ' ORDER BY ' + fieldOrdersString;
            }
        } else {

            if(objectName == 'Case') {
                request =   'SELECT ' + CASE_FIELD_LIST +
                ' FROM '  + objectName;

            } else if(objectName == 'Knowledge__kav' || objectName == 'KnowledgeArticleVersion'){
                request =   'SELECT ' + KNOWLEDGE_FIELD_LIST +
                ' FROM '  + objectName;
            } else {
                request =   'SELECT ' + STANDARD_FIELD_LIST +
                        ' FROM '  + objectName;
            }

            if (String.isNotEmpty(whereCondition)){
                request += ' ' + whereCondition;
            }

        }

        request += ' LIMIT 100';
        List<sObject> recordDataString = Database.query(request);

        if(String.isNotEmpty(viewName)) {
            upsertFlowPersonalConfugiration(viewName, recordId);
        }
                
        return recordDataString;                                               
    }
    
    @AuraEnabled(cacheable=false)
    public static String placeQuery(String filterListJSON, String objectName) {
        List<String> whereConditionList = new List<String>();
        List<FilterObjectRepresentation> filterList = (List<FilterObjectRepresentation>)JSON.deserialize(filterListJSON, List<FilterObjectRepresentation>.class);

        for(FilterObjectRepresentation filter : filterList) { 
            String wherecond ='';   
            String operatorBackend;
            if(String.isNotEmpty(filter.operator)) {
                operatorBackend = operatorConverter(filter.operator);                                              
                switch on filter.operator {
                        when  'contains' {
                            // List<String> valuesToCheck = filter.value.split(',');
                            // String formattedValue = '';
                            // Integer numberOfValues = valuesToCheck.size();
                                
                            // for (Integer i = 0; i < valuesToCheck.size(); i++){
                            //     formattedValue += '\'' + valuesToCheck[i] + '\'';
                            //     if (i < numberOfValues - 1)
                            //         formattedValue += ',';
                            // }
                            wherecond += filter.fieldName + ' ' + ' LIKE  ' + '\'' + '%' + filter.value  + '%\'';
                        }
                        when  'end_with' {
                            wherecond += filter.fieldName + ' ' + ' LIKE ' + '\'' + '%' + filter.value  + '\'';
                        }
                        when  'starts_with' {
                            wherecond += filter.fieldName + ' ' + ' LIKE ' + '\'' + filter.value + '%' + '\'';
                        }
                        when else {
                            wherecond += filter.fieldName + ' ' + operatorBackend + ' ' + ((filter.type == 'text') ? '\'' + filter.value + '\'' : filter.value);
                        }
                }
                whereConditionList.add( wherecond);
            }
        }
        System.debug(whereConditionList);
        if(whereConditionList.size() > 0) {
            return 'WHERE ' + String.join(whereConditionList, ' AND ');
        }
        return '';
    }

    @AuraEnabled
    public static List<Map<String, String>> getFlowTableViewDefinition(String objectName){
        List<FlowTableViewDefinition__c> viewList = [ 
            SELECT  Id,
                    Object_API_Name__c,
                    Field_API_Names__c,
                    View_Name__c,
                    (
                        SELECT Id 
                        FROM QuickQueryConfigurations__r
                        WHERE ViewUserId__c = :UserInfo.getUserId()
                    )
            FROM    FlowTableViewDefinition__c
            WHERE   Object_API_Name__c =: objectName
            ORDER BY View_Name__c
            LIMIT   50000
        ];
        
        List<Map<String, String>> viewOptionMapList = new List<Map<String, String>>();
       
        for(FlowTableViewDefinition__c view : viewList) {
            if(!view.QuickQueryConfigurations__r.isEmpty()) {
                Map<String, String> viewOptionMap = new Map<String, String>();
                viewOptionMap.put('label', view.View_Name__c);
                viewOptionMap.put('value', view.Id);
                viewOptionMapList.add(viewOptionMap);
            }
        }

        if(viewOptionMapList.isEmpty()) {
            Map<String, String> viewOptionMap = new Map<String, String>();
            viewOptionMap.put('label','New View');
            viewOptionMap.put('value', '');
            viewOptionMapList.add(viewOptionMap);
        }
        return viewOptionMapList;
    }
    @AuraEnabled
    public static List<FilterObjectRepresentation> searchFilterFileds(String viewId, String objectName) {

        List<FilterObjectRepresentation> filterFields = new List<FilterObjectRepresentation>();             //  Create List of filter fields for return
        
        if (String.isNotEmpty(viewId)){                                                                            //  Check that api object name for search is present 
            List<FlowTableViewDefinition__c> viewList = [ 
                SELECT  Id,
                        Object_API_Name__c,
                        Field_API_Names__c,
                        View_Name__c,
                        (
                            SELECT Id, Filter__c
                            FROM QuickQueryConfigurations__r
                            WHERE ViewUserId__c = :UserInfo.getUserId()
                        )
                FROM    FlowTableViewDefinition__c
                WHERE   Id =: viewId
                LIMIT   1
            ];
            List<FilterObjectRepresentation> filterList = new List<FilterObjectRepresentation>();
            if(!viewList[0].QuickQueryConfigurations__r.isEmpty() && String.isNotEmpty(viewList[0].QuickQueryConfigurations__r[0].Filter__c)) {
                filterList = (List<FilterObjectRepresentation>) JSON.deserialize(
                    viewList[0].QuickQueryConfigurations__r[0].Filter__c, 
                    List<FilterObjectRepresentation>.class
                );
            }

            SObjectType r = ((SObject)(Type.forName('Schema.'+viewList[0].Object_API_Name__c).newInstance())).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            List<String> fieldList = viewList[0].Field_API_Names__c.split(',');
            for(String fieldName : fieldList) {
                FilterObjectRepresentation filter;
                for(FilterObjectRepresentation item : filterList) {
                    if(item.fieldName == fieldName) {
                        filter = item;
                    }
                }
                if(filter != null){
                    filterFields.add(filter);
                } else {
                    String fieldType = FORMULA_TYPE_MAP.get(String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()));
                    filterFields.add(
                        new FilterObjectRepresentation(
                            fieldType != null ? fieldType : 'text', 
                            fieldName, 
                            d.fields.getMap().get(fieldName).getDescribe().getLabel()
                        )
                    );
                }
            }
            return filterFields;
        } else {
            if(objectName == 'Case') {
                return ParseFilterJSONToApexObject.parseStringToApexObj(CASE_FILTER_OBJECT_LIST);
            } else if(objectName == 'Knowledge__kav' || objectName == 'KnowledgeArticleVersion'){
                return ParseFilterJSONToApexObject.parseStringToApexObj(KNOWLEDGE_FILTER_OBJECT_LIST);
            } else {
                return ParseFilterJSONToApexObject.parseStringToApexObj(STANDARD_FILTER_OBJECT_LIST);
            } 
        }
    }

    public static String operatorConverter(String operatorFromLWC){
        switch on operatorFromLWC {
            when 'equals' {
                return '=';
            }
            when 'not_equal_to' {
                return '!=';
            }
            when 'greater_then' {
                return '>';
            }
            when 'greater_or_equal' {
                return '>=';
            }
            when 'less_then' {
                return '<';
            }
            when 'less_or_equal' {
                return '<=';
            }
            when 'contains' {
                return 'IN';
            }
            when 'starts_with' {
                return 'starts_with';
            }
            when 'end_with' {
                return 'end_with';
            }
            when else {
                return null;
            }
        }
    }

    @AuraEnabled
    public static String upsertView(String viewId, String viewName, String objectName, List<String> fieldList, String filtersJSON){
        FlowTableViewDefinition__c viewDef = new FlowTableViewDefinition__c();
        viewDef.Name = viewName;
        viewDef.Object_API_Name__c = objectName;
        viewDef.Field_API_Names__c = String.join(fieldList, ',');
        viewDef.View_Name__c = viewName;
        if(String.isNotEmpty(viewId)) {
            viewDef.Id = viewId;
        }

        upsert viewDef;

        List<QuickQueryConfiguration__c> quickQueryList = [
            SELECT  Id,
                    ViewUserId__c,
                    FlowTableViewDefinition__c
            FROM    QuickQueryConfiguration__c
            WHERE   ViewUserId__c = :UserInfo.getUserId()
            AND     FlowTableViewDefinition__c = : viewDef.Id
            LIMIT   1
        ];

        if(quickQueryList.isEmpty()) {
            QuickQueryConfiguration__c quickQuery = new QuickQueryConfiguration__c();
            quickQuery.FlowTableViewDefinition__c = viewDef.Id;
            quickQuery.ViewUserId__c = UserInfo.getUserId();
            quickQuery.ObjectName__c = objectName;
            quickQuery.Label__c = objectName;
            quickQuery.Filter__c = filtersJSON;
            insert quickQuery;
        } else {
            quickQueryList[0].Filter__c = filtersJSON;
            update quickQueryList;
        }

        return viewDef.Id;
    }


    @AuraEnabled
    public static  Map<String, String> getDefaultView(String recordId){
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
            AND     LocationId__c = :recordId
            LIMIT   1      
        ];

        String viewName = '';

        if(!flowConfigurationList.isEmpty()) {
            if(flowConfigurationList[0].Config1Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION){
                viewName = flowConfigurationList[0].Config1Value__c;
            } else if(flowConfigurationList[0].Config2Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config2Value__c;
            } else if(flowConfigurationList[0].Config3Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config3Value__c;
            } else if(flowConfigurationList[0].Config4Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config4Value__c;
            } else if(flowConfigurationList[0].Config5Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config5Value__c;
            } else if(flowConfigurationList[0].Config6Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config6Value__c;
            } else if(flowConfigurationList[0].Config7Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config7Value__c;
            } else if(flowConfigurationList[0].Config8Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config8Value__c;
            } else if(flowConfigurationList[0].Config9Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                viewName = flowConfigurationList[0].Config9Value__c;
            }
        }

        List<FlowTableViewDefinition__c>  flowTableViewDefinitionList = [
            SELECT  Object_API_Name__c,
                    Field_API_Names__c,
                    Field_Sorting__c
            FROM    FlowTableViewDefinition__c
            WHERE   View_Name__c =: viewName
            LIMIT   1];

            if(!flowTableViewDefinitionList.isEmpty()) {
                Map<string,String> resultMap = new Map<String,String>();
                resultMap.put('objectName', flowTableViewDefinitionList[0].Object_API_Name__c);
                resultMap.put('viewId', flowTableViewDefinitionList[0].Id);
                return resultMap;
            }

            return null;
    }

    static void upsertFlowPersonalConfugiration(String viewName, String recordId) {
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
            AND     LocationId__c = :recordId
            LIMIT   1      
        ];

        if(!flowConfigurationList.isEmpty()) {
            if(String.isEmpty(flowConfigurationList[0].Config1Name__c) || flowConfigurationList[0].Config1Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION){
                flowConfigurationList[0].Config1Value__c = viewName;
                flowConfigurationList[0].Config1Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config2Name__c) ||  flowConfigurationList[0].Config2Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config2Value__c = viewName;
                flowConfigurationList[0].Config2Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config3Name__c) || flowConfigurationList[0].Config3Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config3Value__c = viewName;
                flowConfigurationList[0].Config3Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config4Name__c) || flowConfigurationList[0].Config4Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config4Value__c = viewName;
                flowConfigurationList[0].Config4Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config5Name__c) || flowConfigurationList[0].Config5Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config5Value__c = viewName;
                flowConfigurationList[0].Config5Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config6Name__c) || flowConfigurationList[0].Config6Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config6Value__c = viewName;
                flowConfigurationList[0].Config6Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config7Name__c) || flowConfigurationList[0].Config7Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config7Value__c = viewName;
                flowConfigurationList[0].Config7Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config8Name__c) || flowConfigurationList[0].Config8Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config8Value__c = viewName;
                flowConfigurationList[0].Config8Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            } else if(String.isEmpty(flowConfigurationList[0].Config9Name__c) || flowConfigurationList[0].Config9Name__c == DEFAULT_QUICK_QUERY_CONFIGURATION) {
                flowConfigurationList[0].Config9Value__c = viewName;
                flowConfigurationList[0].Config9Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            }

            update flowConfigurationList;
        } else {
            FlowPersonalConfiguration__c flowConfiguration = new FlowPersonalConfiguration__c();
            flowConfiguration.ActorId__c = UserInfo.getUserId();
            flowConfiguration.LocationId__c = recordId;
            flowConfiguration.Config1Name__c = DEFAULT_QUICK_QUERY_CONFIGURATION;
            flowConfiguration.Config1Value__c = viewName;
            insert flowConfiguration;
        }
    }

    @AuraEnabled
    public static void updateRecords(String recordListJSON){
        List<SObject> recordList = (List<SObject>)JSON.deserialize(recordListJSON, List<SObject>.class);
        update recordList;
        
    }

    @AuraEnabled
    public static void deleteRecords(String recordListJSON){
        List<SObject> recordList = (List<SObject>)JSON.deserialize(recordListJSON, List<SObject>.class);
        delete recordList;
        
    }

    @AuraEnabled
    public static void updateSorting(String viewId, String fieldSorting){
        if(String.isNotEmpty(viewId)){
            FlowTableViewDefinition__c  flowTableViewDefinition = new FlowTableViewDefinition__c();
            flowTableViewDefinition.Id = viewId;
            flowTableViewDefinition.Field_Sorting__c = fieldSorting;

            update flowTableViewDefinition;
        }
    }
    
    public class FieldOrderSetting {
        @AuraEnabled
        public String field;
        @AuraEnabled
        public String sortingDirection;
    }
}