/** 
 *  Process Flow Metadata and create a Flow OneView record for each Flow Element
 * 
 *  Eric Smith - 6/14/23 - v1.0
 * 
 *  This class is designed to extract individual flow elements from flow metadata
 *  
 *  It takes a flow XML string and returns Flow OneView records for each element
 *  
 * 
**/ 

global inherited sharing class ers_ProcessFlowElements {

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
    @InvocableMethod(label='Process Flow Elements by Eric Smith' iconName='resource:ProcessResourceSVG:OneView')
    global static List<Results> processElements(List<Requests> requestList) {

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

            List <String> elementTypes = new List <String> {
                'start',
                'actionCalls',
                'assignments',
                'collectionProcessors',
                'recordCreates',
                'recordLookups',
                'recordUpdates',
                'recordDeletes',
                'recordRollbacks',
                'subflows',
                'waits',
                'screens',
                'loops',
                'decisions',
                'transforms',
                'customErrors'
            };

            sliceResults rbs = new sliceResults();
            sliceResults rbe = new sliceResults();
            sliceResults slr = new sliceResults();

            // Define working variables
            Integer recordCounter = 0;
            String sourceMetadata = originalSourceMetadata;
            String workingMetadata = '';
            String ruleMetadata = '';
            Boolean notFound = false;
            Boolean lastRule = false;
            Boolean hasFaultConnector = false;
            String before = '';
            String extract = '';
            String resource = '';
            String textInner = '';
            String after = '';
            String rbefore = '';
            String rextract = '';
            String rresource = '';
            String rafter = '';
            ID fovId = [SELECT Id FROM Flow_OneView__c LIMIT 1].Id;
            String dummyIdString = (Id)fovId;
            String dummyIdPrefix = dummyIdString.left(10);
            String dummyIdSequence = '';
            String dispValue = '';
            Integer xVal = 0;
            Integer yVal = 0;
            Integer zVal = 0;
            String nextLoopConnector = '';

            List<Sobject> colElements = new List<Sobject>();
            SObject emptyElement = [SELECT Id, Resource_name__c, Resource_Type__c FROM Flow_OneView__c LIMIT 1];
            emptyElement.put('Resource_name__c', '');
            emptyElement.put('Resource_Type__c', '');
            SObject objElement = emptyElement;
            SObject extraElement = emptyElement;

            // Validate input attributes
            if (sourceMetadata != null && sourceMetadata.length() > 0) {

// BEGIN APEX ACTION PROCESSING LOGIC

                // Process Element Types
                for (String elmType : elementTypes) {

                    // Get Element Block Start
                    rbs = sliceText(ttStart(elmType), null, sourceMetadata, FORWARD);
                    // Get Element Block End
                    rbe = sliceText(ttEnd(elmType), null, rbs.textAfter, REVERSE);
                    // Assign Working Metadata
                    workingMetadata = rbs.textExtract + rbe.textBefore + rbe.textExtract;
                    // Reset search flag
                    notFound = false;

                    // --- Process Element ---
                    while (!notFound) {

                        objElement  = new Flow_OneView__c();
                        
                        // Extract Element
                        slr = new sliceResults();
                        slr = sliceText(ttStart(elmType), ttEnd(elmType), workingMetadata, FORWARD);
                        if (slr.textInner != null && slr.textInner.length() > 0) {   // FOUND
                            notFound = false;
                            before = slr.textBefore;
                            extract = slr.textExtract;
                            resource = slr.textInner;
                            after = slr.textAfter;
                            zVal = 0;

                            // Save Element True/False Attributes
                            objElement.put('isPassed__c', false);
                            objElement.put('isElement__c', true);
                            objElement.put('isOtherConnector__c', false);

                            // Set aside extra connectors
                            switch on elmType {
                                when 'decisions' {
                                    rbs = new sliceResults();
                                    rbs = sliceText('<rules>', null, resource, FORWARD);
                                    rbe = new sliceResults();
                                    rbe = sliceText('</rules>', null, resource, REVERSE);
                                    resource = rbs.textBefore + rbe.textAfter;
                                    zVal = 999;
                                }
                                when 'waits' {
                                    rbs = new sliceResults();
                                    rbs = sliceText('<waitEvents>', null, resource, FORWARD);
                                    rbe = new sliceResults();
                                    rbe = sliceText('</waitEvents>', null, resource, REVERSE);
                                    resource = rbs.textBefore + rbe.textAfter;
                                    zVal = 999;
                                }
                            }

                            // Extract & Assign various attributes
                            slr = new sliceResults();
                            slr = sliceText('<name>', '</name>', resource, FORWARD);
                            objElement.put('Resource_name__c', slr.textInner);
                            slr = new sliceResults();
                            slr = sliceText('<description>', '</description>', resource, FORWARD);
                            objElement.put('description__c', unescape(slr.textInner));
                            slr = new sliceResults();
                            slr = sliceText('<label>', '</label>', resource, FORWARD);
                            objElement.put('Element_label__c', unescape(slr.textInner));
                            slr = new sliceResults();
                            slr = sliceText('<locationX>', '</locationX>', resource, FORWARD);
                            xVal = Integer.valueof(slr.textInner.trim());
                            objElement.put('locationX__c', xVal);
                            slr = new sliceResults();
                            slr = sliceText('<locationY>', '</locationY>', resource, FORWARD);
                            yVal = Integer.valueof(slr.textInner.trim());
                            objElement.put('locationY__c', yVal);
                            objElement.put('CanvasSort__c', buildSortKey(xVal, yVal, Zval));
                            slr = new sliceResults();
                            slr = sliceText('<connector>', '</connector>', resource, FORWARD);
                            objElement.put('connector__c', connector(slr.textInner));
                            slr = new sliceResults();
                            slr = sliceText('<defaultConnector>', '</defaultConnector>', resource, FORWARD);
                            objElement.put('defaultConnector__c', connector(slr.textInner));
                            slr = new sliceResults();
                            slr = sliceText('<faultConnector>', '</faultConnector>', resource, FORWARD);
                            objElement.put('faultConnector__c', connector(slr.textInner));
                            hasFaultConnector = !slr.notFound;
                            if (!hasFaultConnector) {
                                objElement.put('faultConnector__c', '');
                            }

                            // Save additional extracted details
                            objElement.put('Resource_Type__c', elmType);
                            objElement.put('Resource_Metadata__c', extract);

                            // Assign record id
                            dummyIdSequence = String.valueOf(recordCounter + 100000).right(5);
                            objElement.put('Id', dummyIdPrefix + dummyIdSequence);

                            // Assign other fields
                            switch on elmType {
                                when 'actionCalls' {
                                    objElement.put('Element_Type__c', 'Action');
                                    slr = new sliceResults();
                                    slr = sliceText('<actionType>', '</actionType>', resource, FORWARD);
                                    objElement.put('actionType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<actionName>', '</actionName>', resource, FORWARD);
                                    objElement.put('actionName__c', slr.textInner);
                                }
                                when 'assignments' {
                                    objElement.put('Element_Type__c', 'Assignment');
                                }
                                when 'collectionProcessors' {
                                    slr = new sliceResults();
                                    slr = sliceText('<collectionProcessorType>', '</collectionProcessorType>', resource, FORWARD);
                                    objElement.put('colType__c', slr.textInner);
                                    objElement.put('Element_Type__c', 'Collection ' + slr.textInner.substringBefore('CollectionProcessor'));
                                    slr = new sliceResults();
                                    slr = sliceText('<collectionReference>', '</collectionReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                }
                                when 'decisions' {
                                    objElement.put('Element_Type__c', 'Decision');
                                    slr = new sliceResults();
                                    slr = sliceText('<defaultConnectorLabel>', '</defaultConnectorLabel>', resource, FORWARD);
                                    objElement.put('ruleLabel__c', slr.textInner);
                                    objElement.put('connector__c', objElement.get('defaultConnector__c'));
                                }
                                when 'loops' {
                                    objElement.put('Element_Type__c', 'Loop');
                                    slr = new sliceResults();
                                    slr = sliceText('<nextValueConnector>', '</nextValueConnector>', resource, FORWARD);
                                    objElement.put('nextValueConnector__c', connector(slr.textInner));
                                    slr = new sliceResults();
                                    slr = sliceText('<noMoreValuesConnector>', '</noMoreValuesConnector>', resource, FORWARD);
                                    objElement.put('noMoreValuesConnector__c', connector(slr.textInner));
                                    nextLoopConnector = String.valueof(objELement.get('nextValueConnector__c'));
                                    objELement.put('connector__c', (nextLoopConnector != '(End)') ? nextLoopConnector : objELement.get('noMoreValuesConnector__c'));
                                    slr = new sliceResults();
                                    slr = sliceText('<collectionReference>', '</collectionReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                }
                                when 'recordCreates' {
                                    objElement.put('Element_Type__c', 'Create Records');
                                    slr = new sliceResults();
                                    slr = sliceText('<object>', '</object>', resource, FORWARD);
                                    objElement.put('objectType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<inputReference>', '</inputReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                }
                                when 'recordDeletes' {
                                    objElement.put('Element_Type__c', 'Delete Records');
                                    slr = new sliceResults();
                                    slr = sliceText('<object>', '</object>', resource, FORWARD);
                                    objElement.put('objectType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<inputReference>', '</inputReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                }
                                when 'recordLookups' {
                                    objElement.put('Element_Type__c', 'Get Records');
                                    slr = new sliceResults();
                                    slr = sliceText('<object>', '</object>', resource, FORWARD);
                                    objElement.put('objectType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<outputReference>', '</outputReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<getFirstRecordOnly>', '</getFirstRecordOnly>', resource, FORWARD);
                                    objElement.put('isFirstOnly__c', Boolean.valueOf(slr.textInner));
                                }
                                when 'recordRollbacks' {
                                    objElement.put('Element_Type__c', 'Roll Back Records');

                                }
                                when 'recordUpdates' {
                                    objElement.put('Element_Type__c', 'Update Records');
                                    slr = new sliceResults();
                                    slr = sliceText('<object>', '</object>', resource, FORWARD);
                                    objElement.put('objectType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<inputReference>', '</inputReference>', resource, FORWARD);
                                    objElement.put('colReference__c', slr.textInner);
                                }
                                when 'screens' {
                                    objElement.put('Element_Type__c', 'Screen');

                                }
                                when 'start' {
                                    objElement.put('Element_Type__c', 'Start');
                                    slr = new sliceResults();
                                    slr = sliceText('<object>', '</object>', resource, FORWARD);
                                    objElement.put('objectType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<triggerType>', '</triggerType>', resource, FORWARD);
                                    objElement.put('triggerType__c', slr.textInner);
                                    slr = new sliceResults();
                                    slr = sliceText('<recordTriggerType>', '</recordTriggerType>', resource, FORWARD);
                                    objElement.put('recordTriggerType__c', slr.textInner);
                                }
                                when 'subflows' {
                                    objElement.put('Element_Type__c', 'Subflow');
                                    slr = new sliceResults();
                                    slr = sliceText('<flowName>', '</flowName>', resource, FORWARD);
                                    objElement.put('flowName__c', slr.textInner);
                                }
                                when 'waits' {
                                    objElement.put('Element_Type__c', 'Pause');
                                    slr = new sliceResults();
                                    slr = sliceText('<defaultConnectorLabel>', '</defaultConnectorLabel>', resource, FORWARD);
                                    objElement.put('ruleLabel__c', slr.textInner);
                                    objElement.put('connector__c', objElement.get('defaultConnector__c'));
                                }
                                when 'transforms' {
                                    objElement.put('Element_Type__c', 'Transform');
                                }
                                when 'customErrors' {
                                    objElement.put('Element_Type__c', 'Custom Error');
                                }
                            }

                            // Save Record and Reset Work Metadata
                            workingMetadata = before + after;
                            colElements.add(objElement);

                            // Increment Counter
                            recordCounter ++;

                            // Add extra connector records
                            if (hasFaultConnector) {
                                extraElement = new Flow_OneView__c();
                                extraElement = copyRecord(objElement, recordCounter, dummyIdPrefix);
                                extraElement.put('connector__c', objElement.get('faultConnector__c'));
                                extraElement.put('CanvasSort__c', buildSortKey(xVal, yVal, zVal + 1));
                                colElements.add(extraElement);
                                recordCounter ++;
                            }
                            if (elmType == 'loops') {
                                extraElement = new Flow_OneView__c();
                                extraElement = copyRecord(objElement, recordCounter, dummyIdPrefix);
                                extraElement.put('connector__c', objElement.get('noMoreValuesConnector__c'));
                                extraElement.put('CanvasSort__c', buildSortKey(xVal, yVal, zVal + 1));
                                colElements.add(extraElement);
                                recordCounter ++;
                            }
                            if (elmType == 'decisions') { 
                                ruleMetadata = extract;
                                lastRule = false;
                                zVal = 1;
                                while (!lastRule) {
                                    extraElement = new Flow_OneView__c();
                                    extraElement = copyRecord(objElement, recordCounter, dummyIdPrefix);
                                    slr = new sliceResults();
                                    slr = sliceText(ttStart('rules'), ttEnd('rules'), ruleMetadata, FORWARD);
                                    if (slr.textInner != null && slr.textInner.length() > 0) {   // FOUND
                                        lastRule = false;
                                        rbefore = slr.textBefore;
                                        rextract = slr.textExtract;
                                        rresource = slr.textInner;
                                        rafter = slr.textAfter;
                                        slr = new sliceResults();
                                        slr = sliceText('<connector>', '</connector>', rresource, FORWARD);
                                        extraElement.put('connector__c', connector(slr.textInner));
                                        slr = new sliceResults();
                                        slr = sliceText('<label>', '</label>', rresource, FORWARD);
                                        extraElement.put('ruleLabel__c', slr.textInner);
                                        extraElement.put('CanvasSort__c', buildSortKey(xVal, yVal, zVal));
                                        extraElement.put('Element_Type__c', 'Decision');
                                        ruleMetadata = rbefore + rafter;
                                        colElements.add(extraElement);
                                        recordCounter ++;
                                        zVal ++;
                                    } else {
                                        lastRule = true;
                                    }
                                }
                            }
                            if (elmType == 'waits') { 
                                ruleMetadata = extract;
                                lastRule = false;
                                zVal = 1;
                                while (!lastRule) {
                                    extraElement = new Flow_OneView__c();
                                    extraElement = copyRecord(objElement, recordCounter, dummyIdPrefix);
                                    slr = new sliceResults();
                                    slr = sliceText(ttStart('waitEvents'), ttEnd('waitEvents'), ruleMetadata, FORWARD);
                                    if (slr.textInner != null && slr.textInner.length() > 0) {   // FOUND
                                        lastRule = false;
                                        rbefore = slr.textBefore;
                                        rextract = slr.textExtract;
                                        rresource = slr.textInner;
                                        rafter = slr.textAfter;
                                        slr = new sliceResults();
                                        slr = sliceText('<connector>', '</connector>', rresource, FORWARD);
                                        extraElement.put('connector__c', connector(slr.textInner));
                                        slr = new sliceResults();
                                        slr = sliceText('<label>', '</label>', rresource, FORWARD);
                                        extraElement.put('ruleLabel__c', slr.textInner);
                                        extraElement.put('CanvasSort__c', buildSortKey(xVal, yVal, zVal));
                                        objElement.put('Element_Type__c', 'Pause');
                                        ruleMetadata = rbefore + rafter;
                                        colElements.add(extraElement);
                                        recordCounter ++;
                                        zVal ++;
                                    } else {
                                        lastRule = true;
                                    }
                                }
                            }

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
            response.resourceRecordCollection = colElements;
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

    public static SObject copyRecord(SObject sourceRecord, Integer recordCounter, String dummyIdPrefix) {
        SObject targetRecord = new Flow_OneView__c();
        targetRecord.put('isOtherConnector__c', true);
        targetRecord.put('isPassed__c', sourceRecord.get('isPassed__c'));
        targetRecord.put('isElement__c', sourceRecord.get('isElement__c'));
        targetRecord.put('Resource_name__c', sourceRecord.get('Resource_name__c'));
        targetRecord.put('Element_label__c', sourceRecord.get('Element_label__c'));
        targetRecord.put('Resource_Type__c', sourceRecord.get('Resource_Type__c'));
        targetRecord.put('locationX__c', sourceRecord.get('locationX__c'));
        targetRecord.put('locationY__c', sourceRecord.get('locationY__c'));
        String dummyIdSequence = String.valueOf(recordCounter + 100000).right(5);
        targetRecord.put('Id', dummyIdPrefix + dummyIdSequence);
        return targetRecord;
    }

    public static String buildSortKey(Integer xVal, Integer yVal, Integer zVal) {
        String sortKey = String.valueOf(yVal+1000000).right(6) + '-';
        sortKey += String.valueOf(xVal+1000000).right(6) + '-';
        sortKey += String.valueOf(zVal+1000).right(3);
        return sortKey;
    }

    public static String connector(String targetReference) {
        sliceResults slr = new sliceResults();
        slr = new sliceResults();
        slr = sliceText('<targetReference>', '</targetReference>', targetReference, false);
        if(slr.textInner != null && slr.textInner.length() > 0) {
            return slr.textInner;
        } else {
            return '(End)';
        }
    }

    public static String ttStart(String eType) {
        return '<' + eType + '>';
    }

    public static String ttEnd(String eType) {
        return '</' + eType + '>';
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