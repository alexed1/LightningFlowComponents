import { LightningElement, api } from 'lwc';
import Username from "@salesforce/label/c.Username";
import Token from "@salesforce/label/c.Token";
import Blocks from "@salesforce/label/c.Blocks";
import Text from "@salesforce/label/c.Text";
import Channel_Id from "@salesforce/label/c.Channel_Id";
import Thread_ts from "@salesforce/label/c.Thread_ts";
import Unfurl_Links from "@salesforce/label/c.Unfurl_Links";
import Attachments from "@salesforce/label/c.Attachments";

export default class PostToSlackCPE extends LightningElement {
    labels = {
        Username,
        Token,
        Blocks,
        Text,
        Channel_Id,
        Thread_ts,
        Unfurl_Links,
        Attachments
    }
    @api 
    get builderContext() {
        return this._builderContext;
    }

    set builderContext(context) {
        
        this._builderContext = context || {};
        if (this._builderContext) {
            const { variables } = this._builderContext;
            this._flowVariables = [...variables];
        }
    }
    
    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
    }

    @api inputVariables;

    

    _builderContext;
    _flowVariables;

    get token() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'token');
        return param && param.value;
    }

    get username() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'username');
        
        return param && param.value.split(',');
    }

    get blocks() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'blocks');
        return param && param.value;
    }

    get text() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'text');
        return param && param.value;
    }

    get channelId() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'channelId');
        return param && param.value;
    }

    get thread_ts() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'thread_ts');
        return param && param.value;
    }

    get unfurl_links() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'unfurl_links');
        return param && param.value;
    }

    get attachments() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'attachments');
        return param && param.value;
    }

    
    get tokenType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'token');
        return param && param.valueDataType;
    }

    get usernameType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'username');
        return param && param.valueDataType;
    }

    get blocksType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'blocks');
        return param && param.valueDataType;
    }

    get textType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'text');
        return param && param.valueDataType;
    }

    get channelIdType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'channelId');
        return param && param.valueDataType;
    }

    get thread_tsType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'thread_ts');
        return param && param.valueDataType;
    }

    get unfurl_linksType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'unfurl_links');
        return param && param.valueDataType;
    }

    get attachmentsType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'attachments');
        return param && param.valueDataType;
    }

    handleSlackChannelLookupValueChange(event) {
        let username = '';
        let result = event.detail.value;
        if(result) {
            username = result.join(',');
        }
        this.dispatchFlowValueChangeEvent('username', username, 'String');
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

    handleFlowComboboxValueChange(event) {
        if(event && event.detail) {
            this.dispatchFlowValueChangeEvent(event.detail.id, event.detail.newValue, event.detail.newValueDataType);
        }

    }

}