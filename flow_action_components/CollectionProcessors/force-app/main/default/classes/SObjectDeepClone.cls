// Author Charlie Jonas (charlie@callaway.cloud)
// Class to clone an SObject and it's children.
//   - Not currently optimized for bulk use!
//   See https://github.com/ChuckJonas/SObjectDeepClone for readme
public with sharing class SObjectDeepClone {
    @TestVisible
    private static final Map<Schema.SObjectType, List<String>> NULLABLE_FIELDS = new Map<Schema.SObjectType, List<String>>{
            //the purpose of this was to get around a problem created when the calculated TotalPrice field gets cloned. 
            
            //this fix turns out not to work. setting TotalPrice to null creates a separate error. ultimately, the solution was to set TotalPrice to empty string
            /* Schema.OpportunityLineItem.getSObjectType() => new List<String>{
                    'TotalPrice'
            } */
    };

    private Map<String, ChildRelationshipProps> relationshipMap;
    private SObjectType type;

    //The SObject that will be cloned. Accessible so modications can be made prior to saving
    public SObject clone;
    public Boolean saveChildRecordsAutomatically = true;
    public Map<String, List<SObject>> clonedChildrenPerTypeMap;
    private Map<Schema.SObjectType, Map<String, Schema.SObjectField>> sObjectFields = new Map<Schema.SObjectType, Map<String, Schema.SObjectField>>();
    /**
      * @description Constructor to query object
      * @param toCloneId: Id to clone.  All creatable fields will be pulled
      * @param relationshipsToClone: Child Relationship names
      * @param saveChildRecordsAutomatically: determines if we are going to save the child records
      */
    public SObjectDeepClone(Id toCloneId, Set<String> relationshipsToClone, Boolean saveChildRecordsAutomatically) {
        this.type = toCloneId.getSObjectType();
        this.saveChildRecordsAutomatically = saveChildRecordsAutomatically;
        mapStringsToRelations(relationshipsToClone);
        retrieveSObject(toCloneId);
    }

    /**
      * @description Constructor without object query.  Allows more control of cloning
      * @param toClone: SObject to clone.  Must include all relevant information
      * @param relationshipsToClone: Child Relationship names
      * @param saveChildRecordsAutomatically: determines if we are going to save the child records
    */
    public SObjectDeepClone(SObject toClone, Set<String> relationshipsToClone, Boolean saveChildRecordsAutomatically) {
        this.type = toClone.getSObjectType();
        this.saveChildRecordsAutomatically = saveChildRecordsAutomatically;
        mapStringsToRelations(relationshipsToClone);
        this.clone = toClone;
    }

    /**
      * @description Saves the Cloned SObject
      * @return The Id of the cloned SObject
      */
    public Id save() {
        if (!sObjectFields.containsKey(this.type)) {
            sObjectFields.put(this.type, this.type.getDescribe().fields.getMap());
        }
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {
            if (clone.Id != null) {
                clone.Id = null;
            }
            markAsCloned(clone);
            
            //insert clone without triggering duplicate rules            
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true; Database.SaveResult sr = Database.insert(clone, dml);

            clonedChildrenPerTypeMap = new Map<String, List<SObject>>();
            for (String relationshipName : this.relationshipMap.keySet()) {
                if (!clonedChildrenPerTypeMap.containsKey(relationshipName)) {
                    clonedChildrenPerTypeMap.put(relationshipName, new List<SObject>());
                }
                ChildRelationshipProps rel = this.relationshipMap.get(relationshipName);
                for (Sobject child : clone.getSObjects(relationshipName)) {
                    SObject childClone = child.clone(false);
                    markAsCloned(childClone);
                    childClone.put(rel.field, clone.Id);
                    clonedChildrenPerTypeMap.get(relationshipName).add(childClone);
                }
            }
            if (saveChildRecordsAutomatically && !clonedChildrenPerTypeMap.isEmpty()) {
                for (String relationshipName : clonedChildrenPerTypeMap.keySet()) {
                    System.debug('cloned children are: ' + clonedChildrenPerTypeMap);
                    insert clonedChildrenPerTypeMap.get(relationshipName);
                }
            }

        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }

        return clone.Id;
    }

    private void markAsCloned(SObject so) {
        //Fields to check if we can add "Cloned" stamp
        List<String> fieldsToCheck = new List<String>{
                'Name', 'Subject', 'FirstName', 'LastName'
        };
        SObjectType curType = so.getSObjectType();

        if (!this.sObjectFields.containsKey(curType)) {
            this.sObjectFields.put(curType, curType.getDescribe().fields.getMap());
        }

        for (String curFieldName : fieldsToCheck) {
            if (this.sObjectFields.get(curType).containsKey(curFieldName.toLowerCase())) {
                if (so.get(curFieldName) != null && this.sObjectFields.get(curType).get(curFieldName.toLowerCase()).getDescribe().isUpdateable()) {
                    String curName = (String) so.get(curFieldName);
                    so.put(curFieldName, curName + ' Clone ' + Datetime.now().format('MM/dd/yyyy H:mm'));
                    break;
                }
            }
        }
        if (NULLABLE_FIELDS != null) {
            for (SObjectType curNullableType : NULLABLE_FIELDS.keySet()) {
                if (curType == curNullableType) {
                    for (String curNullableField : NULLABLE_FIELDS.get(curNullableType)) {
                        if (this.sObjectFields.get(curType).containsKey(curNullableField.toLowerCase())) {
                            so.put(curNullableField, null);
                        }
                    }
                }
            }
        }
    }


    private void mapStringsToRelations(Set<String> relationshipStrings) {
        this.relationshipMap = new Map<string, ChildRelationshipProps>();
        Map<String, ChildRelationship> childRelationMap = new Map<String, ChildRelationship>();
        for (ChildRelationship rel : type.getDescribe().getChildRelationships()) {
            String relName = rel.getRelationshipName();
            if (relName != null) { //not sure why this would happen but it does
                childRelationMap.put(rel.getRelationshipName().toUpperCase(), rel);
            }
        }

        for (String relStr : relationshipStrings) {
            relStr = relStr.toUpperCase();
            if (childRelationMap.containsKey(relStr)) {
                ChildRelationship rel = childRelationMap.get(relStr);
                relationshipMap.put(rel.getRelationshipName().toUpperCase(), new ChildRelationshipProps(rel));
            } else {
                throw new DeepCloneException(
                        'Child Relationship \'' + relStr + '\' does not exsist on ' + type.getDescribe().getName()
                );
            }
        }
    }

    private void retrieveSObject(Id toCloneId) {
        // Get a map of field name and field token
        String[] selectFields = getCreatableFields(type);

        //subqueries
        for (String relationName : this.relationshipMap.keySet()) {
            ChildRelationshipProps rel = this.relationshipMap.get(relationName);
            String[] relationFields = getCreatableFields(rel.sObjectType);
            if (relationFields.size() > 0) {
                selectFields.add('(' + buildQuery(relationFields, relationName, null) + ')');
            }
        }

        String qry = buildQuery(
                selectFields,
                type.getDescribe().getName(),
                'ID = \'' + String.escapeSingleQuotes(toCloneId) + '\''
        );

        this.clone = ((SObject) Database.query(qry)).clone(false);
    }

    private string buildQuery(String[] fields, String fromObj, string whereClause) {
        String qry = 'SELECT ' + String.join(fields, ',') + ' FROM ' + fromObj;
        if (!String.isEmpty(whereClause)) {
            qry += ' WHERE ' + whereClause;
        }
        return qry;
    }

    private String[] getCreatableFields(SObjectType objType) {
        DescribeSObjectResult describe = objType.getDescribe();

        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = describe.Fields.getMap();
        String[] selectFields = new String[]{
        };

        if (fMap != null) {
            for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()) { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        return selectFields;
    }

    //seralizable subset of ChildRelationship properties that we need
    private class ChildRelationshipProps {
        public SObjectType sObjectType;
        public SObjectField field;
        public ChildRelationshipProps(ChildRelationship rel) {
            this.sObjectType = rel.getChildSObject();
            this.field = rel.getField();
        }
    }

    public class DeepCloneException extends Exception {
    }
}
