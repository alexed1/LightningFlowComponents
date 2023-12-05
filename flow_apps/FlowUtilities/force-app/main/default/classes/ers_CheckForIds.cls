/** 
 *  Check Flow Metadata for possible hard-coded recordIds Flow Action
 * 
 *  Eric Smith - 4/5/23 - v1.0
 * 
 *  This class is designed to identify potential hard-coded recordIds in flow metadata
 *  
 *  It takes a collection of Flow OneView records for input and returns a collection of Flow OneView records that may contain hard-coded Ids
 *  
 * 
**/ 

global inherited sharing class ers_CheckForIds {

    // Attributes passed in from the Flow
    global class Requests {
    
        @InvocableVariable(Label='Flow OneView Resource/Node Records')
        global List<SObject> sourceRecords;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(Label='Flow OneView Hard-Coded Id Records') 
        global List<SObject> hardcodeRecords;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Check Flow Resources/Nodes for Hard-Coded Ids by Eric Smith' iconName='resource:CheckIdSVG:Layer_1')
    global static List<Results> checkForIds(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            List<SObject> sourceRecords = req.sourceRecords;

            // Set Output Value(s)
            List<SObject> hardcodeRecords = new List<SObject>();

            // Set initial values

            Boolean FORWARD = false;
            Boolean REVERSE = true;

            List <Map<String,String>> delimiterMap = new List <Map<String,String>> {
                new Map<String,String>{'dStart'=>'<stringValue>', 'dEnd'=>'</stringValue>'},
                new Map<String,String>{'dStart'=>'&quot;', 'dEnd'=>'&quot;'},
                new Map<String,String>{'dStart'=>'&apos;', 'dEnd'=>'&apos;'},
                new Map<String,String>{'dStart'=>'"', 'dEnd'=>'"'},
                new Map<String,String>{'dStart'=>'\'', 'dEnd'=>'\''}
            };

            sliceResults slr = new sliceResults();
            idResults idr = new idResults();

            String workingMetadata = '';
            Boolean notFound = false;
            String checkString = '';

            ID fovId = [SELECT Id FROM Flow_OneView__c LIMIT 1].Id;
            String dummyIdString = (Id)fovId;
            String dummyIdPrefix = dummyIdString.left(10);
            String dummyIdSequence = '';
            Integer recordCounter = 0;

            List<Sobject> colResources = new List<Sobject>();
            SObject emptyResource = [SELECT Id, Resource_name__c, Resource_Type__c FROM Flow_OneView__c LIMIT 1];
            emptyResource.put('Resource_name__c', '');
            emptyResource.put('Resource_Type__c', '');
            Sobject resource = emptyResource;

            // Process input attributes
            
            // Validate input attributes

// BEGIN APEX ACTION PROCESSING LOGIC

            // Define working variables

            // Start processing

            if (sourceRecords != null && !sourceRecords.isEmpty()) {

                for (SObject rec : sourceRecords) {

                    for (Map<String,String> delimiters : delimiterMap) {

                        workingMetadata = String.valueOf(rec.get('Resource_Metadata__c'));

                        // Find Possible Id
                        notFound = false;
                        while (workingMetadata?.length() > 14 && !notFound) {
                            resource  = new Flow_OneView__c();
                            slr = sliceText(delimiters.get('dStart'), delimiters.get('dEnd'), workingMetadata, FORWARD);
                            notFound = slr.notFound;
                            workingMetadata = slr.textAfter;
                            checkString = slr.textInner;

                            // Next Step?
                            if (!notFound && idLength(slr.textInner)) { // FOUND POSSIBLE
                                idr = checkId(checkString, resource);

                                // Check Id Result?
                                if (idr.isRecordId) { // POSSIBLE ID
                                    // Add Possible Id Record
                                    resource.put('Message__c', ttHardCodedId(String.valueOf(rec.get('Resource_Type__c')), checkString, idr.sobjectType));
                                    resource.put('isHardCoded__c', true);

                                    // Assign record id
                                    dummyIdSequence = String.valueOf(recordCounter + 100000).right(5);
                                    resource.put('Id', dummyIdPrefix + dummyIdSequence);

                                    // Copy fields
                                    resource.put('Resource_name__c', rec.get('Resource_name__c'));
                                    resource.put('Resource_Type__c', rec.get('Resource_Type__c'));
                                    resource.put('dataType__c', rec.get('dataType__c'));
                                    resource.put('DataType_Display__c', rec.get('DataType_Display__c'));
                                    resource.put('Display_Value__c', rec.get('Display_Value__c'));

                                    // Add Resource Record
                                    colResources.add(resource);

                                    // Increment Counter
                                    recordCounter ++;
                                }
                            }

                        }
                    }
                }
            }

// END APEX ACTION PROCESSING LOGIC

            // Set Output Values
            response.hardcodeRecords = colResources;
            responseWrapper.add(response);

        }

        // Return values back to the Flow
        return responseWrapper;
    }

    public class sliceResults {
        Boolean notFound;
        String textBefore;
        String textExtract;
        String textInner;
        String textAfter;
    }

    public static sliceResults sliceText(String sStart, String sEnd, String source, Boolean reverse) {

        Invocable.Action slice = Invocable.Action.createCustomAction('apex', 'ers_SliceText');

        slice.setInvocationParameter('searchBegin', sStart);
        slice.setInvocationParameter('searchEnd', sEnd);
        slice.setInvocationParameter('sourceText', source);
        slice.setInvocationParameter('reverseSearch', reverse);

        List<Invocable.Action.Result> results = slice.invoke();  

        sliceResults sr = new sliceResults();

        if (results.size() > 0 && results[0].isSuccess()) {
            sr.notFound = Boolean.valueOf(results[0].getOutputParameters().get('notFound'));
            sr.textBefore = String.valueOf(results[0].getOutputParameters().get('textBefore'));
            sr.textExtract = String.valueOf(results[0].getOutputParameters().get('textExtract'));
            sr.textInner = String.valueOf(results[0].getOutputParameters().get('textInner'));
            sr.textAfter = String.valueOf(results[0].getOutputParameters().get('textAfter'));
        }

        return sr;

    }

    public class idResults {
        Boolean isRecordId;
        String sobjectType;
    }

    public static idResults checkId(String recordId, SObject dummyRecord) {

        Invocable.Action check = Invocable.Action.createCustomAction('apex', 'ers_CheckId');

        check.setInvocationParameter('recordId', recordId);
        check.setInvocationParameter('dummyRecord', dummyRecord);

        List<Invocable.Action.Result> results = check.invoke();  

        idResults cid = new idResults();

        if (results.size() > 0 && results[0].isSuccess()) {
            cid.isRecordId = Boolean.valueOf(results[0].getOutputParameters().get('isRecordId'));
            cid.sobjectType = String.valueOf(results[0].getOutputParameters().get('sobjectType'));
        }

        return cid;

    }

    public static boolean idLength(String check) {
        return (check.length() == 15 || check.length() == 18);
    }

    public static String ttHardCodedId(String mdType, String idValue, String objType) {
        String msg = '<p>This ';
        msg += mdType;
        msg += ' contains a possible hard-coded recordId (<strong>';
        msg += idValue;
        msg += '</strong>) from the <strong>';
        msg += objType;
        msg += '</strong> object.</p>';
        return msg;
    }
}