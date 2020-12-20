[
    buildVersion=51.0, 
    instances=(
        ConnectApi.OrchestrationInstance
            [
                buildVersion=51.0, 
                id=0jE9A000000000VUAQ, 
                pausedInterviewId=0Fo9A0000002HdcSAE, 
                stageInstances=(
                    ConnectApi.OrchestrationStageInstance[
                        buildVersion=51.0, 
                        id=0jF9A000000000VUAQ,
                         label=Submit Content, 
                         name=Submit_Content, 
                         position=0, 
                         stageStepInstances=(
                             ConnectApi.OrchestrationStepInstance[
                                 buildVersion=51.0,
                                  id=0jL9A000000000VUAQ, 
                                  label=Submit Content for Approval,
                                   name=Submit_Content_for_Approval, 
                                   status=InProgress, 
                                   type=Task,
                                 workAssignments=(
                                     ConnectApi.OrchestrationWorkAssignment[
                                         buildVersion=51.0, 
                                         assigneeId=null,
                                          contextRecordId=0019A00000Gg58lQAB,
                                           description=null, 
                                           id=0jf9A0000000006QAA, 
                                           label=Submit Content,
                                            screenFlowId=3009A0000000JxIQAU, 
                                            screenFlowInputParameters={"recordId":["0019A00000Gg58lQAB"],"appProcessStepInstanceId":["0jL9A000000000V"],"appProcessInstanceId":["0jE9A000000000V"]}, 
                                            status=NotStarted
                                    ]
                                )
                            ]
                        ), status=InProgress
                     ]
                ),
                status=InProgress
            ]
        )
]
20:34:44.2 (28141890)|STATEMENT_EXECUTE|[36]