import { LightningElement, api, track } from 'lwc';
import getFlowVersions from '@salesforce/apex/FlowsSelecterController.getFlowVersions';
const LATEST_VALUE = 'Latest';
const ACTIVE_VALUE = 'Active';
const SPECIFIC_VERSION_VALUE = 'Specific Version';

export default class FlowSelectorCard extends LightningElement {
    @api selectedFlowAPIName = '';
    @track selectedFlowAPIVersion = '';

    flowAPIVersionList = [];
    get flowVersionOptionList() {
        return  this.flowAPIVersionList.map(item => {
            return {value : ''+ item.VersionNumber, label : '' + item.VersionNumber};
        });
    }

    flowOption = LATEST_VALUE;

    get showFlowVersion() {
        this.flowOption === SPECIFIC_VERSION_VALUE;
    }


    

    radioGroupOptionList =[
        { label: LATEST_VALUE, value: LATEST_VALUE },
        { label: ACTIVE_VALUE, value: ACTIVE_VALUE },
        { label: SPECIFIC_VERSION_VALUE, value: SPECIFIC_VERSION_VALUE },
    ];
    changeFlowName(event) {
        console.log('event');
        console.log('event', event);
        this.selectedFlowAPIName = event.detail.value;

        getFlowVersions({flowAPIName : this.selectedFlowAPIName}).then(
            result => {
                console.log('result', result);
                this.flowAPIVersionList = result;
                this.selectedFlowAPIVersion = '' + this.flowAPIVersionList[this.flowAPIVersionList.length - 1].VersionNumber;
                this.fireSelectEvent();
                
            }
        ).catch(
            error => {
                console.error(error);
            }
        );
    }


    changeFlowOption(event) {
        this.flowOption = event.detail.value;
        if(this.flowOption === this.radioGroupOptionList[0].value) {
            this.selectedFlowAPIVersion = '' + this.flowAPIVersionList[this.flowAPIVersionList.length - 1].VersionNumber;
        } else if(this.flowOption === this.radioGroupOptionList[1].value) {
            this.flowAPIVersionList.forEach(
                item => {
                    if(item.Status === ACTIVE_VALUE) {
                        console.log('Activate', item.VersionNumber);
                        this.selectedFlowAPIVersion = '' + item.VersionNumber;
                    }
                }
            );
        } else if(this.flowOption === this.radioGroupOptionList[2].value) {
            this.selectedFlowAPIVersion = '' + this.flowAPIVersionList[0].VersionNumber;
        }
        this.fireSelectEvent();
        console.log(this.flowOption, this.selectedFlowAPIVersion);
    }

    fireSelectEvent() {
        const evnt = new CustomEvent('selectflow', { detail : this.selectedFlowAPIName + '-' + this.selectedFlowAPIVersion});
        this.dispatchEvent(evnt);
    }

    changeFlowVersion(event) {
        this.selectedFlowAPIVersion = event.detail.value;
        this.flowOption = SPECIFIC_VERSION_VALUE;
        this.fireSelectEvent();
    }
}