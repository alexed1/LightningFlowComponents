import {LightningElement, api, wire} from 'lwc';
import userId from '@salesforce/user/Id';
import getActiveWorkItemsByRecordId from '@salesforce/apex/WorkGuideController.getActiveWorkItemsByRecordId';
import getWorkItemDetail from '@salesforce/apex/WorkGuideController.getWorkItemDetail';
import dispatchAppProcessEvent from '@salesforce/apex/WorkGuideController.dispatchAppProcessEvent';


export default class WorkGuide extends LightningElement {
    @api recordId;
    @api flowHeight = 300;
    curUserId = userId;
    stageToStepsNameMap;
    stepToFlowMap;
    _currentStep;
    _currentStage;
    _currentDefinitionId;
    _currentInstanceId;
    appProcess = {};
    url;
    innerWidth = 400;
    isLoadCompleted = false;
    isFlowStarted = false;

    labels = {
        header: 'Work Guide',
        noWorkAvailable: 'No work is currently available'
    }

    constants = {
        flowStatusStarted: 'STARTED',
        flowStatusFinished: 'FINISHED'
    }

    @api get currentStep() {
        return this._currentStep;
    }

    set currentStep(value) {
        this._currentStep = value;
    }

    connectedCallback() {
        let sfIdent = 'force.com';
        this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    }

    @wire(getActiveWorkItemsByRecordId, {userId: '$curUserId', recordId: '$recordId'})
    _getActiveWorkItemsByRecordId(response) {
        if (response.error) {
            console.log(JSON.stringify(response.error));
            this.isLoadCompleted = true;
        } else if (typeof response.data !== undefined) {
            if (response.data) {
                console.log('response from getActiveWorkItemsByRecordId is: ' + JSON.stringify(response.data));
                //this.labels = response.data.;
                /* this._currentStep = response.data.currentStep__c;
                this._currentStage = response.data.currentStage__c;
                this._currentDefinitionId = response.data.App_Process_Definition__c;
                this._currentInstanceId = response.data.Id;
                this.stageToStepsNameMap = JSON.parse(response.data.App_Process_Definition__r.StageStepMappings__c);
                this.stepToFlowMap = JSON.parse(response.data.App_Process_Definition__r.StepFlowMappings__c); */
            }
            this.isLoadCompleted = true;
        }

    }

    @wire(getWorkItemDetail, {userId: '$curUserId', recordId: '$recordId'})
    _getWorkItemDetail(response) {
        if (response.error) {
            console.log(JSON.stringify(response.error));
            this.isLoadCompleted = true;
        } else if (typeof response.data !== undefined) {
            if (response.data) {
                this.appProcess = {
                    label: response.data.App_Process_Definition__r.Name,
                    link: this.url + '/' + response.data.App_Process_Definition__c
                };
                this._currentStep = response.data.currentStep__c;
                this._currentStage = response.data.currentStage__c;
                this._currentDefinitionId = response.data.App_Process_Definition__c;
                this._currentInstanceId = response.data.Id;
                this.stageToStepsNameMap = JSON.parse(response.data.App_Process_Definition__r.StageStepMappings__c);
                this.stepToFlowMap = JSON.parse(response.data.App_Process_Definition__r.StepFlowMappings__c);
            }
            this.isLoadCompleted = true;
        }

    }

    get curFlowName() {
        if (this.stepToFlowMap && this.stepToFlowMap[this._currentStep]) {
            return this.stepToFlowMap[this._currentStep];
        }
    }

    get isNoWorkAvailable() {
        return (this.isLoadCompleted && (!this.stepToFlowMap || !this.stepToFlowMap[this._currentStep]));
    }

    get pathStructure() {
        let passedCurrent = false;
        if (this.stageToStepsNameMap) {
            let pathStructure = [];
            Object.keys(this.stageToStepsNameMap).forEach(curStage => {
                let stageClass = 'slds-is-incomplete';
                if (this._currentStage) {
                    if (!passedCurrent && curStage === this._currentStage) {
                        passedCurrent = true;
                    }
                    let isCurrent = curStage === this._currentStage;
                    stageClass = isCurrent ? 'slds-is-current slds-is-active' : (passedCurrent ? 'slds-is-incomplete' : 'slds-is-complete');
                }
                pathStructure.push({
                    stageName: curStage,
                    stageClass: 'slds-path__item ' + stageClass
                });
            });
            return pathStructure;
        }
    }

    get flowParams() {
        let params = [];
        params.push(this.generateParam('appProcessInstanceId', 'String', this._currentInstanceId));
        params.push(this.generateParam('appProcessStepName', 'String', this._currentStep));
        params.push(this.generateParam('recordId', 'String', this.recordId));
        return JSON.stringify(params);
    }

    generateParam(name, type, value) {
        return {
            name: name,
            type: type,
            value: value
        };
    }

    handleFlowStatusChange(event) {
        if (event.detail.flowStatus === this.constants.flowStatusStarted) {
            this.isFlowStarted = true;
        } else if (event.detail.flowStatus === this.constants.flowStatusFinished) {
            this.fireAppProcessEvent(event.detail.flowStatus, JSON.stringify(event.detail.flowParams));
        }
    }

    fireAppProcessEvent(status, parameters) {

        dispatchAppProcessEvent({
            definitionId: this._currentDefinitionId,
            instanceId: this._currentInstanceId,
            step: this._currentStep,
            status: status,
            parameters: parameters
        }).then(result => {
            if (!result.isSuccess) {
                console.log(result.message);
            }
        }).catch(error => {
            console.log(error);
        });

    }

    renderedCallback() {
        this.determineInnerWidth();
    }

    handleStageClick(event) {
        // this.currentStep = event.target.name;
    }

    determineInnerWidth() {
        let grid = this.template.querySelector('.slds-grid');
        if (grid) {
            this.innerWidth = grid.offsetWidth;
        }
    }
}