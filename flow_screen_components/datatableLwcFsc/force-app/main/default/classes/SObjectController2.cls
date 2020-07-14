/**
 * 
 * Based on a component (ItemsToApprove) created by: Alex Edelstein (Salesforce) 
 * Based on a component (FlatTable) created by: J. Pipkin (OpFocus, Inc)
 * 
 * Description: getColumnData
 *              Get field information from a list of field names in order to build
 *              the column definitions for the datatable
 * 
 *              getLookupData
 *              For each lookup type field get the related object and "Name" field
 * 
 *              getRowData
 *              Take a List of Records and a List of Lookup Field Names and
 *              use the recordId values in the lookup fields get the values
 *              of the Name fields in the corresponding records. Return the
 *              records that now include both the Id and Name for each lookup.
 * 
 * 06/03/20 -   Eric Smith -    Version 2.0     Renamed to allow for easier installation with datatableV2
 * 
 * 04/28/20 -   Eric Smith -    Version 1.2     Handle lookup Objects without a Name field & 
 *                                              Trap non-updatable Master/Detail fields
 * 
 * 04/14/20 -   Eric Smith -    Version 1.1     Cleaned up some error handling
 * 
 * 04/01/20 -   Eric Smith -    Version 1.0
 * 
 **/

public with sharing class SObjectController2 {

    // this is just a convenient way to return multiple unique pieces of data to the component
    public class ReturnResults {
        List<SObject> rowData;
        String dtableColumnFieldDescriptorString;
        String lookupFieldData;
        List<String> lookupFieldList;
        Map<String, Map<Id, SObject>> dataMap;
        Map<String, String> objNameFieldMap;
        List<String> percentFieldList;
        List<String> noEditFieldList;
        list<String> timeFieldList;
        String objectName;
    }

    @AuraEnabled
    public static string getReturnResults(List<SObject> records, String fieldNames){
        System.Debug('records-'+records);
        System.Debug('fieldNames-'+fieldNames);
        ReturnResults curRR = new ReturnResults();
        if (records.isEmpty()) {
            // throw new MyApexException ('The datatable record collection is empty');
            List<String> emptyList = new List<String>();
            curRR.dtableColumnFieldDescriptorString = '{"label":"Empty Table", "fieldName":"Id", "type":"text"}';
            curRR.lookupFieldData = '{}';
            curRR.lookupFieldList = emptyList;
            curRR.percentFieldList = emptyList;
            curRR.noEditFieldList = emptyList;
            curRR.timeFieldList = emptyList;
            curRR.rowData = records;
            curRR.objectName = 'EmptyCollection';
        } else {           
            String objName = records[0].getSObjectType().getDescribe().getName();
            curRR = getColumnData(curRR, fieldNames, objName);
            curRR = getLookupData(curRR, records, curRR.lookupFieldList, objName);
            curRR = getRowData(curRR, records, curRR.dataMap, curRR.objNameFieldMap, curRR.lookupFieldList, curRR.percentFieldList, objName);
            curRR.objectName = objName;
        }
        System.Debug('curRR - '+JSON.serializePretty(curRR));
        return JSON.serialize(curRR);  
    }

    @AuraEnabled
    public static ReturnResults getColumnData(ReturnResults curRR, String fields, String objName) {
        
        SObjectType sobjType = ((SObject)(Type.forName('Schema.'+objName).newInstance())).getSObjectType();
        DescribeSObjectResult objDescribe = sobjType.getDescribe();

        String datatableColumnFieldDescriptor = '';
        String fieldType = '';
        List<Schema.DescribeFieldResult> curFieldDescribes = new List<Schema.DescribeFieldResult>();
        String lookupFieldData = '';
        List<String> lookupFields = new List<String>();
        List<String> percentFields = new List<String>();
        List<String> noEditFields = new List<String>();
        List<String> timeFields = new List<String>();

        for (String fieldName : fields.split(',')) {

            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            Schema.SObjectField fieldItem = fieldMap.get(fieldName);
            if (fieldItem == null) 
                throw new MyApexException('could not find the field: ' + fieldName + ' on the object ' + objName);
            Schema.DescribeFieldResult dfr = fieldItem.getDescribe();
            curFieldDescribes.add(dfr);
            datatableColumnFieldDescriptor = datatableColumnFieldDescriptor 
                + ',{"label" : "' + dfr.getLabel() 
                + '", "fieldName" : "' + fieldName 
                + '", "type" : "' + convertType(dfr.getType().name()) 
                + '", "scale" : "' + dfr.getScale() 
                + '"}';

            switch on dfr.getType().name() {
                when 'REFERENCE' {
                    if (dfr.isUpdateable()) {       // Only works with Master-Detail fields that are reparentable
                        lookupFields.add(fieldName);
                    }
                }
                when 'PERCENT' {
                    percentFields.add(fieldName);
                }
                when 'TEXTAREA' {
                    if (!dfr.isSortable()) noEditFields.add(fieldName); // Long Text Area and Rich Text Area                   
                }
                when 'ENCRYPTEDSTRING', 'PICKLIST', 'MULTIPICKLIST' {
                    noEditFields.add(fieldName);
                }
                when 'CURRENCY', 'DECIMAL', 'DOUBLE', 'INTEGER', 'LONG' {
                    // *** create scale attrib in datatableColumnFieldDescriptor and pass the getScale() values in that way. ***
                }
                when 'TIME' {
                    timeFields.add(fieldName);
                }
                when else {
                }
            }   
        }

        System.debug('final fieldDescribe string is: ' + datatableColumnFieldDescriptor);
        curRR.dtableColumnFieldDescriptorString = datatableColumnFieldDescriptor.substring(1);   // Remove leading ,
        curRR.lookupFieldData = lookupFieldData;
        curRR.lookupFieldList = lookupFields;
        curRR.percentFieldList = percentFields;
        curRR.noEditFieldList = noEditFields;
        curRR.timeFieldList = timeFields;
        return curRR;
    }

    @AuraEnabled
    public static ReturnResults getLookupData(ReturnResults curRR, List<SObject> records, List<String> lookupFields, String objName){

        // Get names of the related objects
        Map<String, Set<Id>> objIdMap = new Map<String, Set<Id>>();
        for(SObject so : records) {
            for(String lf : lookupFields) {
                if(so.get(lf) != null) {
                    Id lrid = ((Id) so.get(lf));
                    String relObjName = lrid.getSobjectType().getDescribe().getName();
                    if(!objIdMap.containsKey(relObjName)) {
                        objIdMap.put(relObjName, new Set<Id>());
                    }
                    objIdMap.get(relObjName).add(lrid);
                }
            }
        }

        // Lookup the "Name" field in the related object 
        Map<String, Map<Id, SObject>> dataMap = new Map<String, Map<Id, SObject>>();
        Map<String, String> objNameFieldMap = new Map<String, String>();
        for(String obj : objIdMap.keySet()) {
            Set<Id> ids = objIdMap.get(obj);
            String nameField = getNameUniqueField(obj);
            SObject[] recs = Database.query('Select Id, ' + nameField + ' from ' + obj + ' where Id in :ids');        
            System.Debug('Name Field: '+obj+' - '+nameField);
            Map<Id, SObject> somap = new Map<Id, SObject>();
            for(SObject so : recs) {
                somap.put((Id) so.get('Id'), so);
            }
            dataMap.put(obj, somap);
            objNameFieldMap.put(obj, nameField);        
        }

        curRR.dataMap = dataMap;
        curRR.objNameFieldMap = objNameFieldMap;
        return curRR;
    }

    @AuraEnabled
    public static ReturnResults getRowData(ReturnResults curRR, List<SObject> records, Map<String, Map<Id, SObject>> dataMap, Map<String, String> objNameFieldMap, List<String> lookupFields, List<String> percentFields, String objName) {
        // Update object to include values for the "Name" field referenced by Lookup fields
        String lookupFieldData = '';
        Boolean firstRecord = true;
        for(SObject so : records) {   
            
            // Divide percent field values by 100
            for(String pf : percentFields) {
                if(so.get(pf) != null) {
                    so.put(pf, double.valueOf(so.get(pf))/100);
                }
            }

            // Add new lookup field values 
            for(String lf : lookupFields) {         
                if(so.get(lf) != null) {
                    Id lrid = ((Id) so.get(lf));
                    String relObjName = lrid.getSobjectType().getDescribe().getName();
                    Map<Id, SObject> recs = dataMap.get(relObjName);
                    if (recs == null) continue;
                    SObject cso = recs.get(lrid);
                    if (cso == null) continue;
                    String relName;                    
                    if (lf.toLowerCase().endsWith('id')) {
                        relName = lf.replaceAll('(?i)id$', '');
                    } else {
                        relName = lf.replaceAll('(?i)__c$', '__r');
                    }
                    so.putSObject(relName, cso);

                    // Save the Object and "Name" field related to the lookup field
                    if(firstRecord) {
                        lookupFieldData = lookupFieldData
                            + ',{ "object" : "' + relObjName
                            + '", "fieldName" : "' + relName
                            + '", "nameField" : "' + objNameFieldMap.get(relObjName)
                            + '"}';
                        firstRecord = false;
                    }
                }
            }
        }

        // return lookup field info and records;
        curRR.lookupFieldData = (lookupFieldData.length() > 0) ? lookupFieldData.substring(1) : '';   // Remove leading ,
        curRR.rowData = records;
        return curRR;
    }

    public class MyApexException extends Exception {
    }

    //convert the apex type to the corresponding javascript type that datatable will understand
    private static String convertType (String apexType){
        switch on apexType {
            when 'BOOLEAN' {
                return 'boolean';
            }
            when 'CURRENCY' {
                return 'currency';
            }
            when 'DATE' {
                return 'date';
            }
            when 'DATETIME' {
                return 'datetime';   // Custom type for this component
            }
            when 'DECIMAL', 'DOUBLE', 'INTEGER', 'LONG' {
                return 'number';
            }
            when 'EMAIL' {
                return 'email';
            }
            when 'ID' {
                return 'id';
            }
            when 'LOCATION' {
                return 'location';
            }
            when 'PERCENT' {
                return 'percent';
            }
            when 'PHONE' {
                return 'phone';
            }
            when 'REFERENCE' {
                return 'lookup';    // Custom type for this component
            }
            when 'TIME' {
                return 'time';      // Custom type for this component
            }
            when 'URL' {
                return 'url';
            }
            when else {
                // throw new MyApexException ('you\'ve specified the unsupported field type: ' + apexType );
                return 'text';
            }
        }
    }
    
    //Get the 'Name' field for the given SObjectType
    private static String getNameUniqueField(String objectName) {
        String strResult = null;
        SObjectType sobjType = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult objDescribe = sobjType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        for(String fieldName : fieldMap.keySet()) {
            SObjectField objField = fieldMap.get(fieldName);
            Schema.DescribeFieldResult dfr = objField.getDescribe();
            if(dfr.isNameField()) {
                strResult = dfr.getName();
                break;
            }
            if(strResult != null) {
                return strResult;
            }
        }
        for(String fieldName : fieldMap.keySet()) {
            SObjectField objField = fieldMap.get(fieldName);
            Schema.DescribeFieldResult dfr = objField.getDescribe();
            if(dfr.isAutoNumber()) {
                strResult = dfr.getName();
                break;
            }
            if(strResult != null) {
                return strResult;
            }        
        }
        for(String fieldName : fieldMap.keySet()) {
            SObjectField objField = fieldMap.get(fieldName);
            Schema.DescribeFieldResult dfr = objField.getDescribe();
            if(dfr.isUnique()) {
                strResult = dfr.getName();
                break;
            }
        }
        return strResult;
    }

}