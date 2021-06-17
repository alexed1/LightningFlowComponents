/**
 * @description       : Webhook2Flow
 * @author            : Jack D. Pond
 * @group             : PSITex, LLC
 * @last modified on  : 05-14-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   01-01-2021   Jack D. Pond   Initial Version
 * To do:
 * 1. Recursion
 * 2. Null values
 *
 * https://developer.salesforce.com/blogs/pat-patterson/2011/08/quick-tip-pretty-print-json-in-the-browser.html
 * https://psitexllc.quip.com/VoMrASkiH7PO/Enabling-Webhooks-to-Launch-Flows
 * https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/errorcodes.htm
 * https://salesforce.com/services/wsdl/tooling  [for error messages under StatusCode]
 * 
**/

global without sharing class Webhook2Flow {                         // without sharing necessary for un-authenticated access via site
    static final String FLOW_VERSIONID_PARAM = 'flowVersionId';		// This is reserved for future if versioning is allowed in future
    static final String FLOW_ERROR_MESSAGE_OBJECT = 'FlowExecutionErrorEvent';
    static final String HTTP_RESPONSE_STATUSCODE = 'Webhook2Flow_RestResponse_statusCode';
    static final Integer BAD_RESPONSE_DEFAULT = 400 ; // BAD_REQUEST
    static final Integer GOOD_RESPONSE_DEFAULT = 200 ; // Normal Response
    static final String HTTP_RESPONSE_CONTENT_TYPE = 'application/json' ; // Normal Response
    static final String INVALID_PARAMETER_TYPE = 'DATATYPE_INVALID';
    static final String MSG_COLLECTION_NOT_SUPPORTED = '- Collection is not a supported parameter type.';
    static final String MSG_TYPE_NOT_SUPPORTED = ' is not a supported parameter type.';
    static final String JSON_PARAMETER_OBJECTYPE = '\"ObjectType\"';
    static final String DOUBLE_QUOTE = '\"';

    private static FlowExecutionErrorEvent setupError(Exception e, String relatedTo){
        FlowExecutionErrorEvent FEE = new FlowExecutionErrorEvent(
                ErrorId = e.getTypeName(),
                ErrorMessage = 'RelatedTo: ' + relatedTo + ' Stack: ' + e.getStackTraceString() + ' Msg: ' + e.getMessage()
        );
//        system.debug('FEE: ' + FEE);
        return FEE;
    }

    private static String getObjectType(String inObjectType, String inDescription){
        String retObjectType=inObjectType;
        if (inObjectType == null){
            if (inDescription != null && inDescription.length() > 0 && inDescription.contains(JSON_PARAMETER_OBJECTYPE)){
                retObjectType = inDescription.substringAfter(JSON_PARAMETER_OBJECTYPE).substringAfter(DOUBLE_QUOTE).substringbefore(DOUBLE_QUOTE);
            }
        }
        return retObjectType;
    }
/**
 * @description       : WebHookProcessor.WebHookInboundHandler
 * @author            : Tom Snyder (Wrapper) Jack D. Pond (Parser)
 * @group             : 
 * @last modified on  : 05-14-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   01-01-2021   Jack D. Pond   Initial Version
*/
    global class WebHook2FlowHandler extends WebHookProcessor.WebHookInboundHandler {
           
        global override System.RestResponse execute(WebhookInboundEvent__mdt endPointDefinitionMDT, RestRequest req) {

            System.RestResponse resp =  new System.RestResponse();
            try {
                string whichHttp = req.httpMethod?.toLowerCase();
                String flowVersion;
                
                resp.headers.put('Content-Type',HTTP_RESPONSE_CONTENT_TYPE);

                //combine queryParams with headers
                Map<string, string> paramsMap = RestContext.request.params;
                paramsmap.putAll(RestContext.request.headers);

                
                Map<String, Object> flowParams = new Map<String, Object>();
                FlowVariableView responseStatusCode;
                List<FlowVariableView> responseErrors = new List<FlowVariableView>();
                Boolean hasFlowError = false;
                List<String>retJSON = new List<String>{};
                List<FlowExecutionErrorEvent> foundErrors = new List<FlowExecutionErrorEvent>{};

                /*
                String webHookFlowName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                webHookFlowName = webHookFlowName.split('\\?')[0].split('&')[0];
                */
                
                
                string webHookFlowName = endPointDefinitionMDT.Actor__c;
                List<String> flowNames = new List<String>{webHookFlowName};
                String[] requestTypes = webHookFlowName.split('_');

                if (requestTypes[requestTypes.size()-1] != whichHttp) flowNames.add(webHookFlowName+'_'+whichHttp);
                flowVersion = paramsMap.get(FLOW_VERSIONID_PARAM) != null? String.escapeSingleQuotes(paramsMap.get(FLOW_VERSIONID_PARAM)):null;
                FlowDefinitionView[] allViews = [SELECT ActiveVersionId,ApiName,Builder,Description,DurableId,Id,InstalledPackageName,IsActive,IsOutOfDate,IsSwingFlow,IsTemplate,Label,LastModifiedBy,LastModifiedDate,LatestVersionId,ManageableState,NamespacePrefix,ProcessType,TriggerType FROM FlowDefinitionView where ApiName in :flowNames ORDER BY ApiName ASC];
                Integer whichFlowNdx;
                if ( !allViews.isEmpty()){
                    whichFlowNdx = allViews.size()-1;
                    flowVersion = flowVersion == null ? (allviews[whichFlowNdx].IsActive ? allviews[whichFlowNdx].ActiveVersionId : allviews[whichFlowNdx].LatestVersionId ): flowversion;
                    FlowVariableView[] allParams = [SELECT ApiName,DataType,Description,DurableId,FlowVersionViewId,IsCollection,IsInput,IsOutput,ObjectType FROM FlowVariableView where FlowVersionViewId = :flowVersion];
                    Map<String, FlowVariableView> outputParamMap = new Map<String, FlowVariableView> {};
                    Map<String, FlowVariableView> inputParamMap = new Map<String, FlowVariableView>();
                    Map<String, String> customObjectMap = new Map<String, String>();
                    for (FlowVariableView thisVariable : allParams){
                        if (thisVariable.IsInput) inputParamMap.put(thisVariable.ApiName,thisVariable);
                        if (thisVariable.IsOutput){  // if this is an error object (FlowExecutionErrorEvent) put it into the error stack, otherwise, standard output
                            if (thisVariable.ObjectType == FLOW_ERROR_MESSAGE_OBJECT){
                                responseErrors.add(thisVariable);
                            }else outputParamMap.put(thisVariable.ApiName,thisVariable);
                        }
                    }
                    responseStatusCode = outputParamMap.remove(HTTP_RESPONSE_STATUSCODE);

// URI parameters
                    for (string thisParam : paramsMap.keySet()) {
                        if (thisParam != FLOW_VERSIONID_PARAM ){
                            FlowVariableView thisInput=(FlowVariableView)inputParamMap.get(thisParam);
                            if (thisInput != null && !thisInput.IsCollection){ // Collections not currently allowed
                                switch on (thisInput.DataType){     // https://swagger.io/docs/specification/data-models/data-types/
                                    when 'String' {
                                        try {flowParams.put(thisInput.ApiName, EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8'));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
                                    when 'Number' {
                                        try {flowParams.put(thisInput.ApiName, Double.valueOf(EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8')));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
/* Currency n/a - causes uncatchable exception
                                    when 'Currency' {
                                        try {flowParams.put(thisInput.ApiName, Double.valueOf(EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8')));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
*/
                                    when 'Boolean' {
                                        try {flowParams.put(thisInput.ApiName, Boolean.valueOf(EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8')));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
                                    when 'Date' {
                                        try {flowParams.put(thisInput.ApiName, Date.valueOf(EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8')));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
                                    when 'DateTime' {
                                        try {flowParams.put(thisInput.ApiName, DateTime.valueOf(EncodingUtil.urlDecode(paramsMap.get(thisParam),'UTF-8').replace('T',' ')));}
                                        catch(Exception e){foundErrors.add(setupError(e, thisParam));}
                                    }
                                    when else {         //  additional types currently unsupported
                                        foundErrors.add(new FlowExecutionErrorEvent (
                                                ErrorId = INVALID_PARAMETER_TYPE,
                                                ErrorMessage = 'Parameter: ' + thisInput.ApiName + '- Type: ' + thisInput.DataType + MSG_TYPE_NOT_SUPPORTED
                                            )
                                        );
                                    }
                                }
                            }else{
/* collections currently not allowed as param list
                                if (thisInput != null && thisInput.isCollection ){
                                    FlowExecutionErrorEvent thisError = new FlowExecutionErrorEvent (
                                        ErrorId = INVALID_PARAMETER_TYPE,
                                        ErrorMessage = 'Parameter: ' + thisInput.ApiName + MSG_COLLECTION_NOT_SUPPORTED
                                    );
                                    retJSON.add(JSON.serialize(thisError));
                                    if (!hasFlowError) RestContext.response.statusCode = 400;
                                    hasFlowError = true;
                                }
*/
                            }
                        }
                    }

// Process arrays/collections                    
                    JSONParser parser = JSON.createParser(req.requestBody.toString());
                    while (parser.nextToken() != null) {
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                            FlowVariableView thisInput=(FlowVariableView)inputParamMap.get(parser.getText());
                            parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY){  // if a collection (API Object)
                                if (thisInput != null && thisInput.IsCollection){
                                    // Integer, Double, Long, Date, Datetime, String, ID, or Boolean
                                    switch on (thisInput.DataType){     // https://swagger.io/docs/specification/data-models/data-types/
                                        when 'String'{     // string
                                            List<String> thisCollection = new List<String>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getText());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when 'Number' {       // number
                                            List<Double> thisCollection = new List<Double>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getDoubleValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
/* Currency n/a - causes uncatchable exception
                                        when 'Currency'  {       // number
                                            List<Double> thisCollection = new List<Double>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getDoubleValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0)flowParams.put(thisInput.ApiName, thisCollection);
                                        }
*/
/* Integer not currently supported
                                        when 'Integer'{     // integer
                                            List<Integer> thisCollection = new List<Integer>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getIntegerValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
*/
                                        when 'Boolean'{     // boolean
                                            List<Boolean> thisCollection = new List<Boolean>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getBooleanValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when 'DateTime'{     // Date/Time
                                            List<Datetime> thisCollection = new List<Datetime>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getDatetimeValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when 'Date'{     // Date
                                            List<Date> thisCollection = new List<Date>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                try{thisCollection.add(parser.getDateValue());}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when 'SObject'{     // object
                                            List<sObject> thisCollection = new List<sObject>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                                    try{thisCollection.add((sObject)parser.readValueAs(Type.forName(thisInput.ObjectType)));}
                                                    catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                                }
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when 'Apex'{     // object
                                            List<Object> thisCollection = new List<Object>();
                                            while (parser.nextToken() != null & parser.getCurrentToken() != JSONToken.END_ARRAY) {
                                                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
//                                                  (Object) thisInstance = (Object) dynamicApexType.newInstance();
                                                    try{thisCollection.add((Object)parser.readValueAs(Type.forName(thisInput.ObjectType)));}
                                                    catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                                }
                                            }
                                            if(thisCollection.size() >0) flowParams.put(thisInput.ApiName, thisCollection);
                                        }
                                        when else {         //  additional types currently unsupported
                                            foundErrors.add( new FlowExecutionErrorEvent (
                                                    ErrorId = INVALID_PARAMETER_TYPE,
                                                    ErrorMessage = 'Parameter: ' + thisInput.ApiName + ' type: ' + thisInput.dataType + MSG_COLLECTION_NOT_SUPPORTED
                                                )
                                            );
                                        }
                                    }
                                } else {
                                    parser.skipChildren();
                                }
                            } else {

// individual parameters
                                if (thisInput != null){
                                    switch on (thisInput.DataType){     // https://swagger.io/docs/specification/data-models/data-types/
                                        when 'String'{     // string
                                            try{flowParams.put(thisInput.ApiName, parser.getText());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
                                        when 'Number' {       // number
                                            try{flowParams.put(thisInput.ApiName, parser.getDoubleValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
/* Currency n/a - causes uncatchable exception
                                        when 'Currency' {       // number
                                            try{flowParams.put(thisInput.ApiName, parser.getDoubleValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
*/
                                        /* Integer not implemented yet
                                        when 'Integer'{     // integer
                                            try{flowParams.put(thisInput.ApiName, parser.getIntegerValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
*/
                                        when 'Boolean'{     // boolean
                                            try{flowParams.put(thisInput.ApiName, parser.getBooleanValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
                                        when 'DateTime' {     // Date/Time
                                            try{flowParams.put(thisInput.ApiName, parser.getDatetimeValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
                                        when 'Date'{     // Date
                                            try{flowParams.put(thisInput.ApiName, parser.getDateValue());}
                                            catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                        }
                                        when 'SObject' {     // object
                                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
//                                              retJSON.add('"'+thisInput.ApiName+ '00" : '+JSON.serialize(parser.getCurrentToken())); // This is a debug statement
                                                try{flowParams.put(thisInput.ApiName , parser.readValueAs(Type.forName(thisInput.ObjectType)));}
                                                catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName));}
                                            }
                                        }
                                        when 'Apex' {     // apex-defined object
                                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                                string thisObjectType = getObjectType(thisInput.ObjectType,thisInput.Description);

/*
                                                
                                                try {
                                                    
                                                    ExternalService.SlackDemo_event thisAppEvent;
                                                    thisAppEvent= (ExternalService.SlackDemo_event) Type.forName('ExternalService','SlackDemo_event').newInstance();
                                                    thisAppEvent.text = 'jibber jabber jibber jabber';
                                                    system.debug(thisAppEvent.text);
                                                    String thisJSON = JSON.serializePretty(thisAppEvent);
                                                    system.debug(thisJSON);
                                                }
//                                        catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName + '('+thisObjectType+')'));}
                                                catch(Exception e){}
*/
                                                try{flowParams.put(thisInput.ApiName , parser.readValueAs(Type.forName(thisObjectType)));}
												catch(Exception e){foundErrors.add(setupError(e, thisInput.ApiName + '('+thisObjectType+')'));}
                                            }
                                        }
                                        when else {         //  additional types currently unsupported
                                            flowParams.put('ErrorMessage', 'Invalid DataType: ' + thisInput.DataType);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (foundErrors.size() == 0 ){          // If no parsing errors found, execute the flow
                        Flow.Interview thisFlow = Flow.Interview.createInterview(webHookFlowName, flowParams);
                        try {thisFlow.Start();}
                        catch (Exception e){ foundErrors.add(setupError(e, webHookFlowName));}
                        resp.responseBody = Blob.valueof('');
                        for (FlowVariableView thisErrorParam : responseErrors){
                            Object tmpObj;
                            try { tmpObj = thisFlow.getVariableValue(thisErrorParam.ApiName); }
                            catch (Exception e){ tmpObj = null;}
                            if (tmpObj != null){
                                foundErrors.addAll((List<FlowExecutionErrorEvent>)tmpObj);
                            }
                        }
                        if (resp.statusCode == null)
                            resp.statusCode = (foundErrors.size() > 0) ? BAD_RESPONSE_DEFAULT :  GOOD_RESPONSE_DEFAULT;
                        if( foundErrors.size() > 0 ){
                            retJSON.add('"webhook2flowErrors" : ' + JSON.serialize(foundErrors));
                        }
                        List<FlowVariableView> outputParams = new List<FlowVariableView> ();
                        outputParams.addall(outputParamMap.values());
                        for (FlowVariableView thisVariable : outputParams){
                            if(thisVariable.DataType != 'Apex'){
                                String tmpJSON;
                                try {tmpJSON = JSON.serialize(thisFlow.getVariableValue(thisVariable.ApiName)); }
                                catch (Exception e){ tmpJSON = null;}
                                if (tmpJSON != null) retJSON.add('"'+thisVariable.ApiName+'" : ' + tmpJSON);
                            }
                        }
                    } else {  // parsing errors were found, so enumerate them
                        retJSON.add('"webhook2flowErrors": ' + JSON.serialize(foundErrors));
                        resp.statusCode = BAD_RESPONSE_DEFAULT;
                    }
//                    retJSON.add('"inputParamMap: "'+JSON.serialize(inputParamMap)); // This is a debug statement of all input params
//                    retJSON.add('"outputParamMap: "'+JSON.serialize(outputParamMap)); // This is a debug statement of all output params
//                    retJSON.add('"RestContext.response.statusCode" : '+JSON.serialize(RestContext.response.statusCode)); // This is a debug statement of all input params
//                    retJSON.add('"RestContext.request": '+JSON.serialize(RestContext.request));
//                    retJSON.add('"RestContext": '+JSON.serialize(RestContext));
                    if (retJSON.size() > 0) resp.responseBody = Blob.valueof('{'+string.join(retJSON,',')+'}');
                } else { // Specified flow not found - should have been caught in listener, but if bad configs, catches here
                    resp.statusCode = GOOD_RESPONSE_DEFAULT; // Security - for endpoint fishers, just return good and do nothing
                    resp.responseBody = Blob.valueof('');
                }
                return resp;
            }
            catch(Exception ex) {
                throw new WebHookListener.WebHookListenerException('BAD_CONFIGURATION', ex);
            }
        }
    }
    
}