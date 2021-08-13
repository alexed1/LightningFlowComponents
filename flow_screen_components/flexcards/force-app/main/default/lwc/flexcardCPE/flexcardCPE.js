import {api, track, LightningElement } from 'lwc';

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number'
}

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed'
}

export default class FlexcardCPE extends LightningElement {
    _builderContext;
    _values;


    @track inputValues = {
        value: {value: null, valueDataType: null, isCollection: false, label: 'Preselected recordId'},
        icon: {value: null, valueDataType: null, isCollection: false, label: 'Icon name for example standard:account'},
        records: {value: null, valueDataType: null, isCollection: true, label: 'Record Collection'},
        visibleFieldNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which fields?'},
        visibleFlowNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which flow?'},
        cardSize: {value: null, valueDataType: null, isCollection: false, label: 'Card Size', helpText:'This is the size of the card in Pixels'},
        isClickable: {value: null, valueDataType: null, isCollection: false, label: 'Clickable Cards?', helpText:'When checked cards are clickable and recordId passes to value'},
        headerStyle: {value: null, valueDataType: null, isCollection: false, label: 'Style attribute for the card headers ', helpText:'ie. background-color:red;'},
        allowMultiSelect: {value: null, valueDataType: null, isCollection: false, label: 'Allow MultiSelect?', helpText:'When checked checkboxes appear on cards and adds selected cards recordId to collection'},
        objectAPIName: {value: null, valueDataType: null, isCollection: false, label: 'Object Name'},
        label: {value: null, valueDataType: null, isCollection: false, label: 'Component Label'},
        transitionOnClick: {value: null, valueDataType: null, isCollection: false, label: 'Transition to next when card clicked?'},
        
        };

        @api get builderContext() {
            return this._builderContext;
        }
    
        set builderContext(value) {
            this._builderContext = value;
        }
    
        @api get inputVariables() {
            return this._values;
        }
    
        set inputVariables(value) {
    
            this._values = value;
            this.initializeValues();
        }
    
        initializeValues(value) {
            if (this._values && this._values.length) {
                this._values.forEach(curInputParam => {
                    if (curInputParam.name && this.inputValues[curInputParam.name]) {
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                        this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    }
                });
            }
            
        }

        handleFlowComboboxValueChange(event) {
            if (event.target && event.detail) {
                this.dispatchFlowValueChangeEvent(event.currentTarget.name, event.detail.value, DATA_TYPE.STRING);
            }
        }

        handleValueChange(event) {
            if (event.detail && event.currentTarget.name) {
                let dataType = DATA_TYPE.STRING;
                if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
                if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;
    
                let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;
                this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
            }
        }

        handlePickIcon(event) {
            let changedAttribute = 'icon';
            this.inputValues[changedAttribute].value = event.detail;
            this.dispatchFlowValueChangeEvent(schangedAttribute, event.detail, 'String');
        }

        dispatchFlowValueChangeEvent(id, newValue, dataType) {
            const valueChangedEvent = new CustomEvent(FLOW_EVENT_TYPE.CHANGE, {
                bubbles: true,
                cancelable: false,
                composed: true,
                detail: {
                    name: id,
                    newValue: newValue ? newValue : null,
                    newValueDataType: dataType
                }
            });
            this.dispatchEvent(valueChangedEvent);
        }
        handleCheckboxChange(event) {
            if (event.target && event.detail) {
                let changedAttribute = event.target.name.replace(defaults.inputAttributePrefix, '');
                this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
                this.dispatchFlowValueChangeEvent('cb_'+changedAttribute, event.detail.newStringValue, 'String');
            }
        }
    

}
