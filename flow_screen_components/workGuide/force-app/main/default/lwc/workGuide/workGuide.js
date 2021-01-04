import {LightningElement, api, wire} from 'lwc';
import userId from '@salesforce/user/Id';
import getActiveWorkItemsByRecordId from '@salesforce/apex/WorkGuideController.getActiveWorkItemsByRecordId';
import getWorkItemDetail from '@salesforce/apex/WorkGuideController.getWorkItemDetail';
import dispatchAppProcessEvent from '@salesforce/apex/WorkGuideController.dispatchAppProcessEvent';
import orchestrate1 from '@salesforce/resourceUrl/orchestrate1';
import orchestrate2 from '@salesforce/resourceUrl/orchestrate2';

export default class WorkGuide extends LightningElement {
    @api recordId;
    @api flowHeight = 300;
    curUserId = userId;
    curWorkItems;

    availableWorkItems;
    selectedWorkItem;
    displayMode = 'workdetail'; //'worklist' or 'workdetail'

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
    orchestratelogo1 = orchestrate1; //+ 'orchestrate1.png';

    labels = {
        header: 'Orchestrator Work Guide',
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
                if (response.data.workItemRecordIds.length == 1) {
                    this.displayWorkItem(response.data.workItemRecordIds[0]);
                } else if (response.data.workItemRecordIds.length >= 1) {
                    this.displayMode = 'worklist';
                    this.populateWorkItemSelector(response.data.workItemLabels,response.data.workItemRecordIds);
                } else {
                    console.log('0 work items. no work available');
                }
            }
            this.isLoadCompleted = true;
        }

    }


   
    displayWorkItem(workItemRecordId ) {
        console.log('entering displayWorkItem');
        this.displayMode = 'workdetail';
        getWorkItemDetail({userId : this.curUserId, contextRecordId : this.recordId , workItemRecordId : workItemRecordId})
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
                        console.log('values: appProcess ' + JSON.stringify(this.appProcess));
                        this._currentStepName = result.currentStep__c;
                        this._currentStage = result.currentStage__c;
                        this._currentDefinitionId = 'foo';
                        this._currentOrchInstanceId = result.OrchestrationInstanceId__c //result.data.Id;
                        this._currentOrchStepInstanceId = result.OrchestrationStepInstanceId__c;
                        this._currentWorkItemId = result.OrchestrationWorkItemId__c;
                        console.log('currentworkitem is: ' + this._currentWorkItemId);
                        this.stageToStepsNameMap = JSON.parse(result.StageStepMapping__c);
                        this.stepToFlowMap = JSON.parse(result.StepFlowMapping__c);
                        //console.log('values: steptoFlowMap ' +JSON.parse(result.StepFlowMapping__c));
                        //console.log('values: _currentStage ' + this._currentStage);
                        //console.log('values: _currentOrchInstanceId ' + this._currentOrchInstanceId);
                        //console.log('values: _currentOrchStepInstanceId ' + this._currentOrchStepInstanceId);
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

    populateWorkItemSelector(workItemLabels, workItemIds) {
       // let selectionList=['foo', 'bar'];
       console.log('entering populateWorkItemSelector. workItemLabels is: ' + workItemLabels + '  and workItemIds is: ' + workItemIds);
       let selectionOptions = [];
       for(let x = 0; x< workItemLabels.length; x++ ) {
        //console.log('looping...x is: ' + x);
         let selectionOption = {};
         selectionOption['label'] = workItemLabels[x];
         selectionOption['value'] = workItemIds[x];
         selectionOptions.push(selectionOption);
       }
        this.availableWorkItems = selectionOptions;
        //console.log('availableWorkItems is: ' + JSON.stringify(this.availableWorkItems));
    }
  

    get curFlowName() {
        if (this.stepToFlowMap && this.stepToFlowMap[this._currentStepName]) {
            return this.stepToFlowMap[this._currentStepName];
        }
    }

    get isNoWorkAvailable() {
        //console.log('entering isNoWorkAvailable....this.isLoadCompleted is: ' + this.isLoadCompleted);
        //console.log('this.stepToFlowMap is: ' + JSON.stringify(this.stepToFlowMap));
       // console.log('this._currentStepName is ' + this._currentStepName);
        return (this.isLoadCompleted && (!this.stepToFlowMap || !this.stepToFlowMap[this._currentStepName]));
    }

    get isDisplayModeWorkList() {
        return (this.displayMode == 'worklist');
    }

    get pathStructure() {
        let passedCurrent = false;
        if (this.stageToStepsNameMap) {
            let pathStructure = [];
            //console.log('stagetostepsnamemap is: ' + JSON.stringify(this.stageToStepsNameMap));
            Object.keys(this.stageToStepsNameMap).forEach(curStage => {
                let stageClass = 'slds-is-incomplete';
                //console.log('this._currentstage is: ' + this._currentStage + 'and curStage is: ' + curStage);
                if (this._currentStage) {
                    if (!passedCurrent && curStage === this._currentStage) {
                        console.log('setting passedCurrent to true for curStage:' + curStage);
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
            //console.log('pathStructure is: ' + JSON.stringify(pathStructure));
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
    handleWorkItemSelectorChange(event) {
      console.log ('entering handleWorkItemSelectorChange...');
      console.log('value of workitem selection is: ' + event.detail.value);
      this._currentWorkItemId = event.detail.value;
      this.displayWorkItem(event.detail.value);

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