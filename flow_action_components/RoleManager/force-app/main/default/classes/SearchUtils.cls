global with sharing class SearchUtils {

    static final Map<String, String> TYPE_TO_SOBJECT = new Map<String, String>{
            'User' => 'User',
            'Role_subordinates' => 'UserRole',
            'Role' => 'UserRole',
            'Group' => 'Group',
            'Queue' => 'Group',
            'Creator' => 'User'
    };

    static final Map<String, String> TYPE_TO_QUERY_CRITERIA = new Map<String, String>{
            'User' => 'WHERE IsActive = true AND Name LIKE (searchString)',
            'Role_subordinates' => 'WHERE Name LIKE (searchString)',
            'Role' => 'WHERE Name LIKE (searchString)',
            'Group' => 'WHERE (Type = \'Public\' OR Type = \'Regular\') AND Name LIKE (searchString)',
            'Queue' => 'WHERE Type = \'Queue\' AND Name LIKE (searchString)'
    };

    static final List<String> OTHER_TYPES = new List<String>{
            'RelatedUsers', 'Owner'
    };


    @AuraEnabled(cacheable=true)
    public static Map<String, List<Member>> searchMemberByType(List<String> memberTypes, String searchString) {
        Map<String, List<Member>> resultMap = new Map<String, List<Member>>();

        for (String curType : TYPE_TO_SOBJECT.keySet()) {

            if (!memberTypes.contains(curType)) {
                continue;
            }
            String queryString = 'SELECT Id, Name FROM ' + TYPE_TO_SOBJECT.get(curType) + ' ' + TYPE_TO_QUERY_CRITERIA.get(curType).replace('(searchString)', '\'%' + String.escapeSingleQuotes(searchString) + '%\'');

            List<SObject> types = Database.query(queryString);
            List<Member> members = new List<Member>();
            for (SObject t : types) {
                members.add(new Member((String) t.get('Name'), (String) t.get('Id')));
            }
            resultMap.put(curType, members);
        }

        return resultMap;
    }
    public static Map<String, String> getMembersByTypeAndId(Map<String, Set<String>> typeToIds) {

        Map<String, String> results = new Map<String, String>();
        for (String sObjectTypeName : typeToIds.keySet()) {
            if (OTHER_TYPES.contains(sObjectTypeName)) {
                for (String curMember : typeToIds.get(sObjectTypeName)) {
                    results.put(curMember, curMember);
                }
            } else {
                Set<String> objectIds = typeToIds.get(sObjectTypeName);
                String queryString = 'SELECT Id, Name FROM ' + TYPE_TO_SOBJECT.get(sObjectTypeName) + ' WHERE Id IN: objectIds';

                List<SObject> members = Database.query(queryString);
                for (SObject curMember : members) {
                    results.put((String) curMember.get('Id'), (String) curMember.get('Name'));
                }
            }
        }
        return results;
    }

    global class Member {
        @AuraEnabled global String label;
        @AuraEnabled global String value;
        public Member(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}