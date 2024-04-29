/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : Josh Dayment
**/
import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';


export default class FlexcardFlow extends LightningElement {

    @api cardSize = 300;
    @api value;
    @api buttonLabel;
    @api selectedLabel;
    _records;
    @api
    get records() {
        return this._records || [];
    }

    set records(data = []) {
        if (Array.isArray(data)) {
            this._records = data;
            this.processRecords();
        } else {
            this._records = [];
        }
    }
    @api visibleFieldNames;
    @api visibleFlowNames;
    @api src;
    @api icon;
    @api avatarField;
    @api objectAPIName;
    @api
    get isClickable() {
        return (this.cb_isClickable == 'CB_TRUE') ? true : false;
    }
    @api cb_isClickable;
    @api headerStyle = 'font-weight: bold;';
    @api contentStyle;
    @api
    get allowMultiSelect() {
        return (this.cb_allowMultiSelect == 'CB_TRUE') ? true : false;
    }
    @api cb_allowMultiSelect;
    @api recordValue;
    //@api
    //get selectedRecordIds() {
    //    return this._selectedRecordIds;
   // }
    //set selectedRecordIds(selectedRecordIds = []) {
    //    this._selectedRecordIds = selectedRecordIds;
   // }
    @api selectedRecordIds;
    @track _selectedRecordIds = new Set();
    @api label;
    @api subheadCSS;
    @api
    get transitionOnClick() {
        return (this.cb_transitionOnClick == 'CB_TRUE') ? true : false;
    }
    @api cb_transitionOnClick;
    @api allowAllObjects;
    @track fieldCollection = [];
    @api availableActions = [];
    @api actionDisplayType;
    @track actionDisplayType;
    @api Cardcss;
    @track Cardcss;
    @track fieldHTML = '';
    @track recordLayoutData = {};
    @track objectInfo;
    @api recordDataString;
    @track recs = [];
    @api
    get fields() {
        return this._fields;
    }
    set fields(value) {
        this._fields = value;
        this.visibleFieldNames = JSON.parse(value).map(field => field.name).join();
        this.fieldCollection = JSON.parse(value).map(field => field.name);
    }
    @track _fields;
    @api
    get flows() {
        return this._flows;
    }
    set flows(value) {
        this._flows = JSON.parse(value).map(flow => flow.value).join();
    }
    @track _flows;
    @api
    get cardSizeString() {
        return this.cardSize;
    }
    set cardSizeString(value) {
        if (!Number.isNaN(value))
            this.cardSize = value;
    }
    @api cardHeight = 300;
    @api cardWidth = 300;
    @api fieldVariant;
    @api fieldClass;
    @api headerField = 'Name';
    @api headerFieldClass = 'slds-text-heading_small';
    

    curRecord;
    @wire(getObjectInfo, { objectApiName: '$objectAPIName' })
    recordInfo({ data, error }) {
        if (data) {
            this.objectInfo = data;
            //console.log('AssignedResource Label => ', data.fields.AssignedResource.label);
        }
    }

    renderedCallback() {
        if (this.value != null && !this.allowMultiSelect && this.isClickable) {
            this.template.querySelector('[data-id="' + this.value + '"]').checked = true;
            
        }
    }

    connectedCallback() {
        console.log('entering connectedCallback');
        if (!this.records) {
            throw new Exception("Flexcard component received a null when it expected a collection of records. Make sure you have set the Object API Name in both locations and specified a Card Data Record Collection");
        }
        //console.log('records are: ' + JSON.stringify(this.records));
        this.recs = JSON.parse(JSON.stringify(this.records));
        
        

        

    }



    processRecords() {

        this.recs = JSON.parse(JSON.stringify(this._records));
        this.setHeaderValue;
        console.log(this.headerValue)


    }

    retrieveFieldLabels(item, index) {
        console.log('retrieving field label for field named: ' + item);
        //call apex to get field labels for fields
    }

    appendFieldInfo(item, index) {
        //console.log('entering append...fieldName is: ' + item);
        //console.log('and record is: ' + JSON.stringify(this.curRecord));
        //console.log('this is: ' + this);
        this.fieldHTML = this.fieldHTML + ' <h2> ' + item + ' </h2>';
        //console.log('fieldHTML is now: ' + this.fieldHTML);
    }

    get isDataLoaded() {
        return this.objectInfo && this.records.length > 0;
    }

    get isFlowsLoaded() {
        return this.flows && this.flows.length > 0;
    }

    //set card width and height

    get sizeWidth() {
        return 'width: ' + this.cardWidth + 'px ; height: ' + this.cardHeight + 'px';

    }

    get showIcon() {
        return this.icon && this.icon.length > 0;
    }

    

    handleChange(event) {
        //console.log(event.target.checked);
        this.recordValue = event.target.value;
        if (event.target.checked) {
            this._selectedRecordIds.add(this.recordValue);
        } else {
            this._selectedRecordIds.delete(this.recordValue);
        }
        this.selectedRecordIds = Array.from(this._selectedRecordIds)
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedRecordIds', this.selectedRecordIds);
        this.dispatchEvent(attributeChangeEvent);
    }
    
    

    handleClick(event) {
        this.recs.find(record => {
            if (record.Id === event.currentTarget.dataset.id && this.isClickable == true) {
                this.selectedRecord = event.currentTarget.dataset.id;
                this.value = this.selectedRecord;
                const attributeChangeEvent = new FlowAttributeChangeEvent('value', this.value);
                this.dispatchEvent(attributeChangeEvent);
            }

        });

        // navigate to the next screen or (if last element) terminate the flow
        if (this.transitionOnClick === true) {
            if (this.availableActions.find(action => action === 'NEXT')) {
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            } else if (this.availableActions.find(action => action === 'FINISH')) {
                const navigateFinishEvent = new FlowNavigationFinishEvent();
                this.dispatchEvent(navigateFinishEvent);
            }
        }
    }


}
