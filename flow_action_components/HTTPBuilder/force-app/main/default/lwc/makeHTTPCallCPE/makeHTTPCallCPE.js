import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, track, api } from 'lwc';
const METHOD_LIST = [
    {value: 'GET', label: 'GET'},
    {value: 'POST', label: 'POST'},
    {value: 'PATCH', label: 'PATCH'},
    {value: 'PUT', label: 'PUT'},
    {value: 'DELETE', label: 'DELETE'},
    {value: 'TRACE', label: 'TRACE'},
    {value: 'CONNECT', label: 'CONNECT'},
    {value: 'HEAD', label: 'HEAD'},
    {value: 'OPTIONS', label: 'OPTIONS'},
];
export default class MakeHTTPCallCPE extends LightningElement {

    @track inputValues = {};

    @api inputVariables;

    get methodList() {
        return METHOD_LIST;
    }

    get url() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'Endpoint');
        return param && param.value;
    }

    get method() {
        //return this.inputValues['Method'];
        const param = this.inputVariables.find(({ name }) => name === 'Method');
        return param && param.value;
    }

    get headerList() {
        const param = this.inputVariables.find(({ name }) => name === 'Headers');
        return param && param.value;
    }

    get paramList() {
        const param = this.inputVariables.find(({ name }) => name === 'Params');
        return param && param.value;
    }

    get timeout() {
        const param = this.inputVariables.find(({ name }) => name === 'Timeout');
        return param && param.value;
    }

    get compressedGzip() {
        const param = this.inputVariables.find(({ name }) => name === 'Compressed_gzip');
        return param && param.value;
    }

    get bodyAsBlob() {
        const param = this.inputVariables.find(({ name }) => name === 'BodyAsBlob');
        return param && param.value;
    }

    get body() {
        const param = this.inputVariables.find(({ name }) => name === 'Body');
        return param && param.value;
    }

    

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    changeURL(event) {
        //this.inputValues['Endpoint'] = event.target.value;
        this.dispatchFlowValueChangeEvent('Endpoint', event.detail.value, 'String');
        
    }

    changeMethod(event) {
        //this.inputValues['Method'] = event.target.value;
        this.dispatchFlowValueChangeEvent('Method', event.detail.value, 'String');
    }

    changeHeaders(event) {
        this.dispatchFlowValueChangeEvent('Headers', event.detail.value, 'String');
    }

    changeParams(event) {
        this.dispatchFlowValueChangeEvent('Params', event.detail.value, 'String');
    }

    changeTimeout(event) {
        this.dispatchFlowValueChangeEvent('Timeout', Number(event.detail.value), 'Number');
    }

    changeCompressedGzip(event) {
        this.dispatchFlowValueChangeEvent('Compressed_gzip', event.detail.checked ? event.detail.checked : null, 'Boolean');
    }

    changeBodyAsBlob(event) {
        this.dispatchFlowValueChangeEvent('BodyAsBlob', event.detail.checked ? event.detail.checked : null, 'Boolean');
    }
    changeBody(event) {
        this.dispatchFlowValueChangeEvent('Body', event.detail.value, 'String');
    }


    
}