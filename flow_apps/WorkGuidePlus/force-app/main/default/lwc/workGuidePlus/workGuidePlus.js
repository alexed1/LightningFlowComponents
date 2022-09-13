import { LightningElement } from 'lwc';
import publishFlowOrchestrationEvent from '@salesforce/apex/WorkGuidePlusController.publishFlowOrchestrationEvent'
const FINISHED_STATUS = 'FINISHED';
const FINISHED_SCREEN_STATUS = 'FINISHED_SCREEN';
const SHOW_WORK_ITEM_NAME = 'ShowWorkItems';
const WORK_GUIDE_LABEL = 'Work Guide Plus';
const COMPLETED_STATUS = 'Completed';

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
    get flowInputs() {
        if(this.screenFlowInputs) {
            return JSON.parse(this.screenFlowInputs);
        } else {
            return null;
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
        console.log(event);

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
                        }, 3000
                    );
                }
            ).catch(
                () => {console.log('error')}
            );
        }
    }

    showWorkItem(event) {
        this.workItemIsSelected = false;
    }
}