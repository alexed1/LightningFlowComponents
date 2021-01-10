import { api, LightningElement, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';



const CLOSED = 'Closed';
const CLOSED_CTA = 'Select Closed Status';
const MARK_COMPLETED = 'Mark Status as Complete';
const SPECIAL_STATUS = 'Closed - Special Date';
const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay));
const wait1Second = async () => {
    await sleep(1000)
  }

export default class CustomPath extends LightningElement {
  //start off with all @wire methods and dependencies
  //plus lifecycle methods
  
  @api targetStringCollection;
  @api targetStringCSV;
  @api selectedTarget;
  objectInfo;

 

  connectedCallback() {
      console.log('entering connectedCallback');
     /*  if (targetStringCollection != null && this.targetStringCSV != null) {
        throw new Error('You can provide either a string collection or a csv string, but not both');
      } */

      //build visible statuses out of the targetStringCollection
      let _visibleStatuses = [];
      if (this.targetStringCSV != null) {
        console.log('this.targetStringCSV is: ' + this.targetStringCSV);
        this.targetStringCollection = this.targetStringCSV.split(',');
      }
      console.log('this.targetStringCollection = ' + this.targetStringCollection);

      for(let index = 0; index < this.targetStringCollection.length; index++) {
        let target = {}
        target["label"] = this.targetStringCollection[index];
        console.log('target is:' + JSON.stringify(target));
        _visibleStatuses.push(target);

      }
      this.visibleStatuses = _visibleStatuses;
      console.log('visibleStatuses is: ' + JSON.stringify(this.visibleStatuses));
      this._updateVisibleStatuses();
  }

  renderedCallback() {
     // console.log('entering renderedCallback');
     
    if (!this._hasRendered && this.hasData) {
      //prevents the advance button from jumping to the side
      //as the rest of the component loads
      this.showAdvanceButton = true;
      this._hasRendered = true;
    }

    
  }

  /* private fields for tracking */
  @track advanceButtonText = MARK_COMPLETED;
  @track closedStatuses = [];
  @track currentClosedStatus;
  @track customCloseDateSelected = false;
  @track dateValue;
  @track showAdvanceButton = false;
  @track showClosedOptions = false;
  @track status;
  @track storedStatus;
  //@track visibleStatuses = [{label : 'foo', value : 'bar', class:'slds-is-incomplete'},{label : 'baz', value : 'qux',  class:'slds-is-incomplete'}];
  @track visibleStatuses = [];
  

  //truly private fields
  _hasRendered = false;
  _statuses;

  //private methods and getters
  get pathActionIconName() {
    return this.advanceButtonText === MARK_COMPLETED ? 'utility:check' : '';
  }

  get hasData() {
    return !!(this.storedStatus && this.visibleStatuses.length > 0);
  }

 /*  modalSaveHandler = async (event) => {
    event.stopPropagation();
    event.preventDefault();

    const allValid = [
      ...this.template.querySelectorAll('.slds-form-element')
    ].reduce((validSoFar, formElement) => {
      formElement.reportValidity();
      return validSoFar && formElement.checkValidity();
    });
    if (allValid) {
      this._toggleModal();
      await this._saveLeadAndToast();
    }
  }; */

  handleStatusClick(event) {
    console.log('entering handleStatusClick. event label is: ' + JSON.stringify(event.target.title) + ' and event detail id is:  ' + event.detail.id +'and role is: ' + event.target.role);
    event.stopPropagation();
    //update the stored status, but don't update the record
    //till the save button is clicked
    const updatedStatusName = event.target.textContent;
    /* this.advanceButtonText =
      updatedStatusName === this.status
        ? MARK_COMPLETED
        : 'Mark As Current Status'; */
    this.storedStatus = updatedStatusName;

    if (this.status !== this.storedStatus) {
      this._updateVisibleStatuses();
    }

/*     if (this.storedStatus === CLOSED) {
      this._advanceToClosedStatus();
    } */
    //JSON.stringify(event.target.title)

    const attributeChangeEvent = new FlowAttributeChangeEvent('selectedTarget',event.target.title );
    this.dispatchEvent(attributeChangeEvent);
    wait1Second();
    const navigateNextEvent = new FlowNavigationNextEvent();
    this.dispatchEvent(navigateNextEvent);
  }


  handleClosedStatusChange(event) {
    const newClosedStatus = event.target.value;
    this.currentClosedStatus = newClosedStatus;
    this.storedStatus = newClosedStatus;
    this.customCloseDateSelected = this.storedStatus === SPECIAL_STATUS;
  }

  handleDateOnChange(event) {
    this.dateValue = event.target.value;
  }

 

  //truly private methods, only called from within this file
  _advanceToClosedStatus() {
    this.advanceButtonText = CLOSED_CTA;
    this.storedStatus = this.currentClosedStatus;
    this.showClosedOptions = true;
    this._toggleModal();
  }

  _handleWireCallback = ({ data, error, cb }) => {
    if (error) console.error(error);
    else if (data) {
      cb(data);
    }
  };

  _getPathItemFromStatus(status) {
    //console.log('entering getPathItemFromStatus...')
    const ariaSelected = !!this.storedStatus
      ? this.storedStatus.includes(status)
      : false;
    const isCurrent = !!this.status ? this.status.includes(status) : false;
    const classList = ['slds-path__item'];
    /* if (ariaSelected) {
      classList.push('slds-is-active');
    } else {
      classList.push('slds-is-incomplete');
    } */
    //all items are active in this implementation;
    classList.push('slds-is-active');

    /* if (isCurrent) {
      classList.push('slds-is-current');
    } */
    return {
      ariaSelected: false,
      class: classList.join(' '),
      label: status
    };
  }

  _toggleModal() {
    //this.template.querySelector('c-modal').toggleModal();
  }

  _getLeadValueOrDefault(data, val) {
    return data ? data.fields[val].displayValue : '';
  }



  _updateVisibleStatuses() {
    console.log('entering _updateVisibleStatuses');
    //update the shown statuses based on the selection
    const newStatuses = [];
    for (let index = 0; index < this.visibleStatuses.length; index++) {
      const status = this.visibleStatuses[index];
      const pathItem = this._getPathItemFromStatus(status.label);
      /* if (this.status !== this.storedStatus || pathItem.label !== this.status) {
        pathItem.class = pathItem.class
          .replace('slds-is-complete', '')
          .replace('  ', ' ');
      } */
      newStatuses.push(pathItem);
    }
    this.visibleStatuses = newStatuses;
  }
}