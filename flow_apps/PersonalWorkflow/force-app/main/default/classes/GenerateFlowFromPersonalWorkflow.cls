public with sharing class GenerateFlowFromPersonalWorkflow {

    @InvocableMethod(label='Generate Flow From Personal Workflow Record' description='Generate Flow From Personal Workflow Record')
    public static List<Response> Invoke (List<Request> requestList) {
        List<Response> responseList = new List<Response>();

        //for(Request req : requestList) {
            PersonalWorkflow__c personalWorkflow = [
                SELECT  Id,
                        Name,
                        Action_Description__c,
                        Activity__c,
                        Trigger_Description__c,
                        Unique_Name__c
                FROM    PersonalWorkflow__c
                WHERE   Id = :requestList[0].personalWorkflowId
                LIMIT   1

            ];

            PersonalWorkflowAction__c personalWorkflowAction = [
                SELECT  Id, 
                        Name, 
                        Label__c,
                        Parent_Workflow_Id__c,
                        PersonalWorkflowActionInputParam__c
                FROM    PersonalWorkflowAction__c
                WHERE   Parent_Workflow_Id__c = :requestList[0].personalWorkflowId
                LIMIT   1
            ];

            PersonalWorkflowTrigger__c personalWorkflowTrigger = [
                SELECT  Id, 
                        Name, 
                        Personal_Workflow__c,
                        TriggerCriteriaFormula__c,
                        TriggerFilterType__c,
                        TriggeringEvents__c,
                        TriggerObjectName__c,
                        TriggerType__c
                FROM    PersonalWorkflowTrigger__c
                WHERE   Personal_Workflow__c = :requestList[0].personalWorkflowId
                LIMIT   1
            ];
        
            String conditionsXML = '';
            System.debug(personalWorkflowTrigger.TriggerCriteriaFormula__c);
            if(String.isNotEmpty(personalWorkflowTrigger.TriggerCriteriaFormula__c)) {
                Map<String,Object> triggerCriteriaFormula = usf3.ExpressionBuilder.disassemblyFormulaString(personalWorkflowTrigger.TriggerCriteriaFormula__c, null);
                List<usf3.ExpressionBuilder.ExpressionLineWrapper> expressionLineList = (List<usf3.ExpressionBuilder.ExpressionLineWrapper>)triggerCriteriaFormula.get('expressionLines');
                for(usf3.ExpressionBuilder.ExpressionLineWrapper expressionLine : expressionLineList) {
                    conditionsXML += '<filters>' + 
                        '<field>' + 
                            expressionLine.fieldName.split('\\.')[1] +
                        '</field>'+
                        '<operator>' +
                            + operatorMap.get(expressionLine.operator) +
                        '</operator>'+
                        '<value>'+
                            '<stringValue>' +
                                + expressionLine.parameter +
                            '</stringValue>'+
                            
                        '</value>'+
                    '</filters>';
                }
                conditionsXML += '<filterLogic>' + triggerCriteriaFormula.get('logicType') + '</filterLogic>';
                
            }


            String actionCallsXML = '';
            String targetReference = '';
            if(String.isNotEmpty(personalWorkflowAction.PersonalWorkflowActionInputParam__c)) {
                List<ActionCallInputsWrapper> actionCallInputList = (List<ActionCallInputsWrapper>)JSON.deserialize(personalWorkflowAction.PersonalWorkflowActionInputParam__c, List<ActionCallInputsWrapper>.class);
                String inputsXML = '';
                
                for(ActionCallInputsWrapper input : actionCallInputList) {
                    inputsXML +=  '<inputParameters>'+
                                            '<name>'+ input.name +'</name>'+
                                            '<value>'+
                                                '<stringValue>'+ input.newValue +'</stringValue>' +
                                        ' </value>'+
                                    '</inputParameters>';
                }
                
                actionCallsXML = String.format(actionCallXMLSample, new List<String> {
                    personalWorkflowAction.Label__c.replace(' ', '_'),
                    personalWorkflowAction.Label__c,
                    inputsXML
                });

                targetReference = '<connector><targetReference>' + personalWorkflowAction.Label__c.replace(' ', '_') + '</targetReference></connector>';
            }

            Response resp = new Response();

            System.debug(conditionsXML);
            resp.flowXML = String.format(flowXMLStructure, new List<String>{
                personalWorkflow.Name,
                targetReference,
                conditionsXML,
                personalWorkflowTrigger.TriggerObjectName__c,
                'Create',
                actionCallsXML
            });
            responseList.add(resp);
        //}

        return responseList;
    }

    public class Request {
        @InvocableVariable(label='Personal Workflow Id')
        public String personalWorkflowId;
    }

    public class Response {
        @InvocableVariable(label='Flow XML')
        public String flowXML;
    }

    public class ActionCallInputsWrapper {
        String name;
        String newValue;
        String newValueDataType;
    }

    static Map<String,String> operatorMap = new Map<String, String> {
        'equals' => 'EqualTo',
        'not_equal_to' => 'NotEqualTo',
        'contains' => 'Contains',
        'does_not_contain' => 'EndsWith',
        'includes' => 'Includes',
        'excludes' => 'Excludes',
        'starts_with' => 'StartsWith',
        'end_with' => 'EndsWith',
        'greater_or_equal' => 'GreaterThanOrEqualTo',
        'greater_then' => 'GreaterThan',
        'less_or_equal' => 'LessThanOrEqualTo',
        'less_then' => 'LessThan'


    };

    static string flowXMLStructure = '<?xml version="1.0" encoding="UTF-8"?>'+
    '<Flow xmlns="http://soap.sforce.com/2006/04/metadata">'+
        '<apiVersion>52.0</apiVersion>'+
        '<interviewLabel>{0} \'{!\' $Flow.CurrentDateTime\'}\'</interviewLabel>'+
        '<label>{0}</label>'+
        '<processMetadataValues>'+
            '<name>BuilderType</name>'+
            '<value>'+
                '<stringValue>LightningFlowBuilder</stringValue>'+
           ' </value>'+
        '</processMetadataValues>'+
        '<processMetadataValues>'+
            '<name>CanvasMode</name>'+
            '<value>'+
                '<stringValue>AUTO_LAYOUT_CANVAS</stringValue>'+
            '</value>'+
        '</processMetadataValues>'+
        '<processMetadataValues>'+
            '<name>OriginBuilderType</name>'+
            '<value>'+
                '<stringValue>LightningFlowBuilder</stringValue>'+
            '</value>'+
        '</processMetadataValues>'+
        '<processType>AutoLaunchedFlow</processType>'+
        '<start>'+
            '<locationX>50</locationX>'+
            '<locationY>0</locationY>'+
            '<scheduledPaths>'+
                '<name>Shedule_Path</name>'+
                '<label>Shedule Path</label>'+
                '<offsetNumber>1</offsetNumber>'+
                '<offsetUnit>Hours</offsetUnit>'+
                '<recordField>LastModifiedDate</recordField>'+
                '<timeSource>RecordField</timeSource>'+
                '{1}' +//'<targetReference>{1}</targetReference>'+
            '</scheduledPaths>'+
            //'<connector>'+
            
            //'</connector>'+
            '{2}'+ //filters 
            '<object>{3}</object>'+ //object name
            '<recordTriggerType>{4}</recordTriggerType>'+// triger type(Create)
            '<triggerType>RecordAfterSave</triggerType>'+
        '</start>'+
        '<status>Active</status>'+
        '{5}' +
    '</Flow>';

    static String actionCallXMLSample = '<actionCalls>'+
            '<name>{0}</name>'+
            '<label>{1}</label>'+
            '<locationX>176</locationX>'+
            '<locationY>335</locationY>'+
            '<actionName>PostToSlack</actionName>'+
            '<actionType>apex</actionType>'+
            '<flowTransactionModel>CurrentTransaction</flowTransactionModel>'+
            '{2}' +
            '<storeOutputAutomatically>true</storeOutputAutomatically>'+
        '</actionCalls>';
}
