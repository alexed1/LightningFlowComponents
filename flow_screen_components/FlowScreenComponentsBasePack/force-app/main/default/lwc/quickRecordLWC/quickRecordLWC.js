import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

import apexSearchObjectApiName from '@salesforce/apex/LookupController.search';
import searcObjectFilterApiFiledsName from '@salesforce/apex/QuickRecordViewController.searchFilterFileds';
import addQueryToObj from '@salesforce/apex/QuickRecordViewController.placeQuery';
import getRecordDataStr from '@salesforce/apex/QuickRecordViewController.getRecordDataString';

export default class QuickRecordLWC extends NavigationMixin(LightningElement) {

  @api quickRecordViewId;
  @api recordDataString;
  @api objectName;
  @api displayColumns;
  @api error = false;
  selectedObject;
  displayLookup = true;
  displayModal = false;
  @track filterFields = [];
  chosenField = ''
  query = {operator:'equals'}

  get getIcon(){
    return 'standard:'+this.objectName.toLowerCase()
  }

  displayLookupHandler(){
    this.displayLookup = true;
  }

  handleSelectionChange(event) {
    this.objectName = event.detail[0];
    this.dispatchEvent(new FlowAttributeChangeEvent('objectName', this.objectName));
    this.displayLookup = false;
    searcObjectFilterApiFiledsName({"searchTerm" : event.detail[0]})
        .then(result => {
          this.filterFields = JSON.parse(JSON.stringify(result));
          let valueList = [];
          this.filterFields.forEach(
          item => {
            valueList.push(item.fieldName);
          }
        );
        this.dispatchEvent(new FlowAttributeChangeEvent('displayColumns', valueList.join(',')));
        })
        .catch(error => {
          this.error = error;
          console.error(error);
    });
    getRecordDataStr({"objectName" : this.objectName})
        .then(result => {
          this.recordDataString = JSON.stringify(result);
          this.dispatchEvent(new FlowAttributeChangeEvent('recordDataString', this.recordDataString));
        })
        .catch(error => {
          console.log(error);
    });
  }

  handleSearch(event) {
    const lookupElement = event.target;
    apexSearchObjectApiName(event.detail)
        .then(results => {
            lookupElement.setSearchResults(results);
        })
        .catch(error => {
            console.log(error)
        });
  }

  clearError(){
    this.error = false;
  }

  handleRemovePill(event){
    let index = event.target.dataset.index;
    this.filterFields.splice(index,1);
    let valueList = [];
          this.filterFields.forEach(
          item => {
            valueList.push(item.fieldName);
          }
        );
        this.dispatchEvent(new FlowAttributeChangeEvent('displayColumns', valueList.join(',')));
    
  }
  chosenFieldIndex;
  displayModalHandler(event){
    let index = event.target.dataset.index;
    this.chosenFieldIndex = index;
    this.chosenField = JSON.parse(JSON.stringify(this.filterFields[index]));
    this.query['filterName'] = this.filterFields[index].fieldName;
    this.query['objectName'] = this.objectName;
    this.displayModal = true;
  }

  closeModalHandler(){
    this.displayModal = false;
  }

  setFieldsHandler(event){
    let operator = event.detail.operator;
    let value = event.detail.value;
    if(operator && value){
      this.query.operator = operator;
      this.query.value = value;
      this.chosenField.operator = operator;
      this.chosenField.value = value;
    }
  }

  updateQueryHandler(){
    this.filterFields[this.chosenFieldIndex] = this.chosenField;
    addQueryToObj({
      objectName : this.objectName,
      filterListJSON : JSON.stringify(this.filterFields)
    })
    .then(result => {
      this.closeModalHandler();
      getRecordDataStr({"objectName" : this.objectName, "whereCondition" : result})
      .then(result => {
        this.recordDataString = JSON.stringify(result);
        this.dispatchEvent(new FlowAttributeChangeEvent('recordDataString', this.recordDataString));
      })
      .catch(error => {
        console.log(error);
      });
    })
    .catch(error => {
      console.log(error);
    });
  }

}