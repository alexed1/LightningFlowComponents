public with sharing class MainAnalysis_FlowStart {

    public static FlowAnalysis analyzeFlowStart(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = new FlowAnalysis();
        result.baseFlowName = initFlow.fullName;
        result.baseFlowVersion = (Integer)initFlow.apiVersion;
        result.baseFlowStatus = initFlow.status;
        result.comparisonFlowName = secondFlow.fullName;
        result.comparisonFlowVersion = (Integer)secondFlow.apiVersion;
        result.comparisonFlowStatus = secondFlow.status;
        result.analysisTime = DateTime.now();
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        ElementStatusChange newChange = detectTriggerChanges(initFlow, secondFlow);
        if(newChange != null) {
            changeList.add(newChange);
        }

        newChange = detectScheduleChanges(initFlow, secondFlow);
        if(newChange != null) {
            changeList.add(newChange);
        }

        if(initFlow.start != null && secondFlow.start != null) {
            newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initFlow.start.connector, secondFlow.start.connector, 'Outbound Primary Connector Path Points To A Different Element');
            if(newChange != null) {
                            newChange.name = 'FlowStart';
                            newChange.label = 'FlowStart';
                            changeList.add(newChange);
            }

            newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initFlow.start.object_x, secondFlow.start.object_x);
            if(newChange != null) {
                            newChange.name = 'FlowStart';
                            newChange.label = 'FlowStart';
                            changeList.add(newChange);
            }

            newChange = FlowElementAnalysisFunctions.SubAnalysis_FilterConditions(initFlow.start.filterLogic, secondFlow.start.filterLogic, initFlow.start.filters, secondFlow.start.filters);
            if(newChange != null) {
                            newChange.name = 'FlowStart';
                            newChange.label = 'FlowStart';
                            changeList.add(newChange);
            }

        }


        result.elementChanges = changeList;
        return result;
    }

    public static ElementStatusChange detectTriggerChanges(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        ElementStatusChange changeElement;
        if(initFlow.start != null && secondFlow.start != null) {
            if(
                initFlow.start.doesRequireRecordChangedToMeetCriteria != secondFlow.start.doesRequireRecordChangedToMeetCriteria ||
                initFlow.start.recordTriggerType != secondFlow.start.recordTriggerType ||
                initFlow.start.triggerType != secondFlow.start.triggerType
            ) {
                changeElement = new ElementStatusChange(
                                'FlowStart',
                                'FlowStart',
                                'A change was detected in the trigger configuration.',
                                initFlow.start.type,
                                null,
                                '',
                                null,
                                null
                );

            }
        }

        return changeElement;
    }

    public static ElementStatusChange detectScheduleChanges(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        ElementStatusChange changeElement;
        Boolean scheduleIsChanged = false;
        if(initFlow.start != null && secondFlow.start != null) {
            if(
                initFlow.start.schedule != null && secondFlow.start.schedule != null &&
                initFlow.start.schedule.frequency != secondFlow.start.schedule.frequency &&
                initFlow.start.schedule.startDate != secondFlow.start.schedule.startDate &&
                initFlow.start.schedule.startTime != secondFlow.start.schedule.startTime 
            ) {
                scheduleIsChanged = true;

            }

            if(
                initFlow.start.scheduledPaths != null && secondFlow.start.scheduledPaths != null
            ) {
                if(initFlow.start.scheduledPaths.size() != secondFlow.start.scheduledPaths.size()) {
                    scheduleIsChanged = true;
                }

                for(usf3.Flow.FlowScheduledPath initScheduledPath : initFlow.start.scheduledPaths ) {
                    Boolean pathIsNew = true;
                    for(usf3.Flow.FlowScheduledPath secondScheduledPath : secondFlow.start.scheduledPaths ) {
                        if(initScheduledPath.name == secondScheduledPath.name) {
                            pathIsNew = false;
                            if(
                                initScheduledPath.maxBatchSize != secondScheduledPath.maxBatchSize ||
                                initScheduledPath.offsetNumber != secondScheduledPath.offsetNumber ||
                                initScheduledPath.offsetUnit != secondScheduledPath.offsetUnit ||
                                initScheduledPath.pathType != secondScheduledPath.pathType ||
                                initScheduledPath.recordField != secondScheduledPath.recordField ||
                                initScheduledPath.timeSource != secondScheduledPath.timeSource
                            ) {
                                scheduleIsChanged = true;
                            }
                        }
                    }

                    scheduleIsChanged =  pathIsNew ? true : scheduleIsChanged;
                }
                

            }
        }

        if(scheduleIsChanged) {
            changeElement = new ElementStatusChange(
                                'FlowStart',
                                'FlowStart',
                                'A change was detected in the trigger configuration.',
                                'Schedule',
                                'Schedule',
                                '',
                                null,
                                null
                );
        }

        return changeElement;
    }
}
