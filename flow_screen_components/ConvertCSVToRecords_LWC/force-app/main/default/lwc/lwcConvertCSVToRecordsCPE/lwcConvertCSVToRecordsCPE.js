import {LightningElement, api, track} from 'lwc';

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number',
    INTEGER: 'Integer'
};

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed'
}

export default class LwcConvertCSVToRecords_CPE extends LightningElement {
    typeValue;
    _builderContext = {};
    _values = [];
    _typeMappings = [];
    _elementType;
    _elementName;

    // For sObject Type on the Lookup
    handleDynamicTypeMapping(event) { 
        console.log('handling a dynamic type mapping');
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
        console.log('typeValue is: ' + typeValue);
        const dynamicTypeMapping = new CustomEvent('configuration_editor_generic_type_mapping_changed', {
            composed: true,
            cancelable: false,
            bubbles: true,
            detail: {
                typeName, 
                typeValue, 
            }
        });
        this.dispatchEvent(dynamicTypeMapping);
        this.dispatchFlowValueChangeEvent('objectName', event.detail.objectType, DATA_TYPE.STRING);
    }    

    @api
    get elementInfo() {
        return this._elementInfo;
    }

    set elementInfo(info) {
        this._elementInfo = info || {};
        if (this._elementInfo) {
            this._elementName = this._elementInfo.apiName;
            this._elementType = this._elementInfo.type;
        }
    }

    @track inputValues = {
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Input Object?', required: true, errorMessage: 'Please select an object'},
        inputLabel: {value: 'Upload CSV', valueDataType: null, isCollection: false, label: 'File Import Label', required: false, fieldHelpText: 'The label for the file input field'},
        autoNavigateNext: {value: false, valueDataType: null, isCollection: false, label: 'Auto Navigate Next', required: true, fieldHelpText: 'If true, the flow will automatically navigate to the next screen after the component has been initialized.'},
        delimiter: {value: ',', valueDataType: null, isCollection: false, label: 'Delimiter', required: false, fieldHelpText: 'The delimiting character. Leave blank to auto-detect from a list of most common delimiters, or any values passed in through delimitersToGuess'},
        newLine: {value: null, valueDataType: null, isCollection: false, label: 'New Line', required: false, fieldHelpText: 'The newline sequence. Leave blank to auto-detect. Must be one of \r, \n, or \r\n.'},
        quoteChar: {value: '&quot;', valueDataType: null, isCollection: false, label: 'Quote Character', required: false, fieldHelpText: 'The character used to quote fields. The quoting of all fields is not mandatory. Any field which is not quoted will correctly read.'},
        escapeChar: {value: '&quot;', valueDataType: null, isCollection: false, label: 'Escape Character', required: false, fieldHelpText: 'The character used to escape the quote character within a field. If not set, this option will default to the value of quoteChar'},
        transformHeader: {value: '', valueDataType: null, isCollection: false, label: 'Transform Header', required: false, fieldHelpText: 'A function to apply on each header.  The function receives the header as its first argument and the index as second.'},
        dynamicTyping: {value: false, valueDataType: null, isCollection: false, label: 'Dynamic Typing', required: false, fieldHelpText: 'If true, numeric and boolean data will be converted to their type instead of remaining strings'},
        encoding: {value: 'UTF-8', valueDataType: null, isCollection: false, label: 'Encoding', required: false, fieldHelpText: 'The encoding to use when opening local files. If specified, it must be a value supported by the FileReader API'},
        comments: {value: false, valueDataType: null, isCollection: false, label: 'Comments', required: false, fieldHelpText: 'A string that indicates a comment (for example, # or //). When Papa encounters a line starting with this string, it will skip the line.'},
        fastMode: {value: false, valueDataType: null, isCollection: false, label: 'Fast Mode', required: false, fieldHelpText: 'Fast mode speeds up parsing significantly for large inputs. However, it only works when the input has no quoted fields. Fast mode will automatically be enabled if no " characters appear in the input.'},
        transform: {value: '', valueDataType: null, isCollection: false, label: 'Transform', required: false, fieldHelpText: 'A function to apply on each value. The function receives the value as its first argument and the column number or header name when enabled as its second argument. The return value of the function will replace the value it received. The transform function is applied before dynamicTyping.'},
        delimitersToGuess: {value: '', valueDataType: null, isCollection: false, label: 'Delimiters To Guess', required: false, fieldHelpText: 'An array of delimiters to guess from if the delimiter option is not set'},
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get automaticOutputVariables() {
        return this._automaticOutputVariables;
    };
    
    set automaticOutputVariables(value) {
        this._automaticOutputVariables = value;
    }
    @track _automaticOutputVariables;

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    @api get genericTypeMappings() {
        return this._genericTypeMappings;
    }
    set genericTypeMappings(value) {
        this._typeMappings = value;
        this.initializeTypeMappings();
    }

    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    console.log('in initializeValues: ' + curInputParam.name + ' = ' + curInputParam.value);
                    // console.log('in initializeValues: '+ JSON.stringify(curInputParam));
                    if (this.inputValues[curInputParam.name].serialized) {
                        this.inputValues[curInputParam.name].value = JSON.parse(curInputParam.value);
                    } else {
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                    }
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
        }
    }

    initializeTypeMappings() {
        this._typeMappings.forEach((typeMapping) => {
            // console.log(JSON.stringify(typeMapping));
            if (typeMapping.name && typeMapping.value) {
                this.typeValue = typeMapping.value;
            }
        });
    }

    handleValueChange(event) {
        console.log('in handleValueChange: ' + JSON.stringify(event));
        if (event.detail && event.target) {
            // Any component using fsc_flow-combobox will be ran through here
            // This is the newer version and will allow users to use merge fields
            // If event.detail.newValue is set then use it, otherwise use event.detail.value
            let newValue = event.detail.newValue;
            if (newValue == null) {
                newValue = event.detail.value;

                // If event.detail.value.name is set then use it, otherwise use event.detail.value
                if (newValue.name != null) {
                    newValue = newValue.name;
                }
            }
            console.log('(NEW) in handleValueChange: ' + event.target.name + ' = ' + newValue);
            this.dispatchFlowValueChangeEvent(event.target.name, newValue, event.detail.newValueDataType);

        } else if ( event.detail && event.currentTarget ) {
            // This is the older version for any old inputs that are still using currentTarget
            // Kept for backwards compatibility
            console.log('(OLD) in handleValueChange: ' + event.currentTarget.name + ' = ' + event.detail);
            let dataType = DATA_TYPE.STRING;
            if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
            if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;
            if (event.currentTarget.type == 'integer') dataType = DATA_TYPE.INTEGER;
            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
        } else {
            console.log('in handleValueChange: no event detail');
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, dataType = DATA_TYPE.STRING) {
        console.log('in dispatchFlowValueChangeEvent: ' + id, newValue, dataType);
        if (this.inputValues[id] && this.inputValues[id].serialized) {
            console.log('serializing value');
            newValue = JSON.stringify(newValue);
        }
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
}