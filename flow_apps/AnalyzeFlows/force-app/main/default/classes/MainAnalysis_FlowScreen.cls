public with sharing class MainAnalysis_FlowScreen {
    public static FlowAnalysis analyzeFlowScreens(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.screens != null && secondFlow.screens != null) {
            for(usf3.MetadataService.FlowScreen initFlowScreen : initFlow.screens) {
                for(usf3.MetadataService.FlowScreen secondFlowScreen : secondFlow.screens) {
                    if(initFlowScreen.name == secondFlowScreen.name) {
                        if(initFlowScreen.allowBack != secondFlowScreen.allowBack) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'allowBack has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                String.valueOf(secondFlowScreen.allowBack),
                                String.valueOf(initFlowScreen.allowBack)
                            ));
                        }
                        if(initFlowScreen.allowFinish != secondFlowScreen.allowFinish) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'allowFinish has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                String.valueOf(secondFlowScreen.allowFinish),
                                String.valueOf(initFlowScreen.allowFinish)
                            ));
                        }
                        if(initFlowScreen.allowPause != secondFlowScreen.allowPause) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'allowPause has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                String.valueOf(secondFlowScreen.allowPause),
                                String.valueOf(initFlowScreen.allowPause)
                            ));
                        }
                        if(initFlowScreen.backButtonLabel != secondFlowScreen.backButtonLabel) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'backButtonLabel has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                secondFlowScreen.backButtonLabel,
                                initFlowScreen.backButtonLabel
                            ));
                        }
                        if(initFlowScreen.helpText != secondFlowScreen.helpText) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'helpText has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                secondFlowScreen.helpText,
                                initFlowScreen.helpText
                            ));
                        }
                        if(initFlowScreen.nextOrFinishButtonLabel != secondFlowScreen.nextOrFinishButtonLabel) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'nextOrFinishButtonLabel has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                secondFlowScreen.nextOrFinishButtonLabel,
                                initFlowScreen.nextOrFinishButtonLabel
                            ));
                        }
                        if(initFlowScreen.pauseButtonlabel != secondFlowScreen.pauseButtonlabel) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'pauseButtonlabel has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                secondFlowScreen.pauseButtonlabel,
                                initFlowScreen.pauseButtonlabel
                            ));
                        }
                        if(initFlowScreen.pausedText != secondFlowScreen.pausedText) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'pausedText has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                secondFlowScreen.pausedText,
                                initFlowScreen.pausedText
                            ));
                        }
                        if(initFlowScreen.showFooter != secondFlowScreen.showFooter) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'showFooter has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                String.valueOf(secondFlowScreen.showFooter),
                                String.valueOf(initFlowScreen.showFooter)
                            ));
                        }
                        if(initFlowScreen.showHeader != secondFlowScreen.showHeader) {
                            changeList.add(new ElementStatusChange(
                                initFlowScreen.name,
                                initFlowScreen.label,
                                'showFooter has been modified',
                                initFlowScreen.type,
                                initFlowScreen.description,
                                '',
                                String.valueOf(secondFlowScreen.showFooter),
                                String.valueOf(initFlowScreen.showFooter)
                            ));
                        }

                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initFlowScreen.connector, secondFlowScreen.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initFlowScreen.name;
                            newChange.label = initFlowScreen.label;
                            newChange.elementType = initFlowScreen.type;
                            changeList.add(newChange);
                        }
                        
                        // changeList.addAll(detectNewScreenEntities(initFlowScreen, initFlowScreen));
                        // changeList.addAll(detectRemovedScreenEntities(initFlowScreen, initFlowScreen));
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;
    }

    public static List<ElementStatusChange> detectNewScreenEntities(usf3.MetadataService.FlowScreen initFlowScreen, usf3.MetadataService.FlowScreen secondFlowScreen) {
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        for(usf3.MetadataService.FlowScreenField initFlowScreenField : initFlowScreen.fields) {
            Boolean entityIsExist = false;
            for(usf3.MetadataService.FlowScreenField secondFlowScreenField : secondFlowScreen.fields) {
                if(initFlowScreenField.name == secondFlowScreenField.name) {
                    entityIsExist = true;
                    break;
                }
            }

            if(!entityIsExist) {
                changeList.add(new ElementStatusChange(
                                initFlowScreenField.name,
                                initFlowScreenField.name,
                                'New ScreenField detected',
                                initFlowScreenField.type,
                                initFlowScreenField.description,
                                '',
                                'N/A',
                                String.valueOf(initFlowScreenField.name)
                            ));
            }
        }

        return changeList;
    }

    public static List<ElementStatusChange> detectRemovedScreenEntities(usf3.MetadataService.FlowScreen initFlowScreen, usf3.MetadataService.FlowScreen secondFlowScreen) {
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        for(usf3.MetadataService.FlowScreenField  secondFlowScreenField : secondFlowScreen.fields) {
            Boolean entityIsRemoved = true;
            for(usf3.MetadataService.FlowScreenField initFlowScreenField : initFlowScreen.fields) {
                if(initFlowScreenField.name == secondFlowScreenField.name) {
                    entityIsRemoved = false;
                    break;
                }
            }

            if(entityIsRemoved) {
                changeList.add(new ElementStatusChange(
                                secondFlowScreenField.name,
                                secondFlowScreenField.name,
                                'Removed ScreenField detected',
                                secondFlowScreenField.type,
                                secondFlowScreenField.description,
                                '',
                                String.valueOf(secondFlowScreenField.name),
                                'N/A'
                               
                            ));
            }
        }

        return changeList;
    }

}
