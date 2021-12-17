public with sharing class QuickRecordViewController {
    public virtual class BaseException extends Exception {}

    @AuraEnabled
    public static List<SObject> getRecordDataString(String objectName, String whereCondition) {
        if (objectName != null){
            List<QuickRecordView__c>  quickRecordViewRecordList = [
                                                                SELECT 
                                                                        Columns__c,
                                                                        Filter__c,
                                                                        Label__c,
                                                                        ObjectName__c,
                                                                        Query__c
                                                                FROM    QuickRecordView__c
                                                                WHERE   ObjectName__c =: objectName
                                                                LIMIT   1];
            String request;
            if (quickRecordViewRecordList.size() > 0){
                request =   'SELECT ' + 
                                        quickRecordViewRecordList[0].Columns__c +
                            ' FROM '  + quickRecordViewRecordList[0].ObjectName__c;

                if (String.isNotEmpty(whereCondition)){
                    request += ' ' + whereCondition;
                }
                   
            } else {

                request =   'SELECT Id, Name, OwnerId, CreatedDate' +
                            ' FROM '  + objectName;

                            if (String.isNotEmpty(whereCondition)){
                                request += ' ' + whereCondition;
                            }
            }
            List<sObject> recordDataString = Database.query(request);
                
            return recordDataString;
        }                                                
        return null;
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
    public static List<FilterObjectRepresentation> searchFilterFileds(String searchTerm) {

        List<FilterObjectRepresentation> filterFields = new List<FilterObjectRepresentation>();             //  Create List of filter fields for return
        
        if (searchTerm != null){                                                                            //  Check that api object name for search is present 
                List<QuickRecordView__c> quickRecordViewRecord = [
                                                                    SELECT 
                                                                            Columns__c,
                                                                            Filter__c,
                                                                            Label__c,
                                                                            ObjectName__c,
                                                                            Query__c
                                                                    FROM    QuickRecordView__c
                                                                    WHERE   ObjectName__c =: searchTerm
                                                                ]; 
                switch on quickRecordViewRecord.size() {
                    when 0 {
                        return ParseFilterJSONToApexObject.parseStringToApexObj('[' +
                                                                                    '{"type": "text","fieldName": "Name","label": "Name"}, ' + 
                                                                                    '{"type": "datetime","fieldName": "CreatedDate","label": "Created Date"}, ' + 
                                                                                    '{"type": "text","fieldName": "OwnerId","label": "Owner"} ' + 
                                                                                ']');
                    }	
                    when 1 {
                        return ParseFilterJSONToApexObject.parseStringToApexObj(quickRecordViewRecord[0].Filter__c);
                    }
                    when else {
                        throw new BaseException('More than 1 QuickRecordView returned!');
                    }
                }
                
        }
        return null;
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
}