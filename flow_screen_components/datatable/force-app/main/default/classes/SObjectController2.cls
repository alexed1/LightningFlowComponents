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
 * 01/06/21 -   Eric Smith -    Version 3.0.6   Handle Textarea as Richtext
 * 
 * 12/30/20 -   Eric Smith -    Version 3.0.5   Remove Field Names from Empty Table Header
 * 
 * 12/14/20 -   Eric Smith -    Version 3.0.0   Return object plural name and icon name to the CPE
 * 
 * 10/07/20 -   Eric Smith -    Version 2.46    Issue error if no field names are given
 *                                              Allow case insensitive field names
 *                                              Allow custom field API names w/o the __c suffix
 *                                              Get and Return which fields are picklist fields along with Value & Label
 * 
 * 09/22/20 -   Eric Smith -    Version 2.45    Set type as Richtext for Text Formula Fields
 * 
 * 09/01/20 -   Eric Smith -    Version 2.43    Update Percent Field Handling and set Formula Fields to be Non-Editable 
 * 
 * 08/26/20 -   Eric Smith -    Version 2.42    Get and return User's Timezone Offset so Time fields can be adjusted
 * 
 * 07/07/20 -   Eric Smith -    Version 2.37    Fixed date displaying as a day earlier
 * 
 * 07/01/20 -   Eric Smith -    Version 2.36    Added a return value for the "Name" field of the SObject
 *                                              This is used to display that field as a Link in the Datatable
 * 
 * 06/19/20 -   Eric Smith -    Version 2.33    Fixed issue with lookup fields being blank in the first record
 *                                              Renumbered to match datatableV2 versioning
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
        Map<String, Map<String,String>> picklistFieldMap;   // Field API Name, <Picklist Value, Picklist Label>
        List<String> percentFieldList;
        List<String> noEditFieldList;
        list<String> timeFieldList;
        list<String> picklistFieldList;
        String objectName;
        String objectLinkField;
        String timezoneOffset;
    }

    public class CPEReturnResults { 
        String objectLabel;
        String objectPluralLabel;
        String objectIconName;
    }

    @AuraEnabled
    public static string getCPEReturnResults(String objName){
        // Get info about the object to pass back to the CPE
        CPEReturnResults cpeRR = new CPEReturnResults();
        SObjectType sobjType = ((SObject)(Type.forName('Schema.'+objName).newInstance())).getSObjectType();
        DescribeSObjectResult objDescribe = sobjType.getDescribe();
        cpeRR.objectLabel = objDescribe.getLabel();
        cpeRR.objectPluralLabel = objDescribe.getLabelPlural();
        cpeRR.objectIconName = getIconName(objName);
        System.Debug('cpeRR - '+JSON.serializePretty(cpeRR));
        return JSON.serialize(cpeRR);
    }

    @AuraEnabled
    public static string getReturnResults(List<SObject> records, String fieldNames){
        System.Debug('records-'+records);
        System.Debug('fieldNames-'+fieldNames);
        ReturnResults curRR = new ReturnResults();
        if (records.isEmpty()) {
            // throw new MyApexException ('The datatable record collection is empty');
            List<String> emptyList = new List<String>();
            // curRR.dtableColumnFieldDescriptorString = '{"label":"Empty Table, Fields ['+fieldNames+']", "fieldName":"Id", "type":"text"}';   // Removed field names in v3.0.5
            curRR.dtableColumnFieldDescriptorString = '{"label":"Empty Table", "fieldName":"Id", "type":"text"}';
            curRR.lookupFieldData = '{}';
            curRR.lookupFieldList = emptyList;
            curRR.percentFieldList = emptyList;
            curRR.noEditFieldList = emptyList;
            curRR.timeFieldList = emptyList;
            curRR.picklistFieldList = emptyList;
            curRR.rowData = records;
            curRR.objectName = 'EmptyCollection';
            curRR.objectLinkField = '';
        } else {           
            String objName = records[0].getSObjectType().getDescribe().getName();
            curRR = getColumnData(curRR, fieldNames, objName);
            curRR = getLookupData(curRR, records, curRR.lookupFieldList, objName);
            curRR = getRowData(curRR, records, curRR.dataMap, curRR.objNameFieldMap, curRR.lookupFieldList, curRR.percentFieldList, objName, curRR.noEditFieldList);
            curRR.objectName = objName;
        }
        curRR.timezoneOffset = getTimezoneOffset().format();
        System.Debug('curRR - '+JSON.serializePretty(curRR));
        return JSON.serialize(curRR);  
    }

    @AuraEnabled
    public static ReturnResults getColumnData(ReturnResults curRR, String fields, String objName) {

        if (fields == '') 
            throw new MyApexException('You must specify at least one field API name from the object ' + objName);

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
        List<String> picklistFields = new List<String>();
        Map<String, Map<String, String>> picklistFieldLabels = new Map<String, Map<String, String>>();
        String objectLinkField = getNameUniqueField(objName);   // Name (link) Field for the Datatable SObject
        System.debug('*** OBJ/LINK' + objname + '/' + objectLinkField);

        for (String fieldName : fields.split(',')) {

            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            Schema.SObjectField fieldItem = fieldMap.get(fieldName);
            if (fieldItem == null) {
                Schema.SObjectField fieldItem2 = fieldMap.get(fieldName + '__c');  // Allow for user to forget to add __c for custom fields
                if (fieldItem2 == null) {
                    throw new MyApexException('Could not find the field: ' + fieldName + ' on the object ' + objName);
                } else {
                    fieldItem = fieldItem2;
                }
            }
            Schema.DescribeFieldResult dfr = fieldItem.getDescribe();
            curFieldDescribes.add(dfr);

            datatableColumnFieldDescriptor = datatableColumnFieldDescriptor 
                + ',{"label" : "' + dfr.getLabel() 
                + '", "fieldName" : "' + dfr.getName()      // pass back correct API name if user did not pass in correct case (Name vs name)
                + '", "type" : "' + convertType(dfr.getType().name(), dfr.isCalculated()) 
                + '", "scale" : "' + dfr.getScale() 
                + '"}';

            if (!dfr.isUpdateable() || dfr.isCalculated()) noEditFields.add(fieldName);  // Check for Read Only and Formula fields

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
                    if (!dfr.isSortable() && !noEditFields.contains(fieldName)) {
                        noEditFields.add(fieldName); // Long Text Area and Rich Text Area   
                    }                   
                }
                when 'ENCRYPTEDSTRING' {
                    if (!noEditFields.contains(fieldName)) {
                        noEditFields.add(fieldName);
                    }
                }
                when 'CURRENCY', 'DECIMAL', 'DOUBLE', 'INTEGER', 'LONG' {
                    // *** create scale attrib in datatableColumnFieldDescriptor and pass the getScale() values in that way. ***
                }
                when 'TIME' {
                    timeFields.add(fieldName);
                }
                when 'PICKLIST', 'MULTIPICKLIST' {
                    picklistFields.add(dfr.getName());
                    if (!noEditFields.contains(fieldName)) {
                        noEditFields.add(fieldName);
                    }
                    Map<String, String> valueLabelPair = new Map<String, String>();
                    for(Schema.PicklistEntry ple : dfr.getPicklistValues()) {
                        valueLabelPair.put(ple.getValue(), ple.getLabel());
                    }
                    picklistFieldLabels.put(dfr.getName(), valueLabelPair);
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
        curRR.picklistFieldList = picklistFields;
        curRR.picklistFieldMap = picklistFieldLabels;
        curRR.objectLinkField = objectLinkField;
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
                    String relObjName = lrid.getSObjectType().getDescribe().getName();
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
    public static ReturnResults getRowData(ReturnResults curRR, List<SObject> records, Map<String, Map<Id, SObject>> dataMap, Map<String, String> objNameFieldMap, List<String> lookupFields, List<String> percentFields, String objName, List<String> noEditFields) {
        // Update object to include values for the "Name" field referenced by Lookup fields
        String lookupFieldData = '';
        Map<String,Boolean> firstRecord = new Map<String,Boolean>();
        for(String lf : lookupFields) {
            firstRecord.put(lf,true);
        }

        for(SObject so : records) {   
            
            // Divide percent field values by 100
            // for(String pf : percentFields) {
            //     if(so.get(pf) != null && !noEditFields.contains(pf)) {
            //         so.put(pf, double.valueOf(so.get(pf))/100);
            //     }
            // }

            // Add new lookup field values 
            for(String lf : lookupFields) {         
                if(so.get(lf) != null) {
                    Id lrid = ((Id) so.get(lf));
                    String relObjName = lrid.getSObjectType().getDescribe().getName();
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
                    if(firstRecord.get(lf)) {
                        lookupFieldData = lookupFieldData
                            + ',{ "object" : "' + relObjName
                            + '", "fieldName" : "' + relName
                            + '", "nameField" : "' + objNameFieldMap.get(relObjName)
                            + '"}';
                        firstRecord.put(lf,false);
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
    private static String convertType (String apexType, Boolean isFormula){
        switch on apexType {
            when 'BOOLEAN' {
                return 'boolean';
            }
            when 'CURRENCY' {
                return 'currency';
            }
            when 'DATE' {
                return 'date-local';
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
            when 'CHECKBOX' {
                return 'checkbox';
            }
            when 'TEXTAREA' {
                return 'richtext';
            }
            when 'STRING' {
                if (isFormula) return 'richtext';
                return 'text';
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

    // Get the offset value between GMT and the running User's timezone
    private static integer getTimezoneOffset() {
        Datetime dtNow = Datetime.now();
        return UserInfo.getTimezone().getOffset(dtNow);
    }

    // Get the icon name for the selected object
    // Thanks to Satya.2020 (https://developer.salesforce.com/forums/?id=9062I000000IQ3eQAG)
    private static String getIconName(String sObjectName){
        system.debug('Getting Icon for: '+sObjectName);
        String iconName;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    iconName = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                iconName = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        system.debug('iconName: '+iconName);
        return iconName;
    }

}