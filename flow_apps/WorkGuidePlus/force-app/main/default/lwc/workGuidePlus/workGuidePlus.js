import { LightningElement } from 'lwc';
import publishFlowOrchestrationEvent from '@salesforce/apex/WorkGuidePlusController.publishFlowOrchestrationEvent'
const FINISH_STATUS = 'FINISHED';
const SHOW_WORK_ITEM_NAME = 'ShowWorkItems';

export default class WorkGuidePlus extends LightningElement {
    orchestrationStepId;
    workItemId;
    screenFlowAPIName;
    showWorkItemsFlowName = SHOW_WORK_ITEM_NAME;
    screenFlowInputs = '';
    orchestrationStepRun;
    workItemIsSelected = false;
    get flowInputs() {
        if(this.screenFlowInputs) {
            return JSON.parse(this.screenFlowInputs);
        } else {
            return null;
        }
    }
    handleShowWorkItemsStatusChange(event) {
        if(event.detail.status === FINISH_STATUS) {
            event.detail.outputVariables.forEach(
                item => {
                    this[item.name] = item.value;
                }
            );
            //this.showWorkItemsFlowName = '';
            this.workItemIsSelected = true;
        }
        console.log(event);
        // console.log(event.detail.currentStage);
        // console.log(event.detail.flowTitle);
        // console.log(event.detail.outputVariables);
        // console.log(event.detail.status);

    }

    handleScreenFlowStatusChange(event) {
        if(event.detail.status === FINISH_STATUS) {
            publishFlowOrchestrationEvent(
                {
                    stepInstanceId : this.orchestrationStepId,
                    orchestrationInstanceId : this.orchestrationStepRun,
                    eventPayload : JSON.stringify(event.detail.outputVariables),
                    stepStatus : 'Completed'
                }
            ).then(
                () => {
                    console.log('success');
                    this.workItemIsSelected = false;
                    //this.showWorkItemsFlowName = SHOW_WORK_ITEM_NAME;
                }
            ).catch(
                () => {console.log('error')}
            );
        }
    }
}