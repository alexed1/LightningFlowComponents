/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 05-31-2023
 * @last modified by  : Josh Dayment
**/
import { LightningElement, api, track, wire } from 'lwc';
import flowLabels from '@salesforce/apex/usf3.FlexCardController.getFlowLabel';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import LightningModal from 'lightning/modal';
import fsc_modalFlow from 'c/fsc_modalFlow';

export default class fsc_ActionList extends LightningModal {


    @api
    flowNames;

    @api
    recordId;

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
    @wire(flowLabels, { flowApiNames: '$visibleFlows' })
    flowInfo({ data, error }) {
        if (data) {
            Object.entries(data).forEach(([key, value]) => {
                this.flowData.push({ apiName: key, label: value });
            })
            this.flowData = [...this.flowData];
        }
    }

    //Open Modal from Menu
    async handleMenuClick(event) {

        let flowName = event.detail.value;
        const result = await fsc_modalFlow.open({

            label: 'New Label',
            size: 'large',
            description: 'This is a sub action launched from the card',
            flowNameToInvoke: flowName,
            flowParams: this.flowParams,

        });

    }

    //Open Modal from List  
    async handleListClick(event) {

        let flowName = event.detail.name;
        const result = await fsc_modalFlow.open({

            label: 'New Label',
            size: 'large',
            description: 'This is a sub action launched from the card',
            flowNameToInvoke: flowName,
            flowParams: this.flowParams,

        });

    }


    removeDuplicateFlows() {
        let flows = [];
        if (this.flowNames != null) {
            this.flowNames.split(',').forEach(flow => {
                flows.push(flow.trim());
            })
            this.visibleFlows = Array.from(new Set(flows));
        }

    }


    get displayMenu() {
        if (this.choiceType == 'menu')
            return true;
        return false;
    }

    get displayList() {
        if (this.choiceType == 'list')
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
