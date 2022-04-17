global with sharing class SearchUtils {

    static final Map<String, String> TYPE_TO_SOBJECT = new Map<String, String>{
            'User' => 'User',
            'Role_subordinates' => 'UserRole',
            'Role' => 'UserRole',
            'Group' => 'Group',
            'Queue' => 'Group'
    };

    static final Map<String, String> TYPE_TO_QUERY_CRITERIA = new Map<String, String>{
            'User' => 'WHERE IsActive = true AND Name LIKE (searchString)',
            'Role_subordinates' => 'WHERE Name LIKE (searchString)',
            'Role' => 'WHERE Name LIKE (searchString)',
            'Group' => 'WHERE (Type = \'global\' OR Type = \'Regular\') AND Name LIKE (searchString)',
            'Queue' => 'WHERE Type = \'Queue\' AND Name LIKE (searchString)'
    };

    static final List<String> OTHER_TYPES = new List<String>{
            'RelatedUsers', 'Owner', 'Creator'
    };

    global static final Map<String, String> TYPE_TO_ID_FIELD = new Map<String, String>{
            'User' => 'UserName',
            'Group' => 'DeveloperName',
            'Queue' => 'DeveloperName',
            'Role' => 'DeveloperName',
            'Role_subordinates' => 'DeveloperName'
    };


    @AuraEnabled(cacheable=true)
    global static Map<String, List<Member>> searchMemberByType(List<String> memberTypes, String searchString) {
        Map<String, List<Member>> resultMap = new Map<String, List<Member>>();

        for (String curType : TYPE_TO_SOBJECT.keySet()) {

            if (!memberTypes.contains(curType)) {
                continue;
            }

            String queryString = 'SELECT ' + getQueriedFields(curType) + ' FROM ' + TYPE_TO_SOBJECT.get(curType) + ' ' + TYPE_TO_QUERY_CRITERIA.get(curType).replace('(searchString)', '\'%' + String.escapeSingleQuotes(searchString) + '%\'');

            List<SObject> types = Database.query(queryString);
            List<Member> members = new List<Member>();
            for (SObject t : types) {
                members.add(new Member((String) t.get('Name'), (String) t.get(getIdField(curType))));
            }
            resultMap.put(curType, members);
        }

        return resultMap;
    }
    @AuraEnabled(cacheable=true)
    global static Map<String, SObject> getSingleMembersByTypeAndId(String type, String id) {
        return getMembersByTypeAndId(new Map<String, Set<String>>{
                type => new Set<String>{
                        id
                }
        });
    }
    global static Map<String, SObject> getMembersByTypeAndId(Map<String, Set<String>> typeToIds) {

        Map<String, SObject> results = new Map<String, SObject>();
        for (String sObjectTypeName : typeToIds.keySet()) {
            if (OTHER_TYPES.contains(sObjectTypeName)) {
                for (String curMember : typeToIds.get(sObjectTypeName)) {
                    results.put(curMember, new Account(Name = curMember));
                }
            } else {
                Set<String> objectIds = typeToIds.get(sObjectTypeName);

                String idField = getIdField(sObjectTypeName);
                String queryString = 'SELECT ' + getQueriedFields(sObjectTypeName) + ' FROM ' + TYPE_TO_SOBJECT.get(sObjectTypeName) + ' WHERE ' + idField + ' IN: objectIds';
                List<SObject> members = Database.query(queryString);
                for (SObject curMember : members) {
                    results.put((String) curMember.get(idField), curMember);
                }
            }
        }
        return results;
    }

    private static String getIdField(String objectType) {
        return TYPE_TO_ID_FIELD.containsKey(objectType) ? TYPE_TO_ID_FIELD.get(objectType) : 'Id';
    }

    private static String getQueriedFields(String objectType) {
        String requiredFields = 'Id, Name';
        if (TYPE_TO_ID_FIELD.containsKey(objectType)) {
            requiredFields += ', ' + TYPE_TO_ID_FIELD.get(objectType);
        }
        return requiredFields;
    }

    @AuraEnabled(cacheable=true)
    global static Map<String, List<Member>> describeSObjects(List<String> types) {

        Map<String, List<SearchUtils.Member>> objectToFieldDescribe = new Map<String, List<SearchUtils.Member>>();
        if (types == null || types.isEmpty()) {
            return objectToFieldDescribe;
        }

        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);

        for (Schema.DescribeSobjectResult res : results) {
            String objName = res.getName();
            objectToFieldDescribe.put(objName, new List<SearchUtils.Member>());
            Map<String, SObjectField> fieldMap = res.fields.getMap();
            for (String fieldApiName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldApiName).getDescribe();
                objectToFieldDescribe.get(res.getName()).add(new Member(fieldDescribe.getLabel(), fieldDescribe.getName(), objName, fieldDescribe.getType().name()));
            }
        }

        return objectToFieldDescribe;
    }

    global class Member {
        @AuraEnabled global String label;
        @AuraEnabled global String value;
        @AuraEnabled global String dataType;
        @AuraEnabled global String type;
        global Member(String label, String value) {
            this.label = label;
            this.value = value;
        }
        global Member(String label, String value, String type, String dataType) {
            this.label = label;
            this.value = value;
            this.dataType = dataType;
            this.type = type;
        }
    }
}