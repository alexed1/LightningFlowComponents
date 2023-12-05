/** 
 *  Process Flow Metadata and create a Flow OneView record for each Flow Resource
 * 
 *  Eric Smith - 4/6/23 - v1.0
 * 
 *  This class is designed to extract individual flow resources from flow metadata
 *  
 *  It takes a flow XML string and returns Flow OneView records for each resource
 *  
 * 
**/ 

global inherited sharing class ers_ProcessFlowResources {

    // Attributes passed in from the Flow
    global class Requests {
    
        @InvocableVariable(Label='Flow Metadata')
        global String sourceMetadata;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(Label='Flow OneView Resource Records') 
        global List<SObject> resourceRecordCollection;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Process Flow Resources/Nodes by Eric Smith' iconName='resource:ProcessResourceSVG:OneView')
    global static List<Results> processResources(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            String originalSourceMetadata = req.sourceMetadata;

            // Set Output Value(s)
            List<SObject> resourceRecordCollection = new List<SObject>();

            // Set initial values
            Boolean FORWARD = false;
            Boolean REVERSE = true;

            List <String> resourceTypes = new List <String> {
                'variables',
                'formulas',
                'textTemplates',
                'constants',
                'choices',
                'dynamicChoiceSets',
                'stages'
            };

            sliceResults rbs = new sliceResults();
            sliceResults rbe = new sliceResults();
            sliceResults slr = new sliceResults();

            // Define working variables
            Integer recordCounter = 0;
            String sourceMetadata = originalSourceMetadata;
            String workingMetadata = '';
            Boolean notFound = false;
            String before = '';
            String extract = '';
            String resource = '';
            String tInner = '';
            String after = '';
            ID fovId = [SELECT Id FROM Flow_OneView__c LIMIT 1].Id;
            String dummyIdString = (Id)fovId;
            String dummyIdPrefix = dummyIdString.left(10);
            String dummyIdSequence = '';
            String dispValue = '';

            List<Sobject> colResources = new List<Sobject>();
            SObject emptyResource = [SELECT Id, Resource_name__c, Resource_Type__c FROM Flow_OneView__c LIMIT 1];
            emptyResource.put('Resource_name__c', '');
            emptyResource.put('Resource_Type__c', '');
            SObject objResource  = emptyResource;

            // Validate input attributes
            if (sourceMetadata != null && sourceMetadata.length() > 0) {

// BEGIN APEX ACTION PROCESSING LOGIC

                // Process Resource Types
                for (String resType : resourceTypes) {

                    // Get Resource Block Start
                    rbs = sliceText(ttStart(resType), null, sourceMetadata, FORWARD);
                    // Get Resource Block End
                    rbe = sliceText(ttEnd(resType), null, rbs.textAfter, REVERSE);
                    // Assign Working Metadata
                    workingMetadata = rbs.textExtract + rbe.textBefore + rbe.textExtract;
                    // Reset search flag
                    notFound = false;

                    // --- Process Resource ---
                    while (!notFound) {

                        objResource  = new Flow_OneView__c();
                        
                        // Extract Resource
                        slr = new sliceResults();
                        slr = sliceText(ttStart(resType), ttEnd(resType), workingMetadata, FORWARD);
                        if (slr.textInner != null && slr.textInner.length() > 0) {   // FOUND
                            notFound = false;
                            before = slr.textBefore;
                            extract = slr.textExtract;
                            resource = slr.textInner;
                            after = slr.textAfter;

                            // Save Resource True/False Attributes
                            objResource.put('isInput__c', resource.indexOf('<isInput>true</isInput>') <> -1);
                            objResource.put('isOutput__c', resource.indexOf('<isOutput>true</isOutput>') <> -1);
                            objResource.put('isViewedAsPlainText__c', resource.indexOf('<isViewedAsPlainText>true</isViewedAsPlainText>') <> -1);
                            objResource.put('isCollection__c', resource.indexOf('<isCollection>true</isCollection>') <> -1);
                            objResource.put('isResource__c', true);

                            // Extract & Assign various attributes
                            slr = new sliceResults();
                            slr = sliceText('<name>', '</name>', resource, FORWARD);
                            objResource.put('Resource_name__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<dataType>', '</dataType>', resource, FORWARD);
                            objResource.put('dataType__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<apexClass>', '</apexClass>', resource, FORWARD);
                            objResource.put('apexClass__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<description>', '</description>', resource, FORWARD);
                            objResource.put('description__c', unescape(slr.textInner));
                            slr = new sliceResults();
                            slr = sliceText('<expression>', '</expression>', resource, FORWARD);
                            objResource.put('expression__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<objectType>', '</objectType>', resource, FORWARD);
                            objResource.put('objectType__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<scale>', '</scale>', resource, FORWARD);
                            objResource.put('scale__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<text>', '</text>', resource, FORWARD);
                            objResource.put('text__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<value>', '</value>', resource, FORWARD);
                            tInner = slr.textInner;
                            slr = new sliceResults();
                            slr = sliceText('>', '</', tInner, FORWARD);
                            objResource.put('value__c', slr.textInner);

                            // Save additional extracted details
                            objResource.put('Resource_Type__c', resType);
                            objResource.put('Resource_Metadata__c', extract);

                            // Assign record id
                            dummyIdSequence = String.valueOf(recordCounter + 100000).right(5);
                            objResource.put('Id', dummyIdPrefix + dummyIdSequence);

                            // Assign Display Values
                            switch on resType {
                                when 'textTemplates' {
                                    dispValue = String.valueOf(objResource.get('text__c'));
                                }
                                when 'formulas' {
                                    dispValue = String.valueOf(objResource.get('expression__c'));
                                }
                                when else {
                                    dispValue = String.valueOf(objResource.get('value__c'));
                                }
                            }
                            objResource.put('Display_Value__c', unescape(dispValue));
                            objResource.put('Display_Rich_Text_Value__c', unescape(dispValue));

                            // Save Record and Reset Work Metadata
                            workingMetadata = before + after;
                            colResources.add(objResource);

                            // Increment Counter
                            recordCounter ++;

                        } else {    // NOT FOUND

                            notFound = true;

                            // Reduce Source Metadata
                            sourceMetadata = rbs.textBefore + rbe.textAfter;

                        }

                    }

                }

// END APEX ACTION PROCESSING LOGIC

            }

            // Set Output Values
            response.resourceRecordCollection = colResources;
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

    public static String ttStart(String rType) {
        return '<' + rType + '>';
    }

    public static String ttEnd(String rType) {
        return '</' + rType + '>';
    }

    public static String unescape(String text) {
        text = text.replace('&amp;', '&');
        text = text.replace('&lt;', '<');
        text = text.replace('&gt;', '>');
        text = text.replace('&quot;', '"');
        text = text.replace('&apos;', '\'');
        text = text.replace('&lbrace;', '{');
        text = text.replace('&rbrace;', '}');
        return text;
    }

}