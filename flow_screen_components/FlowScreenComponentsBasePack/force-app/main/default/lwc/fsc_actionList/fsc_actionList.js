import { LightningElement, api, track, wire } from 'lwc';
import flowLabels from '@salesforce/apex/usf.FlexCardController.getFlowLabel';

export default class fsc_ActionList extends LightningElement {
    @api
    flowNames;

    @api 
    recordId;
    
    @track
    openModal = false;

    visibleFlows = [];

    @api
    flowData = [];

    connectedCallback() {
        this.removeDuplicateFlows();
    }

    //Retrieve flow label and api name and show flow label in UI 
    @wire(flowLabels, {flowApiNames: '$visibleFlows'})
    flowInfo({data, error}) {
        if(data) {
            Object.entries(data).forEach(([key, value]) => {
                this.flowData.push({apiName:key, label:value});
            })
            this.flowData = [...this.flowData];
        }
    }

    removeDuplicateFlows() {
        let flows = [];
        if(this.flowNames != null) {
            this.flowNames.split(',').forEach(flow => {
                flows.push(flow.trim());
                })
            this.visibleFlows = Array.from(new Set(flows));
        }
       
    }


    showModal(){
        this.openModal = true;
    }

    closeModal() {
        this.openModal = false;
        console.log('closing modal');
    }

    launchFlow(event) {
        let flowName = event.currentTarget.dataset.value;
        this.flowNameToInvoke = flowName;
        this.showModal();
    }
    
    handleFlowStatusChange(event) {
        console.log('flow status change:');
        console.log(JSON.stringify(event.detail));
        
    }

    get flowParams() {
        let params = [{name: 'recordId', type: 'String', value: this.recordId || ''}];
        console.log('params is: ' + params);
        return JSON.stringify(params);
    }
}