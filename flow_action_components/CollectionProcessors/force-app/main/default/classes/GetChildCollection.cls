global with sharing class GetChildCollection {
    //    get the type of the input record
    //    get the child relationships of that type
    //    find the relationship that has the object type OpportunityContactRole (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getChildSObject)
    //    query for all of that object where the field *getField()* (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getField) is equal to the id of the record

    @InvocableMethod(
        label='Get Child Collection [USF Collection Processor]'
        category='Util'
        iconName='resource:CollectionProcessorsSVG:colproc'
    )
    global static List<Results> get(List<Request> requestList) {
        List<Results> responseWrapper = new List<Results>();

        Results response = new Results();
        for (Request curRequest : requestList) {
            response = new Results();
            SObject inputRecord = curRequest.inputRecord;
            String inputRecordId = curRequest.inputRecordId;

            SObjectType parentSobjType;
            String childSobjTypeName;
            String lookupFieldName;

            try {
                // Get the parent SObjectType based on the incoming ID/record
                if (inputRecordId == null) {
                    // If we haven't received a record ID or record
                    if (inputRecord == null) {
                        throw new InvocableActionException(
                            'You need to pass either a record or a recordId into this action, representing the entity you want to start with'
                        );
                    }
                    parentSobjType = inputRecord.getSObjectType();
                    inputRecordId = inputRecord.Id;
                } else {
                    // If we received both a record ID and a record
                    if (inputRecord != null) {
                        throw new InvocableActionException(
                            'You need to pass either a record or a recordId into this action, but you can not pass both'
                        );
                    }
                    parentSobjType = Id.valueOf(inputRecordId).getSObjectType();
                }
                System.debug(
                    'Made it through validation; parentSobjType is ' +
                        parentSobjType +
                        '; inputRecordId is ' +
                        inputRecordId
                );
                for (
                    ChildRelationship curChildRel : parentSobjType.getDescribe()
                        .getChildRelationships()
                ) {
                    String curChildRelName = curChildRel.getRelationshipName();
                    System.debug('curChildRelName: ' + curChildRelName);
                    String curChildObjName = curChildRel.getChildSObject()
                        .getDescribe()
                        .getName();
                    System.debug('curChildObjName: ' + curChildObjName);

                    // If the provided childRelationshipName matches either the
                    // API name of the child relationship OR the API name of the
                    // child SObject, use this relationship
                    if (
                        curRequest.childRelationshipName == curChildRelName ||
                        curRequest.childRelationshipName == curChildObjName
                    ) {
                        lookupFieldName = curChildRel.getField()
                            .getDescribe()
                            .getName();
                        childSobjTypeName = curChildObjName;
                        break;
                    }
                }
                if (lookupFieldName == null)
                    throw new InvocableActionException(
                        'Did not find the relationship ' +
                            curRequest.childRelationshipName +
                            ' on the passed in record or id'
                    );

                // query for all of that object where the field *getField()* (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getField) is equal to the id of the record
                String qry =
                    'SELECT ' +
                    curRequest.childRecordFieldsCSV +
                    ' FROM ' +
                    childSobjTypeName +
                    ' WHERE ' +
                    lookupFieldName +
                    ' = \'' +
                    inputRecordId +
                    '\'';
                System.debug('query is: ' + qry);

                response.childCollection = Database.query(qry);
                System.debug('childCollection is: ' + response.childCollection);
            } catch (Exception e) {
                response.errorText = e.getMessage();
                System.debug('error is: ' + e.getMessage());
            }
        }
        responseWrapper.add(response);
        return responseWrapper;
    }

    global class InvocableActionException extends Exception {
    }

    global class Request {
        @InvocableVariable
        global SObject inputRecord;

        @InvocableVariable
        global String inputRecordId;

        @InvocableVariable
        global String childRelationshipName;

        @InvocableVariable
        global String childRecordFieldsCSV;
    }

    global class Results {
        public Results() {
            childCollection = new List<SObject>();
        }

        @InvocableVariable
        global List<SObject> childCollection;

        @InvocableVariable
        global String errorText;
    }
}
