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
                System.debug('found '+ fieldMap.get(searchField));
                if (fieldMap.get(searchField).getDescribe().getType().name() == 'String')
                    searchFieldList.add(searchField +' LIKE \'%'+ searchTerm +'%\'');
                // else 
                    // searchFieldList.add(searchField +' = \''+ searchTerm +'\'');
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