import { LightningElement, api } from 'lwc';
import getFlowVersions from '@salesforce/apex/FlowsSelecterController.getFlowVersions';
export default class FlowsSelecter extends LightningElement {
    @api selectedFlow1APIName = '';
    @api selectedFlow2APIName = '';

    flow1APIviersionList = [];
    get flow1VersionOptionList() {
        return  this.flow1APIviersionList.map(item => {
            return {value : ''+ item.VersionNumber, label : '' + item.VersionNumber};
        });
    }

    flow1Option = 'Latest';
    flow2Option = 'Latest';
    flow2APIviersionList = [];


    get flow2VersionOptionList() {
        return  this.flow2APIviersionList.map(item => {
            return {value : ''+ item.VersionNumber, label : '' + item.VersionNumber};
        });
    }

    radioGroupOptionList =[
        { label: 'Latest', value: 'Latest' },
        { label: 'Active', value: 'Active' },
        { label: 'Specific Version', value: 'Specific Version' },
    ];
    changeFlow1Name(event) {
        console.log('event');
        console.log('event', event);
        this.selectedFlow1APIName = event.detail.value;

        getFlowVersions({flowAPIName : this.selectedFlow1APIName}).then(
            result => {
                console.log('result', result);
                this.flow1APIviersionList = result;
            }
        ).catch(
            error => {
                console.error(error);
            }
        );
    }

    changeFlow2Name(event) {
        console.log('event');
        console.log('event', event);
        this.selectedFlow2APIName = event.detail.value;

        getFlowVersions({flowAPIName : this.selectedFlow2APIName}).then(
            result => {
                console.log('result', result);
                this.flow2APIviersionList = result;
            }
        ).catch(
            error => {
                console.error(error);
            }
        );
    }

    changeFlow1Option(event) {
        this.flow1Option = event.detail.value;
        console.log(this.flow1Option);
    }

    changeFlow2Option(event) {
        this.flow2Option = event.detail.value;
        console.log(this.flow2Option);
    }

}