import { LightningElement, api, track, wire } from 'lwc';
import flowLabels from '@salesforce/apex/usf3.FlexCardController.getFlowLabel';
import fsc_modalFlow from 'c/fsc_modalFlow';

export default class fsc_ActionList3 extends LightningElement {

    @api
    availableActions = [];

    @api
    flowNames;

    @api 
    recordId;
    
   // @track
    //openModal = false;

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

    @track
    flowParams = [];

    
    flowName;

    
    flowNameToInvoke;

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

    launchFlow(event) {
        let flowName = event.currentTarget.dataset.value;
        this.flowNameToInvoke = flowName;
        this.openModal();
        console.log('flow name: ' + this.flowNameToInvoke);
    }

    launchFlowMenu(event) {
        let flowName = event.detail.value;
        this.flowNameToInvoke = flowName;
        this.openModal();
        console.log('flow name: ' + this.flowNameToInvoke);
    }

   async openModal() {
    
    const result = await fsc_modalFlow.open({
        flowNameToInvoke : this.flowNameToInvoke,
        flowParams :  [
                {
                    name: 'recordId',
                    type: 'String',
                    value: this.recordId || ''
                },
                
            ],
        
        flowFinishBehavior : 'NONE'
    });
    console.log(result);
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

      
       
}
