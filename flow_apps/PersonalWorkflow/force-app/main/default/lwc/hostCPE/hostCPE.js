import { api, LightningElement, track } from 'lwc';

export default class HostCPE extends LightningElement {

    @api get inputVariablesJSON() {
        return JSON.stringify(this.inputVariables);
    } 
    set inputVariablesJSON(value) {
        if(value) {
            //this.inputVariables = JSON.parse(value);
        }
    }
    @track inputVariables = [];
    @track builderContext = {
        variables : []
    };
    onChangeValue(event){
        if(event && event.detail) {
            let inputVariable = this.inputVariables.find(({name}) => {
                return name === event.detail.name; 
            });

            if(!inputVariable){
                this.inputVariables.push(event.detail);
            } else {
                this.inputVariables.forEach((item, index) =>{
                        if(item.name === event.detail.name) {
                            this.inputVariables[index] = event.detail                        }
                    }
                );
            }
        }
    }
}