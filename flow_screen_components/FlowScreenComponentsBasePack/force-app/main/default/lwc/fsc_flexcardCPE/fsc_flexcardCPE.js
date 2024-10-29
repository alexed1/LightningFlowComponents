/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : Josh Dayment
**/
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

const CLICK_ACTIONS = {
    NONE: { value: 'none', label: 'Not clickable', default: true },
    SELECT: { value: 'select', label: 'Single-select' },
    MULTISELECT: { value: 'multiselect', label: 'Multi-select' },
    TRANSITION: { value: 'transition', label: 'Single-select and autonavigate' }
}

//const DISPLAY_OPTIONS = {
//LIST: {value: 'list', label: 'List'},
//MENU: {value: 'menu', label: 'Menu'}
//}


const VALIDATEABLE_INPUTS = ['c-fsc_flow-combobox', 'c-fsc_pick-object-and-field-3', 'c-field-selector-3'];

export default class fsc_flexcardCPE extends LightningElement {
    @api automaticOutputVariables;
    typeValue;
    _builderContext = {};
    _values = [];
    _flowVariables = [];
    _typeMappings = [];
    rendered;

    // Banner Help Text
    recordObjectInfo = [
        { label: 'Object Type Selection', helpText: 'Select "All" if you want the Object picklist to display all Objects in Salesforce note: not all objects are supported full list can be found here https://developer.salesforce.com/docs/atlas.en-us.uiapi.meta/uiapi/ui_api_all_supported_objects.htm.' },
        { label: 'Preselected recordId', helpText: 'This is a single recordId that will default the value for "value" ' },

    ];
    componentStyling = [
        { label: 'Component Label', helpText: 'Label for the entire component does support rich text' },
        { label: 'Card Width', helpText: 'Size in pixels default is 300px' },
        { label: 'Card Height', helpText: 'Size in pixels default is 300px' },

    ];

    headerStyling = [
        { label: 'Header Field', helpText: 'Choose the field name to populate in the card header' },
        { label: 'Style attribute for the card headers', helpText: 'Standard HTML syling to apply to the card headers' },
        { label: 'Pick an Icon', helpText: 'When an Icon is selected it will apply it before the name in the card header' },
        { label: 'Apply SLDS class to header field?', helptText: 'Select SLDS class to apply to header text' },
    ];

    cardStyling = [
        { label: 'Style attribute for the card body', helpText: 'Standard HTML syling to apply to the card body' },
        { label: 'Apply SLDS class to field values?', helptText: 'Select SLDS class to apply to field values' },
        { label: 'Show or hide field labels?', helptText: 'Decide if you want to show the field labels or just the values' },

    ];

    flexCardActions = [
        { label: 'List or Menu', helpText: 'Menu will display that action in a dropdown list, list will display the action as a list on the card' },
        { label: 'Actons Menu Label', helpText: 'When there is a text string here it either adds a label to the menu button or if list it will add a label with an h1 tag' },

    ];

    @track inputValues = {
        value: { value: null, valueDataType: null, isCollection: false, label: 'Preselected recordId' },
        icon: { value: null, valueDataType: null, isCollection: false, label: 'Icon name for example standard:account' },
        records: { value: null, valueDataType: null, isCollection: true, label: 'Record Collection', helpText: 'Record collection variable to be displayed in the cards' },
        visibleFieldNames: { value: null, valueDataType: null, isCollection: false, label: 'Show which fields?' },
        fields: { value: null, valueDataType: null, isCollection: true, label: 'Show which fields?', serialized: true },
        visibleFlowNames: { value: null, valueDataType: null, isCollection: false, label: 'Show which flow?' },
        flows: { value: null, valueDataType: null, isCollection: true, label: 'Show which flow?', serialized: true },
        cardSizeString: { value: null, valueDataType: DATA_TYPE.NUMBER, isCollection: false, label: 'Card Size', helpText: 'This is the size of the card in Pixels' },
        isClickable: { value: null, valueDataType: null, isCollection: false, label: 'Clickable Cards?', helpText: 'When checked cards are clickable and recordId passes to value' },
        cb_isClickable: { value: null, valueDataType: null, isCollection: false, label: '' },
        headerStyle: { value: null, valueDataType: null, isCollection: false, label: 'Style attribute for the card headers ', helpText: 'ie. background-color:red;' },
        allowMultiSelect: { value: null, valueDataType: null, isCollection: false, label: 'Allow MultiSelect?', helpText: 'When checked checkboxes appear on cards and adds selected cards recordId to collection' },
        cb_allowMultiSelect: { value: null, valueDataType: null, isCollection: false, label: '' },
        objectAPIName: { value: null, valueDataType: null, isCollection: false, label: 'Object Name' },
        label: { value: null, valueDataType: null, isCollection: false, label: 'Component Label' },
        transitionOnClick: { value: null, valueDataType: null, isCollection: false, label: 'Transition to next when card clicked?' },
        cb_transitionOnClick: { value: null, valueDataType: null, isCollection: false, label: '' },
        actionDisplayType: { value: null, valueDataType: null, isCollection: false, label: 'Display actions as hyperlinks in a list or a Menu List' },
        buttonLabel: { value: null, valueDataType: null, isCollection: false, label: 'Actions Menu Label' },
        allowAllObjects: { value: null, valueDataType: null, isCollection: false, label: 'Select if you want the Object picklist to display all Standard and Custom Salesforce Objects.' },
        subheadCSS: { value: null, valueDataType: null, isCollection: false, label: 'Style attribute for the card body ', helpText: 'ie. background-color:red;' },
        cardHeight: { value: null, valueDataType: null, isCollection: false, label: 'Card Height', helpText: 'This is the height of the card in Pixels' },
        cardWidth: { value: null, valueDataType: null, isCollection: false, label: 'Card Width', helpText: 'This is the width of the card in Pixels' },
        fieldVariant: { value: null, valueDatatType: null, isCollection: false, label: 'Field Variant' },
        fieldClass: { value: null, valueDataType: null, isCollection: false, label: 'Field Class' },
        headerField: { value: null, valueDataType: null, isCollection: false, label: 'Header Field' },
        headerFieldClass: { value: null, valueDataType: null, isCollection: false, label: 'Header Field Class' },
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

    @api
    validate() {
        let validity = [];
        for (let inputType of VALIDATEABLE_INPUTS) {
            for (let input of this.template.querySelectorAll(inputType)) {
                if (!input.reportValidity()) {
                    validity.push({
                        key: input.name || ('Error_' + validity.length),
                        errorString: 'This field has an error (missing or invalid entry)',
                    });
                }
            }
        }
        return validity;
    }

    @track clickActions = this.transformConstantObject(CLICK_ACTIONS);
    // clickAction;

    get clickAction() {
        console.log('in get clickAction');
        let inp = this.inputValues;
        if (inp.transitionOnClick.value) {
            return CLICK_ACTIONS.TRANSITION.value;
        } else if (inp.allowMultiSelect.value) {
            return CLICK_ACTIONS.MULTISELECT.value;
        } else if (inp.isClickable.value) {
            return CLICK_ACTIONS.SELECT.value;
        } else {
            return CLICK_ACTIONS.NONE.value;
        }


    }

    get objectTypes() {
        return [
            { label: 'Standard and Custom', value: '' },
            { label: 'All', value: 'All' },
        ];
    }

    get displayOptions() {
        return [
            { label: 'List', value: 'list' },
            { label: 'Menu', value: 'menu' },
        ];
    }

    get fieldVariants() {
        return [
            { label: 'Show Field Labels', value: 'standard' },
            { label: 'Hide Field Labels', value: 'label-hidden' },
        ]
    }

    get fieldClassOptions() {
        return [
            { label: '--None--', value: '' },
            { label: 'Body Small', value: 'slds-text-body_small' },
            { label: 'Heading Large', value: 'slds-text-heading_large' },
            { label: 'Heading Medium', value: 'slds-text-heading_medium' },
            { label: 'Heading Small', value: 'slds-text-heading_small' },
            { label: 'Title', value: 'slds-text-title' },
            { label: 'Title Uppercase', value: 'slds-text-title_caps' },
            { label: 'Longform', value: 'slds-text-longform' },
            { label: 'Align Left', value: 'slds-text-align_left' },
            { label: 'Align Center', value: 'slds-text-align_center' },
            { label: 'Align Right', value: 'slds-text-align_right' },
            { label: 'Color Success', value: 'slds-text-color_success' },
            { label: 'Color Weak', value: 'slds-text-color_weak' },
            { label: 'Color Error', value: 'slds-text-color_error' },
            { label: 'Color Destructive', value: 'slds-text-color_destructive' },
            { label: 'Bold', value: 'slds-text-title_bold' },
        ]
    }

    set clickAction(value) {
        console.log('in set clickAction, value = ' + value);
        let inp = this.inputValues;
        // if (value === CLICK_ACTIONS.NONE.value) {
        inp.transitionOnClick.value = false;
        inp.allowMultiSelect.value = false;
        inp.isClickable.value = false;
        // } 
        if (value !== CLICK_ACTIONS.NONE.value) {
            inp.isClickable.value = true;
            if (value === CLICK_ACTIONS.TRANSITION.value) {
                inp.transitionOnClick.value = true;
                inp.allowMultiSelect.value = false;
            }
            if (value === CLICK_ACTIONS.MULTISELECT.value) {
                inp.transitionOnClick.value = false;
                inp.allowMultiSelect.value = true;
            }
        }
        //console.log('after setting clickAction to ' + value, 'isClickable = ' + inp.isClickable.value, 'allowMultiSelect = ' + inp.allowMultiSelect.value, 'transitionOnClick = ' + inp.transitionOnClick.value);

        this.dispatchFlowValueChangeEvent('isClickable', inp.isClickable.value, DATA_TYPE.BOOLEAN);
        this.dispatchFlowValueChangeEvent('cb_isClickable', inp.isClickable.value ? 'CB_TRUE' : 'CB_FALSE', DATA_TYPE.STRING);

        this.dispatchFlowValueChangeEvent('allowMultiSelect', inp.allowMultiSelect.value, DATA_TYPE.BOOLEAN);
        this.dispatchFlowValueChangeEvent('cb_allowMultiSelect', inp.allowMultiSelect.value ? 'CB_TRUE' : 'CB_FALSE', DATA_TYPE.STRING);

        this.dispatchFlowValueChangeEvent('transitionOnClick', inp.transitionOnClick.value, DATA_TYPE.BOOLEAN);
        this.dispatchFlowValueChangeEvent('cb_transitionOnClick', inp.transitionOnClick.value ? 'CB_TRUE' : 'CB_FALSE', DATA_TYPE.STRING);
        //console.log('finished dispatching events');

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

    handleObjectChange(event) {
        if (event.target && event.detail) {
            // console.log('handling a dynamic type mapping');
            // console.log('event is ' + JSON.stringify(event));
            let typeValue = event.detail.objectType;
            const typeName = 'T';
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
            if (this.inputValues.objectAPIName.value != typeValue) {
                this.inputValues.objectAPIName.value = typeValue;
                this.dispatchFlowValueChangeEvent(event.currentTarget.name, typeValue, 'String');
            }

            // this.dispatchFlowValueChangeEvent(event.currentTarget.name, event.detail.objectType, DATA_TYPE.STRING);
        }
    }


    // handleFlowComboboxValueChange(event) {
    //     if (event.target && event.detail) {
    //          let changedAttribute = event.target.name;
    //          let newType = event.detail.dataType;
    //          let newValue = event.detail.newValue;
    //          this.dispatchFlowValueChangeEvent(changedAttribute, newValue, newType);
    //      }
    //  }

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

    handleFbbChange(event) {
        let name = event.target.dataset.name;
        let newValue = event.detail.value;
        this.dispatchFlowValueChangeEvent(name, newValue);
    }

    handleCheckboxChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(defaults.inputAttributePrefix, '');
            this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
            this.dispatchFlowValueChangeEvent('cb_' + changedAttribute, event.detail.newStringValue, 'String');
        }
    }
    handleCheckboxChange2(event) {
        //console.log(event.detail.value);
    }

    handleClickActionChange(event) {
        let action = event.detail.value;
        console.log('in handleclickactionchange', action);
        this.clickAction = action;
        // if (action === CLICK_ACTIONS.MULTISELECT.value) {
        //     this.inputValues.allowMultiSelect.value = true;
        // } else if (action === CLICK_ACTIONS.TRANSITION.value) {

        // }

    }

    handlePickIcon(event) {
        // this.inputValues[changedAttribute].value = event.detail;
        this.dispatchFlowValueChangeEvent('icon', event.detail);
    }

    handleDisplayTypeChange(event) {
        this.dispatchFlowValueChangeEvent('actionDisplayType', event.detail.value, 'String');
    }

    handleFieldVariantChange(event) {
        this.dispatchFlowValueChangeEvent('fieldVariant', event.detail.value, 'String');
    }

    handleFieldClassChange(event) {
        this.dispatchFlowValueChangeEvent('fieldClass', event.detail.value, 'String')
    }

    handleHeaderFieldClassChange(event) {
        this.dispatchFlowValueChangeEvent('headerFieldClass', event.detail.value, 'String')
    }

    handleAllowAllObjects(event) {
        this.dispatchFlowValueChangeEvent('allowAllObjects', event.detail.value, 'String');
    }

    handleHeaderFieldNameChange(event) {
        this.dispatchFlowValueChangeEvent('headerField', event.detail.value, 'String');
    }

    get isMenu() {
        let displayType = this.inputValues.actionDisplayType.value
        if (displayType == 'menu')
            return true;
        return false;
    }

    handleFlowSelect(event) {
        let selectedFlow = event.detail;
        let currentFlows = this.inputValues.flows.value || [];
        if (!currentFlows.some(flow => selectedFlow.value === flow.value)) {
            currentFlows.push(selectedFlow);
            this.dispatchFlowValueChangeEvent('flows', currentFlows);
        }
        event.currentTarget.selectedFlowApiName = null;
    }

    handleFlowRemove(event) {
        this.inputValues.flows.value.splice(event.currentTarget.dataset.index, 1);
        this.dispatchFlowValueChangeEvent('flows', this.inputValues.flows.value);

    }

    handlesliderChange(event) {
        console.log('in handlesliderChange');
        console.log('name = ' + event.target.dataset.name, 'value = ' + event.detail.value);
        this.dispatchFlowValueChangeEvent(event.target.dataset.name, event.detail.value, 'Number');
    }

    updateRecordVariablesComboboxOptions(objectType) {
        const variables = this._flowVariables.filter(
            (variable) => variable.objectType === objectType
        );
        let comboboxOptions = [];
        variables.forEach((variable) => {
            comboboxOptions.push({
                label: variable.name,
                value: "{!" + variable.name + "}"
            });
        });
        return comboboxOptions;
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
}
