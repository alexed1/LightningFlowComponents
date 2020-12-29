import {LightningElement, api, wire} from 'lwc';
import userId from '@salesforce/user/Id';
import getActiveWorkItemsByRecordId from '@salesforce/apex/WorkGuideController.getActiveWorkItemsByRecordId';
import getWorkItemDetail from '@salesforce/apex/WorkGuideController.getWorkItemDetail';
import dispatchAppProcessEvent from '@salesforce/apex/WorkGuideController.dispatchAppProcessEvent';


export default class WorkGuide extends LightningElement {
    @api recordId;
    @api flowHeight = 300;
    curUserId = userId;
    curWorkItems;

    stageToStepsNameMap;
    stepToFlowMap;
    _currentStepName;
    _currentStage;
    _currentDefinitionId;
    _currentOrchInstanceId;
    _currentOrchStepInstanceId;
    _currentWorkItemId; 
    appProcess = {};
    url;
    innerWidth = 400;
    isLoadCompleted = false;
    isFlowStarted = false;
    error;

    labels = {
        header: 'Work Guide',
        noWorkAvailable: 'No work is currently available'
    }

    constants = {
        flowStatusStarted: 'STARTED',
        flowStatusFinished: 'FINISHED'
    }

    @api get currentStep() {
        return this._currentStepName;
    }

    set currentStep(value) {
        this._currentStepName = value;
    }

    connectedCallback() {
        let sfIdent = 'force.com';
        this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    }

    @wire(getActiveWorkItemsByRecordId, {userId: '$curUserId', recordId: '$recordId'})
    _getActiveWorkItemsByRecordId(response) {
        console.log('getActiveWorkItemsByRecordId returning.... response is:' + JSON.stringify(response));
        if (response.error) {
            console.log(JSON.stringify(response.error));
            this.isLoadCompleted = true;
        } else if (typeof response.data !== undefined) {
            if (response.data) {
                console.log('response from getActiveWorkItemsByRecordId is: ' + JSON.stringify(response.data));

                this.curWorkItems = response.data.workItemRecordIds;

                console.log('now calling getWorkItemDetail');
                getWorkItemDetail({userId : this.curUserId, contextRecordId : this.recordId, workItemRecordId : this.curWorkItems[0]})
                        .then((result) => {
                            console.log('result from getWorkItemDetail: ' + JSON.stringify(result));
                            if (result.error) {
                                console.log('there was an error');
                                console.log(JSON.stringify(result.error));
                                this.isLoadCompleted = true;
                            } else if (typeof result !== undefined) {
                                if (result) {
                                    console.log('processing result data...');
                                    this.appProcess = {
                                        label: 'orchdef',
                                        link: this.url
                                    };
                                    console.log('values: appProcess ' + this.appProcess);
                                    this._currentStepName = result.currentStep__c;
                                    this._currentStage = result.currentStage__c;
                                    this._currentDefinitionId = 'foo';
                                    this._currentOrchInstanceId = result.OrchestrationInstanceId__c //result.data.Id;
                                    this._currentOrchStepInstanceId = result.OrchestrationStepInstanceId__c;
                                    this._currentWorkItemId = this.curWorkItems[0];
                                    this.stageToStepsNameMap = JSON.parse(result.StageStepMapping__c);
                                    this.stepToFlowMap = JSON.parse(result.StepFlowMapping__c);
                                    console.log('values: currentStep ' + this._currentStepName);
                                    console.log('values: stepToFlowMap ' + this.stepToFlowMap);
                                    console.log('values: _currentOrchInstanceId ' + this._currentOrchInstanceId);
                                    console.log('values: _currentOrchStepInstanceId ' + this._currentOrchStepInstanceId);
                                } else {
                                    console.log('typeof check failed');
                                }
                                this.isLoadCompleted = true;
                            }
                            

                            this.error = undefined;
                        })
                        .catch((error) => {
                            this.error = error;
                            //this.contacts = undefined;
                        });
                
                
            }
            this.isLoadCompleted = true;
        }

    }

    /* @wire(getWorkItemDetail, {userId: '$curUserId', contextRecordId: '$contextRecordId', workItemRecordId: '$curWorkItems'})
    _getWorkItemDetail(response) {
        console.log('getWorkItemDetail returning....');
        if (response.error) {
            console.log(JSON.stringify(response.error));
            this.isLoadCompleted = true;
        } else if (typeof response.data !== undefined) {
            if (response.data) {
                this.appProcess = {
                    label: response.data.App_Process_Definition__r.Name,
                    link: this.url + '/' + response.data.App_Process_Definition__c
                };
                this._currentStepName = response.data.currentStep__c;
                this._currentStage = response.data.currentStage__c;
                this._currentDefinitionId = response.data.App_Process_Definition__c;
                this._currentOrchInstanceId = response.data.Id;
                this.stageToStepsNameMap = JSON.parse(response.data.App_Process_Definition__r.StageStepMappings__c);
                this.stepToFlowMap = JSON.parse(response.data.App_Process_Definition__r.StepFlowMappings__c);
            }
            this.isLoadCompleted = true;
        }

    } */

    get curFlowName() {
        if (this.stepToFlowMap && this.stepToFlowMap[this._currentStepName]) {
            return this.stepToFlowMap[this._currentStepName];
        }
    }

    get isNoWorkAvailable() {
        return (this.isLoadCompleted && (!this.stepToFlowMap || !this.stepToFlowMap[this._currentStepName]));
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
        params.push(this.generateParam('orchestrationInstanceId', 'String', this._currentOrchInstanceId));
        params.push(this.generateParam('orchestrationStepName', 'String', this._currentStepName));
        params.push(this.generateParam('orchestrationStepInstanceId', 'String', this._currentOrchStepInstanceId));
        params.push(this.generateParam('orchestrationWorkItemId', 'String', this._currentWorkItemId));
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
            instanceId: this._currentOrchInstanceId,
            step: this._currentStepName,
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