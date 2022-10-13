import { LightningElement, api, track, wire } from 'lwc';
import flowLabels from '@salesforce/apex/usf3.FlexCardController.getFlowLabel';
import {FlowAttributeChangeEvent,FlowNavigationNextEvent,FlowNavigationFinishEvent} from 'lightning/flowSupport';
import LightningModal from 'lightning/modal';

export default class fsc_ActionList extends LightningModal {

    @api
    availableActions = [];

    @api
    flowNames;

    @api 
    recordId;
    
    @track
    openModal = false;

    visibleFlows = [];

    @api
    flowData = [];

    @api
    displayMenu;

    @api
    choiceType;

    @api
    displayList;

    @api
    buttonLabel = 'Actions';

    @track
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

    launchFlowMenu(event) {
        let flowName = event.detail.value;
        this.flowNameToInvoke = flowName;
        this.showModal();
    }
    
    handleFlowStatusChange(event) {
        console.log('flow status change:');
        console.log(JSON.stringify(event.detail));
        if (this.availableActions.find((action) => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
            console.log('NEXT')
        }
        if (event.detail.status === 'FINISHED') {           
            this.closeModal();
            console.log('FINISHED')
        }
        //if (event.detail.status === 'FINISHED') 
         //   this.flowFinishBehavior === 'NONE';
           // this.closeModal();
        
        
        
    }

   

    get displayMenu() {                
            if(this.choiceType == 'menu')
            return true;
            return false;        
    }

    get displayList() {                
        if(this.choiceType == 'list')
        return true;
        return false;        
}
              
    get flowParams() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId || ''
            },
            
        ];
    }
        
       
}
