/** 
 *  Process Flow Metadata and create a Flow OneView record for each Flow Detail
 * 
 *  Eric Smith - 4/13/23 - v1.0
 * 
 *  This class is designed to extract individual flow details from flow metadata
 *  
 *  It takes a flow XML string and returns Flow OneView records for each detail
 *  
 * 
**/ 

global inherited sharing class ers_ProcessFlowDetails {

    // Attributes passed in from the Flow
    global class Requests {

        @InvocableVariable(Label='Flow Metadata')
        global String sourceMetadata;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable(Label='Flow OneView Detail Records') 
        global List<SObject> detailRecordCollection;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Process Flow Details by Eric Smith' iconName='resource:ProcessResourceSVG:OneView')
    global static List<Results> processDetails(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            String originalSourceMetadata = req.sourceMetadata;

            // Set Output Value(s)
            List<SObject> detailRecordCollection = new List<SObject>();

            // Set initial values
            Map <String, Integer> detailTypes = new Map <String, Integer> {
                'apiVersion' => 50,
                'description' => 20,
                'environments' => 80,
                'interviewLabel' => 70,
                'label' => 10,
                'processMetadataValues' => 200,
                'processType' => 30,
                'runInMode' => 60,
                'status' => 40
            };

            Map <String, Integer> pmvTypes = new Map <String, Integer> {
                'BuilderType' => 20,
                'CanvasMode' => 10,
                'OriginBuilderType' => 30
            };

            // Define working variables
            List<Sobject> colDetails = new List<Sobject>();
            SObject emptyDetail = [SELECT Id, Resource_name__c, Resource_Type__c FROM Flow_OneView__c LIMIT 1];
            emptyDetail.put('Resource_name__c', '');
            emptyDetail.put('Resource_Type__c', '');
            SObject objDetail  = emptyDetail;

            ID fovId = [SELECT Id FROM Flow_OneView__c LIMIT 1].Id;
            String dummyIdString = (Id)fovId;
            String dummyIdPrefix = dummyIdString.left(10);
            String dummyIdSequence = '';

            Integer recordCounter = 0;
            String sourceMetadata = unescapebrace(originalSourceMetadata);
            Boolean isDetail = false;
            Boolean hasStarted = false;
            String currentNode = '';
            String skipNode = '';
            String contentsNode = '';
            String valueNode = '';
            Boolean isProcessMetadataValues = false;
            Boolean isPmvName = false;
            Boolean isPmvStringValue = false;
            String pmvName = '';
            String pmvStringValue = '';
            Integer sequence = 0;
            Integer pmvSequence = 0;

            xmlstreamreader flowmetadata = new xmlstreamreader(sourceMetadata);
            flowmetadata.setCoalescing(true);

            // Validate input attributes
            if (sourceMetadata != null && sourceMetadata.length() > 0) {

// BEGIN APEX ACTION PROCESSING LOGIC

                // Process XML
                while(flowmetadata.hasNext()) {

                    if (flowmetadata.getEventType() != xmlTag.START_DOCUMENT && !flowmetadata.isWhiteSpace()) {

                        if (flowmetadata.isStartElement() && !isDetail && flowmetadata.getLocalName() != 'Flow') {
                            hasStarted = true;
                            if (detailTypes.containsKey(flowmetadata.getLocalName())) {
                                isDetail = true;
                                currentNode = flowmetadata.getLocalName();
                                contentsNode = ttStart(currentNode);
                                sequence = detailTypes.get(currentNode);
                                if (flowmetadata.getLocalName() == 'processMetadataValues') {
                                    isProcessMetadataValues = true;
                                }
                            } else {
                                isDetail = false;
                                skipNode = flowmetadata.getLocalName();
                            }
                        }

                        if (isDetail) { 
                            if (flowmetadata.isStartElement() && flowmetadata.getLocalName() != currentNode) {
                                contentsNode += ttStart(flowmetadata.getLocalName());
                                if (isProcessMetadataValues && flowmetadata.getLocalName() == 'name') {
                                    isPmvName = true;
                                }
                                if (isProcessMetadataValues && flowmetadata.getLocalName() == 'stringValue') {
                                    isPmvStringValue = true;
                                }
                            } else if (flowmetadata.isCharacters()) {
                                contentsNode += flowmetadata.getText();
                                valueNode = flowmetadata.getText();
                                if (isPmvName) {
                                    pmvName = flowmetadata.getText();
                                    pmvSequence = pmvTypes.get(pmvName);
                                    isPmvName = false;
                                    valueNode = '';
                                }
                                if (isPmvStringValue) {
                                    pmvStringValue = flowmetadata.getText();
                                    isPmvStringValue = false;
                                    valueNode = '';
                                }
                            } else if (flowmetadata.isEndElement()) {
                                contentsNode += ttEnd(flowmetadata.getLocalName());
                                if (flowmetadata.getLocalName() == currentNode) {

                                    // Create OneView Detail Record
                                    objDetail.put('isDetail__c', true);
                                    objDetail.put('Resource_Type__c', currentNode);
                                    objDetail.put('Resource_Metadata__c',contentsNode);
                                    objDetail.put('value__c',valueNode);
                                    if (isProcessMetadataValues) {
                                        objDetail.put('dataType__c', pmvName);
                                        objDetail.put('text__c', pmvStringValue);
                                        sequence = sequence + pmvSequence;
                                        isProcessMetadataValues = false;
                                        pmvSequence = 0;
                                    }
                                    objDetail.put('Detail_Sequence__c',sequence);

                                    // Assign record id
                                    dummyIdSequence = String.valueOf(recordCounter + 100000).right(5);
                                    objDetail.put('Id', dummyIdPrefix + dummyIdSequence);

                                    // Save Record & Reset
                                    colDetails.add(objDetail);
                                    objDetail = new Flow_OneView__c();
                                    recordCounter ++;
                                    isDetail = false;

                                }
                            } 
                            flowmetadata.next();
                        } else {
                            while (!(flowmetadata.isEndElement() && (flowmetadata.getLocalName() == skipNode)) && hasStarted && flowmetadata.hasNext()) {
                                flowmetadata.next();
                            }
                            flowmetadata.next();
                        }

                    } else {
                        flowmetadata.next();
                    }

                }

// END APEX ACTION PROCESSING LOGIC

            }

            // Set Output Values
            response.detailRecordCollection = colDetails;
            responseWrapper.add(response);

        }

        // Return values back to the Flow
        return responseWrapper;
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

    public static String unescapebrace(String text) {
        text = text.replace('&lbrace;', '{');
        text = text.replace('&rbrace;', '}');
        return text;
    }

}