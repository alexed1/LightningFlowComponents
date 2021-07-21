import { LightningElement, api, track } from 'lwc';
import getChannels from "@salesforce/apex/SlackChannelLookupController.getConversations";
import getUsers from "@salesforce/apex/SlackChannelLookupController.getUsers";
import getSObjects from "@salesforce/apex/SlackChannelLookupController.getSObjects";
import Specific_Slack_channels from "@salesforce/label/c.Specific_Slack_channels";
import noDataAvailable from "@salesforce/label/c.noDataAvailable";
import Use_data_from_the_Flow_to_determine_the_destination from "@salesforce/label/c.Use_data_from_the_Flow_to_determine_the_destination";

const OPEN_LISTBOX_CLASS = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
const CLOSE_LISTBOX_CLASS = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
const SLDS_FORM_ELEMENT_CLASS = ' slds-form-element';
const SLDS_HAS_ERROR_CLASS = ' slds-has-error';
export default class slackChannelLookup extends LightningElement {
    
    @api lockupType = 'slack';
    @api objectType = 'Account';
    @api valueFieldName = 'AccountNumber';
    @api slackAuthToken;
    @api required = false;
    @api disabled;
    @api label;
    @track dropdownClass = CLOSE_LISTBOX_CLASS;
    @api get selectedValues() {   
        return this._selectedValues.map( element => {
            return element.value;
        });
    }

    set selectedValues(value) {
        this._selectedValueIdList = [];
        if(value && Array.isArray(value)) {
            value.forEach(
                element => {
                    if(this.isReference(element)) {
                        this.flowVariable = element;
                    } else {
                        this._selectedValueIdList.push(element);
                    }
                }
            );
        }

        this.updateConversationList();
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
    selfEvent = false;
    @track _selectedValues = [];
    @track _selectedValueIdList = [];
    flowVariable;
    get flowVariableType() {
        if(this.flowVariable && this.isReference(this.flowVariable)) {
            return 'reference';
        }
        return 'String';
    }
    _value;
    _userList = [];
    _channelList = [];
    _sObjectList = [];
    isOpenMenu = false;
    isSetOnClick = false;
    slackChannel;
    @track _options = [];
    @track _optionsToDisplay = [];

    labels = {
        Specific_Slack_channels,
        noDataAvailable,
        Use_data_from_the_Flow_to_determine_the_destination
    }
    get formElementClass() {
        let resultClass = SLDS_FORM_ELEMENT_CLASS;
        if (this.hasError) {
            resultClass += SLDS_HAS_ERROR_CLASS;
        }
        return resultClass;
    }

    connectedCallback() {
        this._options = [];
        this._optionsToDisplay = [];
        if(this.lockupType === 'slack') {
            getChannels({token : this.slackAuthToken}).then(
                result => {
                    this._channelList = result;
                    this.updateConversationList();
                }
            ).catch(
                error => {
                    console.error(error);
                }
            );
            getUsers({token : this.slackAuthToken}).then(
                result => {
                    this._userList = result;
                    this.updateConversationList();
                }
            ).catch(
                error => {
                    console.error(error);
                }
            );
        } else if(this.lockupType === 'sObject'){
            getSObjects({objectType : this.objectType, valueFieldName : this.valueFieldName}).then(
                result => {
                    this._sObjectList = result;
                    this.updateConversationList();
                }
            ).catch(
                error => {
                    console.error(error);
                }
            );
        }
        if(!this.isSetOnClick) {
            document.addEventListener('click', this.handleWindowClick.bind(this));
            this.isSetOnClick = true;
        }
    }

    handleWindowClick(event) {
        if (event.path){
            if (!event.path.includes(this.template.host) && !this.selfEvent) {
                this.closeOptionDialog();
            }
        
        } else {
            if (!this.selfEvent) {
                this.closeOptionDialog();
            }
        }

        this.selfEvent = false;
    }




    updateConversationList() {
        this._options = [];
        this._optionsToDisplay = [];
        if(this._userList) {
            this._userList.forEach(
                item => {
                    this._options.push(item);
                    if(this._selectedValueIdList.includes(item.value) && !this._selectedValues.find(element => element.value === item.value)) {
                        this._selectedValues.push(item);
                    }
                }
            );
        }

        if(this._channelList) {
            this._channelList.forEach(
                item => {
                    this._options.push(item);
                    if(this._selectedValueIdList.includes(item.value) && !this._selectedValues.find(element => element.value === item.value)) {
                        this._selectedValues.push(item);
                    }
                }
            );
        }

        if(this._sObjectList) {
            this._sObjectList.forEach(
                item => {
                    this._options.push(item);
                    if(this._selectedValueIdList.includes(item.value) && !this._selectedValues.find(element => element.value === item.value)) {
                        this._selectedValues.push(item);
                    }
                }
            );
        }

        this._optionsToDisplay = [...this._options];
        console.log(this._options, this._optionsToDisplay);
    }

    handleSearchKeyUp(event) {
        if (event.key === "Enter" || event.key === "Tab") {
            
        }
    }

    handleKeyDown(event) {
        if ((event.key === "Tab" || event.key === 'Escape')) {
            this.closeOptionDialog();
            if (event.key === 'Escape') {
                event.stopPropagation();
            }
        }
    }

    handleInputFocus(event) {
        this.closeOptionDialog();
    }

    handleSearchField(event) {
        if (event.target) {
            this.processOptions(event.target.value);
            
        }
    }
    handleOpenOptions(event) {
        this.openOptionDialog();
        if(!this._options || this._options.length === 0) {
            this.connectedCallback();
        }     
    }

    closeOptionDialog() {
        this.isOpenMenu = false;
        this.dropdownClass = CLOSE_LISTBOX_CLASS;
    }

    openOptionDialog() {
        this.isOpenMenu = true;
        this.selfEvent = true;
        this.dropdownClass = OPEN_LISTBOX_CLASS;
    }


    processOptions(searchText) {
        this._optionsToDisplay = this._options.filter( element => { 
            return (element.label.toLowerCase().includes(searchText))
        });
    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {

            let serachValue = this._options.find(element => element.value === event.currentTarget.dataset.value);
            if(serachValue && !this._selectedValues.find(element => element.value === serachValue.value)) {
                this._selectedValues.push(serachValue);
            }
            
            this.closeOptionDialog();
            this.dispatchValueChangedEvent();
        }
    }

    dispatchValueChangedEvent() {
        let resultList = this.selectedValues;
        if(this.flowVariable) {
            resultList.push(this.flowVariable);
        }

        let event = new CustomEvent(
                'valuechanged',
                {
                    detail : {
                        value : resultList,
                    }
                }
        );

        this.dispatchEvent(event);
    }

    resetData(event) {
        this._selectedValues.forEach(
            (element, index) => {
                if(element.value === event.currentTarget.dataset.value) {
                    this._selectedValues.splice(index,1);
                }
            }
        );
        this.closeOptionDialog();
        this.dispatchValueChangedEvent();
    }

    handleFlowComboboxValueChange(event) {
        if(event && event.detail) {
            if(event.detail.newValueDataType === 'reference') {
                this.flowVariable = '{!' + event.detail.newValue + '}';
            } else {
                this.flowVariable = event.detail.newValue;
            }
        }

        this.dispatchValueChangedEvent();
    }

    isReference(value) {
        if(value.startsWith('{!') && value.endsWith('}')) {
            return true;
        }

        return false;
    }
    
}