import { LightningElement, api, track } from 'lwc';
import getFlowVersions from '@salesforce/apex/FlowsSelecterController.getFlowVersions';
const LATEST_VALUE = 'Latest';
const ACTIVE_VALUE = 'Active';
const SPECIFIC_VERSION_VALUE = 'Specific Version';

export default class FlowSelectorCard extends LightningElement {
    @api selectedFlowAPIName = '';
    @api selectedFlowAPIVersion = '';
    @api flowSelectorLabel = 'Select flow';
    
    connectedCallback() {  
        if(this.selectedFlowAPIName) {
            getFlowVersions({flowAPIName : this.selectedFlowAPIName}).then(
                result => {
                    this.flowAPIVersionList = result;
                    if(!this.selectedFlowAPIVersion) {
                        this.selectedFlowAPIVersion = '' + this.flowAPIVersionList[this.flowAPIVersionList.length - 1].VersionNumber;
                    } else {
                        this.flowOption = SPECIFIC_VERSION_VALUE;
                    }
                    this.fireSelectEvent();
                }
            ).catch(
                error => {
                    console.error(error);
                }
            );
        }
    }

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

    get flowPickerDisabled() {
        return this.flowOption !== SPECIFIC_VERSION_VALUE;
    }


    

    radioGroupOptionList =[
        { label: LATEST_VALUE, value: LATEST_VALUE },
        { label: ACTIVE_VALUE, value: ACTIVE_VALUE },
        { label: SPECIFIC_VERSION_VALUE, value: SPECIFIC_VERSION_VALUE },
    ];
    changeFlowName(event) {
        this.selectedFlowAPIName = event.detail.value;
        this.flowOption = LATEST_VALUE;
        getFlowVersions({flowAPIName : this.selectedFlowAPIName}).then(
            result => {
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
                        this.selectedFlowAPIVersion = '' + item.VersionNumber;
                    }
                }
            );
        }
        this.fireSelectEvent();
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