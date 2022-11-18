public with sharing class MainAnalysis_DetectRemovedFlowEntities {
    public static FlowAnalysis detectRemovedFlowEntities(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = new FlowAnalysis();
        result.baseFlowName = initFlow.fullName;
        result.baseFlowVersion = (Integer)initFlow.apiVersion;
        result.baseFlowStatus = initFlow.status;
        result.comparisonFlowName = secondFlow.fullName;
        result.comparisonFlowVersion = (Integer)secondFlow.apiVersion;
        result.comparisonFlowStatus = secondFlow.status;
        result.analysisTime = DateTime.now();
        
        Map<String, Object> initFlowMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initFlow));
        Map<String, Object> secondFlowMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondFlow));
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        for(String initFlowKey : secondFlowMap.keySet()) {
            if(!initFlowKey.endsWith('_info')) {
                Object secondFlowItem = secondFlowMap.get(initFlowKey);
                Object initFlowItem = initFlowMap.get(initFlowKey);
                if(initFlowItem == null) {
                    if(secondFlowItem instanceof List<Object>) {
                        for(Object obj : (List<Object>)secondFlowItem ) {
                            Map<String, Object> initFlowNode = (Map<String, Object>) obj;
                            ElementStatusChange newChange = new ElementStatusChange();
                            newChange.name = (String)initFlowNode.get('name');
                            newChange.label = (String)initFlowNode.get('label');
                            newChange.changeType = 'Removed';
                            newChange.description = (String)initFlowNode.get('description');
                            newChange.elementType = (String)initFlowNode.get('type');
                            changeList.add(newChange);
                        }
                    }
                } else if(secondFlowItem != null){
                    if(initFlowItem instanceof List<Object>) {
                        for(Object obj : (List<Object>)secondFlowItem ) {
                            if(obj instanceof Map<String, Object>) {
                                Boolean nodeIsNew = true;
                                Map<String, Object> initFlowNode = (Map<String, Object>) obj;
                                for(Object obj1 : (List<Object>)initFlowItem ) {
                                    Map<String, Object> secondFlowNode = (Map<String, Object>) obj1;
                                    if(initFlowNode.get('name') == secondFlowNode.get('name')) {
                                        nodeIsNew = false;
                                        break;
                                    }
                                }
                                if(nodeIsNew) {
                                    ElementStatusChange newChange = new ElementStatusChange();
                                    newChange.name = (String)initFlowNode.get('name');
                                    newChange.label = (String)initFlowNode.get('label');
                                    newChange.changeType = 'Removed';
                                    newChange.description = (String)initFlowNode.get('description');
                                    newChange.elementType = (String)initFlowNode.get('type');
                                    changeList.add(newChange);
                                }
                            }

                           
                        }
                    } else if(!isPrimitiveObject(secondFlowItem)){
                        System.debug('isObject ' + initFlowKey);
                        System.debug(secondFlowItem);
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;

    }

    static Boolean isPrimitiveObject(Object obj) {
        return obj instanceof String || obj instanceof Boolean || obj instanceof Integer || obj instanceof Double;
    }
}

