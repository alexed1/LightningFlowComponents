import { api, LightningElement, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import LEAD_OBJECT from '@salesforce/schema/Lead';
//import CUSTOM_DATE_FIELD from '@salesforce/schema/Lead.CustomDate__c';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';

const CLOSED = 'Closed';
const CLOSED_CTA = 'Select Closed Status';
const MARK_COMPLETED = 'Mark Status as Complete';
const SPECIAL_STATUS = 'Closed - Special Date';

export default class CustomPath extends LightningElement {
  //start off with all @wire methods and dependencies
  //plus lifecycle methods
  @api recordId;
  //@wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
  objectInfo;

  /* @wire(getRecord, {
    recordId: '$recordId',
    fields: [LEAD_OBJECT, STATUS_FIELD]
  })
  lead({ data, error }) {
    const leadCb = (data) => {
      this.status = this._getLeadValueOrDefault(
        data,
        STATUS_FIELD.fieldApiName
      );
      this.storedStatus = this.status;
    /*   this.dateValue = this._getLeadValueOrDefault(
        data,
        CUSTOM_DATE_FIELD.fieldApiName
      ); 
      if (this.status && this.status.includes(CLOSED)) {
        this.advanceButtonText = CLOSED_CTA;
        this.currentClosedStatus = this.status;
        this.customCloseDateSelected =
          this.currentClosedStatus === SPECIAL_STATUS;
      }
    };

    this._handleWireCallback({ data, error, cb: leadCb });
  } */

  /* @wire(getPicklistValues, {
    recordTypeId: '$objectInfo.data.defaultRecordTypeId',
    fieldApiName: STATUS_FIELD
  })
  leadStatuses({ data, error }) {
    const leadStatusCb = (data) => {
      const statusList = [];
      data.values.forEach((picklistStatus) => {
        if (!picklistStatus.label.includes(CLOSED)) {
          statusList.push(picklistStatus.label);
        }
      });
      statusList.push('Closed');
      this._statuses = statusList;

      //now build the visible/closed statuses
      data.values.forEach((status) => {
        if (status.label.includes(CLOSED)) {
          this.closedStatuses.push({
            label: status.label,
            value: status.label
          });
          if (!this.currentClosedStatus) {
            //promote the first closed value to the component
            //so that the combobox can show a sensible default
            this.currentClosedStatus = status.label;
          }
        } else {
          this.visibleStatuses.push(this._getPathItemFromStatus(status.label));
        }
      });
      this.visibleStatuses.push(this._getPathItemFromStatus(CLOSED));
    };
    this._handleWireCallback({ data, error, cb: leadStatusCb });
  } */

  renderedCallback() {
      console.log('entering renderedCallback');
     
    if (!this._hasRendered && this.hasData) {
      //prevents the advance button from jumping to the side
      //as the rest of the component loads
      this.showAdvanceButton = true;
      this._hasRendered = true;
    }
    console.log('entering renderedcallback2');
    //if (this.hasData) {
       // console.log('entering hasdata');
      //on the first render with actual data
      //we have to manually set the aria-selected value
      const current = this.visibleStatuses.find((status) =>
        this.storedStatus.includes(status.label)
      ) || { label: 'Unknown' };
      current.ariaSelected = true;
      current.class = 'slds-path__item slds-is-current slds-is-active';

      const currentIndex = this.visibleStatuses.indexOf(current);
      this.visibleStatuses.forEach((status, index) => {
        if (index < currentIndex) {
          status.class = status.class.replace(
            'slds-is-incomplete',
            'slds-is-complete'
          );
        }
      });
      this._updateVisibleStatuses();
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
  @track visibleStatuses = [{label : 'foo', value : 'bar', class:'slds-is-incomplete' },{label : 'baz', value : 'qux',  class:'slds-is-incomplete'}];


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
    event.stopPropagation();
    //update the stored status, but don't update the record
    //till the save button is clicked
    const updatedStatusName = event.target.textContent;
    this.advanceButtonText =
      updatedStatusName === this.status
        ? MARK_COMPLETED
        : 'Mark As Current Status';
    this.storedStatus = updatedStatusName;

    if (this.status !== this.storedStatus) {
      this._updateVisibleStatuses();
    }

    if (this.storedStatus === CLOSED) {
      this._advanceToClosedStatus();
    }
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

  async handleAdvanceButtonClick(event) {
    event.stopPropagation();

    if (
      this.status === this.storedStatus &&
      !this.storedStatus.includes(CLOSED)
    ) {
      const nextStatusIndex =
        this.visibleStatuses.findIndex(
          (visibleStatus) => visibleStatus.label === this.status
        ) + 1;
      this.storedStatus = this.visibleStatuses[nextStatusIndex].label;
      if (nextStatusIndex === this.visibleStatuses.length - 1) {
        //the last status should always be "Closed"
        //and the modal should be popped
        this._advanceToClosedStatus();
      } else {
        await this._saveLeadAndToast();
      }
    } else if (this.storedStatus.includes(CLOSED)) {
      //curses! they closed the modal
      //let's re-open it
      this._advanceToClosedStatus();
    } else {
      await this._saveLeadAndToast();
    }
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
    const ariaSelected = !!this.storedStatus
      ? this.storedStatus.includes(status)
      : false;
    const isCurrent = !!this.status ? this.status.includes(status) : false;
    const classList = ['slds-path__item'];
    if (ariaSelected) {
      classList.push('slds-is-active');
    } else {
      classList.push('slds-is-incomplete');
    }
    if (isCurrent) {
      classList.push('slds-is-current');
    }
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

  async _saveLeadAndToast() {
    let error;
    try {
      this.status = this.storedStatus;
      const recordToUpdate = {
        fields: {
          Id: this.recordId,
          Status: this.status,
          CustomDate__c: null
        }
      };
      if (this.dateValue && this.status === SPECIAL_STATUS) {
        recordToUpdate.fields.CustomDate__c = this.dateValue;
      }
      await updateRecord(recordToUpdate);
      this._updateVisibleStatuses();
      this.advanceButtonText = MARK_COMPLETED;
    } catch (err) {
      error = err;
      console.error(err);
    }
    //not crazy about this ternary
    //but I'm even less crazy about the 6
    //extra lines that would be necessary for
    //a second object
    this.dispatchEvent(
      new ShowToastEvent({
        title: !error ? 'Success!' : 'Record failed to save',
        variant: !error ? 'success' : 'error',
        message: !error
          ? 'Record successfully updated!'
          : `Record failed to save with message: ${JSON.stringify(error)}`
      })
    );
    //in reality, LDS errors are a lot uglier and should be handled gracefully
    //I recommend the `reduceErrors` utils function from @tsalb/lwc-utils:
    //https://github.com/tsalb/lwc-utils/blob/master/force-app/main/default/lwc/utils/utils.js
  }

  _updateVisibleStatuses() {
    //update the shown statuses based on the selection
    const newStatuses = [];
    for (let index = 0; index < this.visibleStatuses.length; index++) {
      const status = this.visibleStatuses[index];
      const pathItem = this._getPathItemFromStatus(status.label);
      if (this.status !== this.storedStatus || pathItem.label !== this.status) {
        pathItem.class = pathItem.class
          .replace('slds-is-complete', '')
          .replace('  ', ' ');
      }
      newStatuses.push(pathItem);
    }
    this.visibleStatuses = newStatuses;
  }
}