import {api, track, LightningElement } from 'lwc';

export default class FlexcardCPE extends LightningElement {
    _builderContext;
    _values;


    @track inputValues = {
        value: {value: null, valueDataType: null, isCollection: false, label: 'The selected cards recordId'},
        icon: {value: null, valueDataType: null, isCollection: false, label: 'Icon name for example standard:account'},
        records: {value: null, valueDataType: null, isCollection: true, label: 'Record Collection variable containing the records to display in the flexcard.'},
        visibleFieldNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which fields?'},
        visibleFlowNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which flow?'},
        cardSize: {value: null, valueDataType: null, isCollection: false, label: 'The size of the box in pixels. The box is a square.'},
        isClickable: {value: null, valueDataType: null, isCollection: false, label: 'Set as true if you wish to select individual cards for action further downstream in flow default is false'},
        headerStyle: {value: null, valueDataType: null, isCollection: false, label: 'Add your own style attribute to the card headers ie. background-color:red;'},
        allowMultiSelect: {value: null, valueDataType: null, isCollection: false, label: 'Allow for multiselect of cards when enabled checkboxes appear on cards and adds selected cards to collection'},
        objectAPIName: {value: null, valueDataType: null, isCollection: false, label: 'The SObject API Name used to query fields and values must be the same object selected in Flexcard Object API Name'},
        label: {value: null, valueDataType: null, isCollection: false, label: 'Enter a label for you component'},
        transitionOnClick: {value: null, valueDataType: null, isCollection: false, label: 'If marked as true will transition flow to next screen on card click'},
        
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
                this.dispatchFlowValueChangeEvent(event.target.name.replace(this.settings.inputAttributePrefix, ''), event.detail.newValue, event.detail.newValueDataType);
            }
        }

        handleValueChange(event) {
            if (event.target) {
                let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
                let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;
                let curAttributeType;
                switch (event.target.type) {
                    case "checkbox":
                        curAttributeType = 'Boolean';
                        break;
                    case "number":
                        curAttributeType = 'Number';
                        break;
                    default:
                        curAttributeType = 'String';
                }
                this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
            }
        }

        dispatchFlowValueChangeEvent(id, newValue, dataType) {
            const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
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
    

}
