public without sharing class fsc_lookupController {
    // Search function to search for a record
    @AuraEnabled
    public static List<SObject> search(String searchTerm, String objectName, String fieldsToSearch, String fieldsToReturn, Integer numRecordsToReturn, String whereClause, String orderByClause) {
        System.debug('in search: searchTerm='+ searchTerm +'. objectName='+ objectName +'. fieldsToSearch='+ fieldsToSearch +'. fieldsToReturn='+ fieldsToReturn +'. numRecordsToReturn='+ numRecordsToReturn +'.');
        List<SObject> returnRecords = new List<SObject>();
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        String objectNameField = getNameField(objectName);
        String searchFieldString;
        if (String.isBlank(fieldsToSearch)) {
            fieldsToSearch = '';
        }
        fieldsToSearch = fieldsToSearch.replaceAll('(\\s+)', '');
        System.debug('fieldsToSearch = '+ fieldsToSearch);
        if (String.isBlank(fieldsToReturn)) {
            fieldsToReturn = '';
        }
        fieldsToReturn = fieldsToReturn.replaceAll('(\\s+)', '');
        System.debug('fieldsToReturn = '+ fieldsToReturn);


        if (!String.isBlank(searchTerm)) {
            if (String.isBlank(fieldsToSearch)) {
                fieldsToSearch = objectNameField;
            } else if (fieldsToSearch.toLowerCase() == 'all') {
                // TODO: more exhaustive list of valid operators for different field data types
                // 
                /*
                List<String> fieldNames = new List<String>(fieldMap.keySet());
                fieldNames.remove(fieldNames.indexOf('id'));
                fieldsToSearch = String.join(fieldNames, ',');
                // fieldsToSearch.replace(',Id,',','); // Like operator cannot be performed on ID
                */
            }

            List<String> searchFieldList = new List<String>();
            // System.debug('untrimmed = '+ fieldsToSearch.split(','));
            // List<String> searchStrings = splitAndTrim(fieldsToSearch);
            // System.debug('searchStrings = '+ searchStrings);
            // for (String searchString : searchStrings) {
            //     System.debug('test: !'+ searchString +'!');
            // }
            for (String searchField : fieldsToSearch.split(',')) {
                System.debug('searching for !'+ searchField +'!, or !'+ searchField.trim()+'!');
                // Check if field contains a dot, indicating a relationship
                if (searchField.contains('.')) {
                    // Example Account.CreatedBy.FirstName
                    // Get the middle part of the string
                    String relationshipName = searchField.split('\\.')[1];
                    String relationshipField = searchField.split('\\.')[2];
                    String relationshipNameConverted = relationshipName;
                    String relationshipObjectName = objectName;
                    String searchFieldConverted = searchField;
                    System.debug('relationshipName = '+ relationshipName);
                    System.debug('relationshipField = '+ relationshipField);

                    // Check if the relationship exists
                    if (fieldMap.get(relationshipName) == null) {
                        // Try a differnt relationshipName
                        // Add __r to the end of the relationshipName
                        relationshipNameConverted = relationshipName + '__r';
                        if(fieldMap.get(relationshipNameConverted) != null) {
                            // Replace the relationshipName in the searchField
                            searchFieldConverted = searchFieldConverted.replace(relationshipName, relationshipNameConverted);

                            // Set the relationshipName to the converted relationshipName
                            relationshipName = relationshipNameConverted;
                        } else {
                            // Add Id to the end of the relationshipField
                            relationshipNameConverted = relationshipName + 'Id';
                            if(fieldMap.get(relationshipNameConverted) != null) {
                                relationshipName = relationshipNameConverted;
                            }
                        }
                    }

                    Map<String, Schema.SObjectField> tokenMap = ((SObject)Type.forName('Schema', objectName).newInstance()).getSObjectType().getDescribe().fields.getMap();
                    Schema.DescribeFieldResult fieldResult = tokenMap.get(relationshipName).getDescribe();
                    if (fieldResult.getReferenceTo().size() == 1) {
                        relationshipObjectName = fieldResult.getReferenceTo()[0].getDescribe().getName();
                        System.debug('relationshipObjectName = '+ relationshipObjectName);
                    }

                    // Check if the relationship exists
                    if (fieldMap.get(relationshipName) != null) {
                        System.debug('fieldMap.get(relationshipName) = '+ fieldMap.get(relationshipName));
                        // Check if the field exists on the relationship
                        if (fieldMap.get(relationshipName).getDescribe().getRelationshipName() != null) {
                            System.debug('fieldMap.get(relationshipName).getDescribe().getRelationshipName() = '+ fieldMap.get(relationshipName).getDescribe().getRelationshipName());
                            // Get the relationship object field map
                            Map<String, Schema.SObjectField> relationshipFieldMap = getFieldMap(relationshipObjectName);
                            System.debug('relationshipFieldMap = '+ relationshipFieldMap);
                            // Check if the field exists on the relationship object
                            if (relationshipFieldMap.get(relationshipField) != null) {
                                System.debug('relationshipFieldMap.get(relationshipField) = '+ relationshipFieldMap.get(relationshipField));
                                // Add the search string to the list
                                if (relationshipFieldMap.get(relationshipField).getDescribe().getType().name() == 'String') {
                                    searchFieldList.add(searchFieldConverted +' LIKE \'%'+ searchTerm +'%\'');
                                }
                                // else 
                                    // searchFieldList.add(searchField +' = \''+ searchTerm +'\'');
                            }
                        }
                    }
                } else {
                    // Check if field exists
                    if (fieldMap.get(searchField) != null) {
                        System.debug('found '+ fieldMap.get(searchField));
                        if (fieldMap.get(searchField).getDescribe().getType().name() == 'String')
                            searchFieldList.add(searchField +' LIKE \'%'+ searchTerm +'%\'');
                        // else 
                            // searchFieldList.add(searchField +' = \''+ searchTerm +'\'');
                    }
                }
            }
            searchFieldString = String.join(searchFieldList, ' OR ');
        }

        if (String.isBlank(fieldsToReturn)) {
            // If no fields to return are specified, return the name field
            fieldsToReturn = objectNameField;
        } else if (!String.isBlank(fieldsToSearch)) {
            // Go through the list of fields to search and add them to the list of fields to return if they are not already there
            for (String searchField : fieldsToSearch.split(',')) {
                if (!fieldsToReturn.contains(searchField)) {
                    fieldsToReturn += ', '+ searchField;
                }
            }
        }

        String queryString = 'SELECT '+ fieldsToReturn +' FROM '+ objectName;
        // Integer whereComponents = (String.isBlank(whereClause) ? 0 : 1) + (String.isBlank(searchFieldString) ? 0 : 1);
        if (!String.isBlank(whereClause) || !String.isBlank(searchFieldString)) {
            queryString +=' WHERE ';
            if (!String.isBlank(whereClause) && !String.isBlank(searchFieldString)) {
                queryString += '('+ searchFieldString +') AND ('+ whereClause +')';
            } else {
                queryString += String.isBlank(searchFieldString) ? whereClause : searchFieldString;
            }
        }
        if (!String.isBlank(orderByClause)) {
            queryString += ' ORDER BY '+ orderByClause;
        }
        if (numRecordsToReturn > 0) {
            queryString += ' LIMIT '+ numRecordsToReturn;
        }
        System.debug('queryString = '+ queryString);
        returnRecords = Database.query(queryString);
        return returnRecords;
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecordsFromIds(String objectName, String fieldsToReturn, List<String> idsToRetrieve){        
        // return search(null, objectName, )        
        List<String> recordIds = new List<String>();
        for (String recordId : idsToRetrieve) {
            recordIds.add('\''+ recordId +'\'');
        }
        String whereClauseString = 'Id IN ('+ String.join(recordIds, ',') +')';
        return search(null, objectName, null, fieldsToReturn, 0, whereClauseString, null);
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecentlyViewed(String objectName, String fieldsToReturn, Integer numRecordsToReturn, String whereClause){
        // try {
            if (!(numRecordsToReturn > 0)) {
                numRecordsToReturn = 5;
            }
            List<RecentlyViewed> recentViews = search(null, 'RecentlyViewed', null, 'Id', numRecordsToReturn, 'Type = \''+ objectName +'\'', 'LastReferencedDate DESC');
            if (recentViews.size() == 0) {
                return new List<SObject>();
            }
            List<String> recordIds = new List<String>();
            for (RecentlyViewed recentView : recentViews) {
                recordIds.add('\''+ recentView.Id +'\'');
            }
            String whereClauseString = 'Id IN ('+ String.join(recordIds, ',') +')';
            if (!String.isBlank(whereClause)) {
                whereClauseString += ' AND '+ whereClause;
            }
            return search(null, objectName, null, fieldsToReturn, numRecordsToReturn, whereClauseString, 'LastReferencedDate DESC');
        // } catch (Exception e) {
        //     System.debug('Error in getRecentlyViewed: '+ e);
        //     return null;
        // }
    }

    // Get a list of records that match the where clause
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName, String fieldsToReturn, Integer numRecordsToReturn, String whereClause){
        // if numRecordsToReturn is not specified, default to 5
        if (!(numRecordsToReturn > 0)) {
            numRecordsToReturn = 5;
        }
        System.debug('getRecords: '+ objectName +', '+ fieldsToReturn +', '+ numRecordsToReturn +', '+ whereClause);
        return search(null, objectName, null, fieldsToReturn, numRecordsToReturn, whereClause, null);
    }

    public static List<String> splitAndTrim(String inputString) {
        return splitAndTrim(inputString, ',');
    }

    public static List<String> splitAndTrim(String inputString, String delimiter) {
        List<String> splitStrings = inputString.split(delimiter);
        for (String splitString : splitStrings) {
            splitString = splitString.trim();
            System.debug('trimmed version is !'+ splitString +'!');
        }
        System.debug('returning '+ splitStrings);
        return splitStrings;
    }

    public static Map<String, Schema.SObjectField> getFieldMap(String objectName) {
        return ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType().getDescribe().fields.getMap();
    }

    public static String getNameField(String objectName) {
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        if (fieldMap.containsKey('Name') && fieldMap.get('Name').getDescribe().IsNameField()) {
            return 'Name';
        }
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
            if (fieldResult.IsNameField()) {
                return fieldResult.getName();
            }
        }
        return null;
    }

    // Get the icon for a given object
    @AuraEnabled(cacheable=true)
    public static String getObjectIcon(String objectName) {
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( objectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + objectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        return u;
    }
}