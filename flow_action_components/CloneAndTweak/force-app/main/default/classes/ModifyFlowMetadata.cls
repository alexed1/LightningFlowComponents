global with sharing class ModifyFlowMetadata {
    final static String CLONE_ACTION = 'Clone';
    final static String OWERWRITE_ACTION = 'Overwrite';
    final static String NONE_ACTION = 'None';


    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
        List<Result> responses = new List<Result>();
        for (Request curRequest: requestList ){
            try{
                Result curResult = new Result();
                usf3.MetadataService.Flow flow = Test.isRunningTest() ? ModifyFlowMetadataTest.genereateFlowForTest() : usf3.MetadataUtils.getFlowMetadataFromName(curRequest.flowName)[0];

                if(String.isNotEmpty(curRequest.entityPath1)) {
                    modifyFlow(flow, curRequest.entityPath1, curRequest.value1);
                }

                if(String.isNotEmpty(curRequest.entityPath2)) {
                    modifyFlow(flow, curRequest.entityPath2, curRequest.value2);
                }

                if(String.isNotEmpty(curRequest.entityPath3)) {
                    modifyFlow(flow, curRequest.entityPath3, curRequest.value3);
                }

                if(String.isNotEmpty(curRequest.entityPath4)) {
                    modifyFlow(flow, curRequest.entityPath4, curRequest.value4);
                }

                if(String.isNotEmpty(curRequest.entityPath5)) {
                    modifyFlow(flow, curRequest.entityPath5, curRequest.value5);
                }

                //call usf3.MetadataUtils to get the FlowMetadata
                //apply the change list
                if(!Test.isRunningTest()) {
                    if(curRequest.action == CLONE_ACTION) {
                        flow.label = curRequest.newFlowName;
                        flow.fullName = usf3.MetadataUtils.filterLabelToApiName(curRequest.newFlowName) + '-1';
                        usf3.MetadataUtils.createFlowMetadata(flow);
                    } else if(curRequest.action == OWERWRITE_ACTION){
                        usf3.MetadataUtils.upsertFlowMetadata(flow);
                    }
                }

                curResult.modifiedFlowMetadata = flow;
                responses.add(curResult);
            } catch(Exception e) {
                Result curResult = new Result();
                curResult.errors = e.getMessage() + '\n' + e.getStackTraceString();
                responses.add(curResult);
            }
        }
                
        return responses;
    }      

    //Flow.FlowAssignment[Assign_Email_Template].FlowAssignmentItem[EmailTemplateName].value
    //Flow.FlowVariables[segmentName] 
    //Flow.FlowStart.FlowSchedule
    //Flow.FlowActionCall[Assign_Email_Template].FlowActionCallInputParameter[EmailTemplateName].value
    static usf3.MetadataService.Flow modifyFlow(usf3.MetadataService.Flow flow, String path, String value){
        List<String> pathList = path.split('\\.');
        System.debug('pathList: ' + pathList);
        if(pathList.size() > 1 && pathList[0] == 'Flow') {
            String nodeName = pathList[1].substringBefore('[');
            String nodeValue = pathList[1].substringAfter('[').substringBefore(']');
            //Flow.FlowAssignment[Assign_Email_Template].FlowAssignmentItem[EmailTemplateName].value
            if(nodeName.startsWith('FlowAssignment')) {
                for(usf3.MetadataService.FlowAssignment flowAssignment : flow.assignments) {
                    if(flowAssignment.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        for(usf3.MetadataService.FlowAssignmentItem assignmentItem : flowAssignment.assignmentItems) {
                            if(assignmentItem.assignToReference == assignToReference) {
                                if(pathList[3] == 'value') {
                                    assignmentItem.value = changeValue(assignmentItem.value, value);
                                } else if(pathList[3] == 'operator') {
                                    assignmentItem.operator = value;
                                }
                            }
                        }
                    }
                }
            //Flow.FlowActionCall[Assign_Email_Template].FlowActionCallInputParameter[EmailTemplateName].value
            } else if(nodeName.startsWith('FlowActionCall')) {
                for(usf3.MetadataService.FlowActionCall flowActionCall : flow.actionCalls) {
                    if(flowActionCall.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        for(usf3.MetadataService.FlowActionCallInputParameter inputParameter : flowActionCall.inputParameters) {
                            if(inputParameter.name == assignToReference) {
                                if(pathList[3] == 'value') {
                                    inputParameter.value = changeValue(inputParameter.value, value);
                                } 
                            }
                        }
                    }
                }

                //Flow.FlowApexPluginCall[Assign_Email_Template].FlowApexPluginCallInputParameter[EmailTemplateName].value
            } else if(nodeName.startsWith('FlowApexPluginCall')) {
                for(usf3.MetadataService.FlowApexPluginCall flowApexPluginCall : flow.apexPluginCalls) {
                    if(flowApexPluginCall.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        for(usf3.MetadataService.FlowApexPluginCallInputParameter inputParameter : flowApexPluginCall.inputParameters) {
                            if(inputParameter.name == assignToReference) {
                                if(pathList[3] == 'value') {
                                    inputParameter.value = changeValue(inputParameter.value, value);
                                } 
                            }
                        }
                    }
                }
                //Flow.FlowRecordCreate[Assign_Email_Template].FlowInputFieldAssignment[EmailTemplateName].value
            }else if(nodeName.startsWith('FlowRecordCreate')) {
                for(usf3.MetadataService.FlowRecordCreate flowRecordCreate : flow.recordCreates) {
                    if(flowRecordCreate.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        for(usf3.MetadataService.FlowInputFieldAssignment inputParameter : flowRecordCreate.inputAssignments) {
                            if(inputParameter.field == assignToReference) {
                                if(pathList[3] == 'value') {
                                    inputParameter.value = changeValue(inputParameter.value, value);
                                } 
                            }
                        }
                    }
                }
                //Flow.FlowRecordUpdate[Assign_Email_Template].FlowInputFieldAssignment[EmailTemplateName].value
                //Flow.FlowRecordUpdate[Assign_Email_Template].FlowRecordFilter[EmailTemplateName].value
            } else if(nodeName.startsWith('FlowRecordUpdate')) {
                for(usf3.MetadataService.FlowRecordUpdate flowRecordUpdate : flow.recordUpdates) {
                    if(flowRecordUpdate.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        if(pathList[2].startsWith('FlowInputFieldAssignment')) {
                            for(usf3.MetadataService.FlowInputFieldAssignment inputParameter : flowRecordUpdate.inputAssignments) {
                                if(inputParameter.field == assignToReference) {
                                    if(pathList[3] == 'value') {
                                        inputParameter.value = changeValue(inputParameter.value, value);
                                    } 
                                }
                            }
                        } else if(pathList[2].startsWith('FlowRecordFilter')) {
                            for(usf3.MetadataService.FlowRecordFilter inputParameter : flowRecordUpdate.filters) {
                                if(inputParameter.field == assignToReference) {
                                    if(pathList[3] == 'value') {
                                        inputParameter.value = changeValue(inputParameter.value, value);
                                    } 
                                }
                            }
                        }
                    }
                }
                //Flow.FlowDecision[Assign_Email_Template].FlowRule[EmailTemplateName].FlowCondition[EmailTemplateName].rightValue
                //Flow.FlowDecision[Assign_Email_Template].FlowRule[EmailTemplateName].FlowCondition[EmailTemplateName].leftValueReference
            } else if(nodeName.startsWith('FlowDecision')) {
                for(usf3.MetadataService.FlowDecision flowDecision : flow.decisions) {
                    if(flowDecision.name == nodeValue) {
                        String assignToReference = pathList[2].substringAfter('[').substringBefore(']');
                        for(usf3.MetadataService.FlowRule flowRule : flowDecision.rules) {
                            if(flowRule.name == assignToReference) {
                                assignToReference = pathList[3].substringAfter('[').substringBefore(']');
                                for(usf3.MetadataService.FlowCondition flowCondition : flowRule.conditions) {
                                    if(flowCondition.leftValueReference == assignToReference && pathList[4] == 'rightValue') {
                                        flowCondition.rightValue = changeValue(flowCondition.rightValue, value);
                                    }
                                }
                            }
                        }
                    }
                }
                //Flow.FlowChoice[segmentName]
            }else if(nodeName.startsWith('FlowChoice')) {
                for(usf3.MetadataService.FlowChoice flowChoice : flow.choices) {
                    if(flowChoice.name == nodeValue) { 
                        flowChoice.value = changeValue(flowChoice.value, value);
                    }
                }

                //Flow.FlowVariable[segmentName]
            } else if(nodeName == 'FlowVariable') {
                for(usf3.MetadataService.FlowVariable FlowVariable : flow.variables) {
                    if(FlowVariable.name == nodeValue) { 
                        FlowVariable.value = changeValue(FlowVariable.value, value);
                    }
                }
            
            //Flow.FlowConstant[segmentName]
            } else if(nodeName == 'FlowConstant') {
                for(usf3.MetadataService.FlowConstant flowConstant : flow.constants) {
                    if(flowConstant.name == nodeValue) { 
                        flowConstant.value = changeValue(flowConstant.value, value);
                    }
                }
            
            } else if(nodeName == 'FlowStart') {
                if(pathList[2] == 'FlowSchedule') {
                    Datetime dt = DateTime.parse(value);
                    flow.start.schedule.startDate = dt.date();
                    flow.start.schedule.startTime = '' + dt.format('HH:mm:ss');

                }
                
            }
        }

        return flow;
    }

    static usf3.MetadataService.FlowElementReferenceOrValue changeValue(usf3.MetadataService.FlowElementReferenceOrValue flowValue, String value) {
        if(flowValue.booleanValue != null) {
            flowValue.booleanValue = Boolean.valueOf(value);
        } if(flowValue.dateTimeValue != null) {
            flowValue.dateTimeValue = DateTime.parse(value);
        } if(flowValue.dateValue != null) {
            flowValue.dateValue = Date.parse(value);
        } if(flowValue.elementReference != null) {
            flowValue.elementReference = value;
        } if(flowValue.numberValue != null) {
            flowValue.numberValue = Double.valueOf(value);
        } if(flowValue.stringValue != null) {
            flowValue.stringValue = value;
        }

        return flowValue;
    }

    global class Request {
      

        @InvocableVariable(required=true)
        global String flowName;

        @InvocableVariable(required=true)
        global String entityPath1;

        @InvocableVariable(required=true)
        global String value1;

        @InvocableVariable
        global String entityPath2;

        @InvocableVariable
        global String value2;

        @InvocableVariable
        global String entityPath3;

        @InvocableVariable
        global String value3;

        @InvocableVariable
        global String entityPath4;

        @InvocableVariable
        global String value4;

        @InvocableVariable
        global String entityPath5;

        @InvocableVariable
        global String value5;

        @InvocableVariable
        global String action; //expects enum values 'clone', 'overwrite' or 'none' default is 'clone'

        @InvocableVariable
        global String newFlowName;

    }

    global class Result {


        @InvocableVariable
        global usf3.MetadataService.Flow modifiedFlowMetadata;

        @InvocableVariable
        global String errors;



    }

    global static String filterLabelToApiName(String flowName) {
        return flowName.replaceAll('[^a-zA-Z0-9]+', '_');
    }
    public class InvocableActionException extends Exception{}
}
