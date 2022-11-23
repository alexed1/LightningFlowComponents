import { api, track, LightningElement } from 'lwc';

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number',
    INTEGER: 'Integer'
};

const defaults = {
    inputAttributePrefix: 'select_',
};

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed'
}

const VALIDATEABLE_INPUTS = ['c-fsc_flow-combobox', 'c-fsc_pick-object-and-field-3', 'c-field-selector-3'];

export default class fileUploadImprovedCPE extends LightningElement {
    @api automaticOutputVariables;
    typeValue;
    _builderContext = {};
    _values = [];
    _flowVariables = [];
    _typeMappings = [];
    rendered;

     // Banner Help Text
    basicConfiguration = [
        {label: '{!$Flow.InterviewGuid}', helpText: 'Unique identifier for this field. You can start by using {!$Flow.InterviewGuid}. If you have multiple of this component type in the same flow, you will have to prepend {!$Flow.InterviewGuid} with something else like 1 or 2 to make each component unique.'},
        {label: 'Label', helpText: 'The text on the file upload button.'},
        {label: 'Related Record Id', helpText: 'The Id of the record to associate the files with. Be aware that sharing rules are NOT enforced, so the user could be uploading files to a record that they would not normally have access to. Do not know the Related Record Id because you are going to create the record after this screen? You can leave this field blank and use the Create Content Document Links Downstream Apex Action.'},
        {label: 'Accepted Formats', helpText: 'The accepted file types. Enter a comma-separated list of the file extensions (such as .jpg) that the user can upload.'},
        {label: 'Help Text', helpText: 'The message that will be displayed in the help text popup.'},
        {label: 'Required?', helpText: 'When checked requires the user to upload at least one file.'},
        {label: 'Required Validation Message', helpText: 'The validation message displayed if the user has not uploaded at least one file and the component is marked as required. The default message is "Upload at least one file."'},
        {label: 'Allow Multiple File Upload?', helpText: 'When checked allows the user to upload multiple files. If this is not checked, then once the user uploads one file, the file upload component will not allow any additional files to be uploaded.'},
    ];
    advancedConfiguration = [
        {label: 'Pick an Icon', helpText: 'The default LDS Icon that will be displayed next to each uploaded file. Options here: https://www.lightningdesignsystem.com/icons/#doctype. Prepend icon name with doctype:, ie doctype:word. Leave blank and the system will display the icon based on the extension type.'},
        {label: 'Uploaded File List Label', helpText: 'The text on the list of files uploaded. You might find that you prefer to leave this blank, as the UX is obvious.'},
        {label: 'Overridden File Name', helpText: 'The file name of the uploaded files defaults to the actual name of the file. If you would prefer to override the default file name, you can specify the new file name here.'},
        {label: 'Show Existing Files Related to Record Id', helpText: 'If you would like to show the existing files associated with the Related Record Id (in addition to the ones that the user may upload), check this box. Be aware that sharing rules are NOT enforced, so the user could see files that they wouldn not normally have access to.'},
        {label: 'Show Files Below the File Upload Component', helpText: 'By default, the files will show above the File Upload Component. If you would prefer they be shown below the component, set check this box.'},
        {label: 'Set Visibility to All Users', helpText: 'By default, when an internal user uploads a file, the file is only visible to other internal users (meaning community users cannot see it). If you would like to make the uploaded file visible to all users, check this box. When a community user uploads a file, the file is already visible to all users.'},
        {label: 'Embed on External Website', helpText: 'If this flow is being embedded on an external website (like Wordpress, for example), check this box. Otherwise, this should almost always be unchecked'},
        {label: 'Disable File Deletion', helpText: 'When this is checked, clicking the "X" next to the Files will simply remove them from the UI and the output list, but the Files will NOT be deleted.'},
    ];
    

    @track inputValues = {
        
        icon: { value: null, valueDataType: null, isCollection: false, label: 'Icon' },
        allowMultiple: { value: null, valueDataType: null, isCollection: false, label: 'Allow multiple file upload?', helpText: 'Allow the user to upload multiple files. If this is not TRUE, then once the user uploads one file, the file upload component will not allow any additional files to be uploaded' },
        cb_allowMultiple: { value: null, valueDataType: null, isCollection: false, label: '' },
        acceptedFormats: { value: null, valueDataType: null, isCollection: false, label: 'Accepted Formats' },
        label: { value: null, valueDataType: null, isCollection: false, label: 'File Upload Label' },
        sessionKey: { value: null, valueDataType: null, isCollection: false, label: '{!$Flow.InterviewGuid}' },
        uploadedlabel: {value: null, valueDataType: null, isCollection: false, label: 'Uploaded File List Label'},
        recordId: { value: null, valueDataType: null, isCollection: false, label: 'Related Record Id' },
        required: { value: null, valueDataType: null, isCollection: false, label: 'Required?' },
        cb_required: { value: null, valueDataType: null, isCollection: false, label: '' },
        requiredMessage: { value: 'Upload at least one file', valueDataType: null, isCollection: false, label: 'Required Validation Message' },
        renderExistingFiles: { value: null, valueDataType: null, isCollection: false, label: 'Show Existing Files Related to Record Id' },
        cb_renderExistingFiles: { value: null, valueDataType: null, isCollection: false, label: '' },
        overriddenFileName: { value: null, valueDataType: null, isCollection: false, label: 'Overridden File Name' },
        renderFilesBelow: { value: null, valueDataType: null, isCollection: false, label: 'Show Files Below the File Upload Component' },
        cb_renderFilesBelow: { value: null, valueDataType: null, isCollection: false, label: '' },
        visibleToAllUsers: { value: null, valueDataType: null, isCollection: false, label: 'Set Visibility to All Users' },
        cb_visibleToAllUsers: { value: null, valueDataType: null, isCollection: false, label: '' },
        embedExternally: { value: null, valueDataType: null, isCollection: false, label: 'Embed on External Website' },
        cb_embedExternally: { value: null, valueDataType: null, isCollection: false, label: '' },
        disableDelete: { value: null, valueDataType: null, isCollection: false, label: 'Disable File Deletion' },
        cb_disableDelete: { value: null, valueDataType: null, isCollection: false, label: '' },
        helpText: { value: null, valueDataType: null, isCollection: false, label: 'Help Text' },

       
        
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

    @api get genericTypeMappings() {
        return this._genericTypeMappings;
    }
    set genericTypeMappings(value) {
        this._typeMappings = value;
        this.initializeTypeMappings();
    }     
        

    /* LIFECYCLE HOOKS */
    connectedCallback() {

    }

    renderedCallback() {
        if (!this.rendered) {
            this.rendered = true;
            for (let flowCombobox of this.template.querySelectorAll('c-fsc_flow-combobox')) {
                flowCombobox.builderContext = this.builderContext;
                flowCombobox.automaticOutputVariables = this.automaticOutputVariables;
            }
        }
    }

    /* ACTION FUNCTIONS */
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

    /* EVENT HANDLERS */
    

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            this.dispatchFlowValueChangeEvent(event.target.name, event.detail.newValue, event.detail.newValueDataType);
        }
    }

    handleValueChange(event) {
        if (event.detail && event.currentTarget.name) {
            let dataType = DATA_TYPE.STRING;
            if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
            if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;
            if (event.currentTarget.type == 'integer') dataType = DATA_TYPE.INTEGER;

            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
        }
    }
    

    handleCheckboxChange(event) {
        if (event.target && event.detail) {
          let changedAttribute = event.target.name.replace(
            defaults.inputAttributePrefix,
            ""
          );
          this.dispatchFlowValueChangeEvent(
            changedAttribute,
            event.detail.newValue,
            event.detail.newValueDataType
          );
          this.dispatchFlowValueChangeEvent(
            "cb_" + changedAttribute,
            event.detail.newStringValue,
            "String"
          );
        }
      }

    

    handlePickIcon(event) {
        // this.inputValues[changedAttribute].value = event.detail;
        this.dispatchFlowValueChangeEvent('icon', event.detail);
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

    /* UTILITY FUNCTIONS */
    transformConstantObject(constant) {
        return {
            list: constant,
            get options() { return Object.values(this.list); },
            get default() { return this.options.find(option => option.default); },
            findFromValue: function (value) {
                let entry = this.options.find(option => option.value == value);
                return entry || this.default;
            },
            findFromLabel: function (label) {
                let entry = this.options.find(option => option.label == label);
                return entry || this.default;
            }
        }
    }

    // Helper function to check input value properties for a match
  eq(prop, value) {
    return this.inputValues[prop]?.value === value;
  }

  get isRequired() {
    return this.eq("cb_required", "CB_TRUE");
  }
}