public with sharing class MainAnalysis_GetRecords {
    public static FlowAnalysis analyzeGetRecords(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.recordLookups != null && secondFlow.recordLookups != null) {
            for(usf3.MetadataService.FlowRecordLookup initRecordLookup : initFlow.recordLookups) {
                for(usf3.MetadataService.FlowRecordLookup secondRecordLookup : secondFlow.recordLookups) {
                    if(initRecordLookup.name == secondRecordLookup.name) {
                        if(initRecordLookup.sortOrder != secondRecordLookup.sortOrder || initRecordLookup.sortField != secondRecordLookup.sortField ) {
                            ElementStatusChange newChange = new ElementStatusChange();
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.changeType = 'Sorting configuration has been modified';
                            newChange.description = initRecordLookup.description;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordLookup.connector, secondRecordLookup.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordLookup.faultConnector, secondRecordLookup.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_FilterConditions(initRecordLookup.filterLogic, secondRecordLookup.filterLogic, initRecordLookup.filters, secondRecordLookup.filters);
                        if(newChange != null) {
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initRecordLookup.object_x, secondRecordLookup.object_x);
                        if(newChange != null) {
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        newChange = SubAnalysis_GetRecordsOutputHandling((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initRecordLookup)),(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondRecordLookup)));
                        if(newChange != null) {
                            newChange.name = initRecordLookup.name;
                            newChange.label = initRecordLookup.label;
                            newChange.elementType = initRecordLookup.type;
                            changeList.add(newChange);
                        }

                        changeList.addAll(FlowElementAnalysisFunctions.subAnalysis_OutputMappings(
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initRecordLookup)), 
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondRecordLookup))
                        ));
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;
    }

    public static ElementStatusChange SubAnalysis_GetRecordsOutputHandling(Map<String, Object> initFlowElementMap, Map<String, Object> secondFlowElementMap) {
        ElementStatusChange newChange;
        if(initFlowElementMap.get('getFirstRecordOnly') != secondFlowElementMap.get('getFirstRecordOnly') 
            || initFlowElementMap.get('outputReference') != secondFlowElementMap.get('outputReference')
            || initFlowElementMap.get('storeOutputAutomatically') != secondFlowElementMap.get('storeOutputAutomatically')
            || JSON.serialize(initFlowElementMap.get('outputAssignments')) != JSON.serialize(secondFlowElementMap.get('outputAssignments'))
            || JSON.serialize(initFlowElementMap.get('queriedFields')) != JSON.serialize(secondFlowElementMap.get('queriedFields'))
        ) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Output Handling Has Been Modified';
            newChange.elementType = 'String';
            newChange.newValue = ' N/A';
            newChange.oldValue = ' N/A';
        }

        return newChange;

    }
}
