import { LightningElement, api } from 'lwc';
import publishFlowOrchestrationEvent from '@salesforce/apex/WorkGuidePlusController.publishFlowOrchestrationEvent'
const FINISHED_STATUS = 'FINISHED';
const FINISHED_SCREEN_STATUS = 'FINISHED_SCREEN';
const SHOW_WORK_ITEM_NAME = 'ShowWorkItems';
const WORK_GUIDE_LABEL = 'Work Guide Plus';
const COMPLETED_STATUS = 'Completed';
const STRING_TYPE = 'String';
const RECORD_ID_FIELD_NAME = 'recordId';

export default class WorkGuidePlus extends LightningElement {
    orchestrationStepId;
    workItemId;
    screenFlowAPIName;
    showWorkItemsFlowName = SHOW_WORK_ITEM_NAME;
    workGuideTitle = WORK_GUIDE_LABEL
    screenFlowInputs = '';
    orchestrationStepRun;
    workItemIsSelected = false;
    showSpinner = false;
    @api recordId;
    @api delay = 2;
    get flowInputs() {
        if(this.screenFlowInputs) {
            let outputVariables = JSON.parse(this.screenFlowInputs);
            let hasRecordId = false;
            outputVariables.forEach(
                item => {
                    if(item.name === RECORD_ID_FIELD_NAME) {
                        hasRecordId = true;
                    }
                }
            );
            if(!hasRecordId && this.recordId) {
                outputVariables.push({name:RECORD_ID_FIELD_NAME,type:STRING_TYPE,value:this.recordId});
            }
            return outputVariables;
        } else {
            if(this.recordId) {
                return [{name:RECORD_ID_FIELD_NAME,type:STRING_TYPE,value:this.recordId}];
            }
            return [];
        }
    }
    handleShowWorkItemsStatusChange(event) {
        if(event.detail.status === FINISHED_STATUS || event.detail.status === FINISHED_SCREEN_STATUS) {
            event.detail.outputVariables.forEach(
                item => {
                    this[item.name] = item.value;
                }
            );
            this.workItemIsSelected = true;
        }
    }

    handleScreenFlowStatusChange(event) {
        if(event.detail.status === FINISHED_STATUS || event.detail.status === FINISHED_SCREEN_STATUS) {
            this.showSpinner =  true;
            publishFlowOrchestrationEvent(
                {
                    stepInstanceId : this.orchestrationStepId,
                    orchestrationInstanceId : this.orchestrationStepRun,
                    eventPayload : event.detail.outputVariables ? JSON.stringify(event.detail.outputVariables) : '',
                    stepStatus : COMPLETED_STATUS
                }
            ).then(
                () => {
                    setTimeout(
                        () => {
                            this.showSpinner = false;
                            this.workItemIsSelected = false;
                        }, this.delay * 1000
                    );
                }
            ).catch(
                (error) => {console.log('error', error)}
            );
        }
    }

    showWorkItem(event) {
        this.workItemIsSelected = false;
    }
}