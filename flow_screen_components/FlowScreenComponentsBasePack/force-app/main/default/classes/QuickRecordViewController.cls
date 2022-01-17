public with sharing class QuickRecordViewController {
    public virtual class BaseException extends Exception {}

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
    final static String KNOWLEDGE_FIELD_LIST = 'Id, Title, Summary, Status ';

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
    public static List<SObject> getRecordDataString(String viewId, String whereCondition, String objectName) {
        List<FlowTableViewDefinition__c>  quickRecordViewRecordList = [
                                                                SELECT  Object_API_Name__c,
                                                                        Field_API_Names__c
                                                                FROM    FlowTableViewDefinition__c
                                                                WHERE   Id =: viewId
                                                                LIMIT   1];
        String request;
        if (quickRecordViewRecordList.size() > 0){
            request =   'SELECT ' + 
                                    quickRecordViewRecordList[0].Field_API_Names__c +
                        ' FROM '  + quickRecordViewRecordList[0].Object_API_Name__c;

            if (String.isNotEmpty(whereCondition)){
                request += ' ' + whereCondition;
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

            request += ' LIMIT 100';
        }
        List<sObject> recordDataString = Database.query(request);
                
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
                            List<String> valuesToCheck = filter.value.split(',');
                            String formattedValue = '';
                            Integer numberOfValues = valuesToCheck.size();
                                
                            for (Integer i = 0; i < valuesToCheck.size(); i++){
                                formattedValue += '\'' + valuesToCheck[i] + '\'';
                                if (i < numberOfValues - 1)
                                    formattedValue += ',';
                            }
                            wherecond += filter.fieldName + ' ' + ' IN (' + formattedValue + ')';
                        }
                        when  'end_with' {
                            wherecond += filter.fieldName + ' ' + ' LIKE ' + '\'' + '%' + filter.value  + '\'';
                        }
                        when  'starts_with' {
                            wherecond += filter.fieldName + ' ' + ' LIKE ' + '\'' + filter.value + '%' + '\'';
                        }
                        when else {
                            wherecond += filter.fieldName + ' ' + operatorBackend + ' ' + '\'' + filter.value + '\'';
                        }
                }
                whereConditionList.add(wherecond);
            }
        }

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
                    View_Name__c
            FROM    FlowTableViewDefinition__c
            WHERE   Object_API_Name__c =: objectName
            LIMIT   50000
        ];
        
        List<Map<String, String>> viewOptionMapList = new List<Map<String, String>>();
       
        for(FlowTableViewDefinition__c view : viewList) {
            Map<String, String> viewOptionMap = new Map<String, String>();
            viewOptionMap.put('label', view.View_Name__c);
            viewOptionMap.put('value', view.Id);
            viewOptionMapList.add(viewOptionMap);
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
                        View_Name__c
                FROM    FlowTableViewDefinition__c
                WHERE   Id =: viewId
                LIMIT   1
            ];
            SObjectType r = ((SObject)(Type.forName('Schema.'+viewList[0].Object_API_Name__c).newInstance())).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            List<String> fieldList = viewList[0].Field_API_Names__c.split(',');
            for(String fieldName : fieldList) {
                String fieldType = FORMULA_TYPE_MAP.get(String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()));
                filterFields.add(
                    new FilterObjectRepresentation(
                        fieldType != null ? fieldType : 'text', 
                        fieldName, 
                        d.fields.getMap().get(fieldName).getDescribe().getLabel()
                    )
                );
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
    public static String upsertView(String viewId, String viewName, String objectName, List<String> fieldList){
        FlowTableViewDefinition__c viewDef = new FlowTableViewDefinition__c();
        viewDef.Name = viewName;
        viewDef.Object_API_Name__c = objectName;
        viewDef.Field_API_Names__c = String.join(fieldList, ',');
        viewDef.View_Name__c = viewName;
        if(String.isNotEmpty(viewId)) {
            viewDef.Id = viewId;
        }

        upsert viewDef;

        return viewDef.Id;
    }
}