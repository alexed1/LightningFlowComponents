import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

import apexSearchObjectApiName from '@salesforce/apex/LookupController.search';
import searcObjectFilterApiFiledsName from '@salesforce/apex/QuickRecordViewController.searchFilterFileds';
import addQueryToObj from '@salesforce/apex/QuickRecordViewController.placeQuery';
import getRecordDataStr from '@salesforce/apex/QuickRecordViewController.getRecordDataString';
import getFlowTableViewDefinition from '@salesforce/apex/QuickRecordViewController.getFlowTableViewDefinition';

export default class QuickRecordLWC extends NavigationMixin(LightningElement) {

  @api quickRecordViewId;
  @api recordDataString;
  @api objectName;
  @api displayColumns;
  @api error = false;
  @api objectInput;
  selectedObject;
  selectedViewOption = '';
  displayLookup = true;
  displayModal = false;
  viewOptionList = [];
  @track filterFields = [];
  chosenField = '';
  query = {operator:'equals'}

  get getIcon(){
    return 'standard:'+this.objectName.toLowerCase()
  }

  displayLookupHandler(){
    this.displayLookup = true;
  }

  handleSelectionChange(event) {
    this.objectName = event.detail[0];
    this.objectInput = this.objectName;
    this.dispatchEvent(new FlowAttributeChangeEvent('objectName', this.objectName));
    this.displayLookup = false;
    getFlowTableViewDefinition({
        objectName : this.objectName
      }
    ).then(
      result => {
        console.log('handleSelectionChange', result);
        this.viewOptionList = result;
        this.selectedViewOption = this.viewOptionList[0].value;
        this.searcObjectFilterApiFiledsName();
        this.getRecordDataStr();
      }
    ).catch(
      error => {
        this.error = error;
        console.error(error);
      }
    );
  }
  searcObjectFilterApiFiledsName() {
    searcObjectFilterApiFiledsName({"viewId" : this.selectedViewOption})
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
    if(operator){
      this.query.operator = operator;
      this.query.value = value;
      this.chosenField.operator = operator;
      this.chosenField.value = value;
    }
    if(!value){
      this.query.operator = null;
      this.query.value = null;
      this.chosenField.operator = null;
      this.chosenField.value = null;
    }
  }

  updateQueryHandler(){
    this.filterFields[this.chosenFieldIndex] = this.chosenField;
    this.updateTable();
    this.closeModalHandler();
  }

  handleKeyDown(event) {
    if(event.code == 'Escape') {
      this.closeModalHandler();
    }
    if(event.code == 'Enter') {
      this.updateQueryHandler();
    }
  }

  handleClearPillData(event){
    let index = event.target.dataset.index;
    this.filterFields[index].operator = null;
    this.filterFields[index].value = null;
    this.updateTable();
  }
  
  updateTable(){
    addQueryToObj({
      objectName : this.objectName,
      filterListJSON : JSON.stringify(this.filterFields)
    })
    .then(result => {
      this.getRecordDataStr(result);
    })
    .catch(error => {
      console.log(error);
    });
  }

  changeView(event) {
    console.log('changeView',event.detail.value);
    this.selectedViewOption = event.detail.value;
    this.searcObjectFilterApiFiledsName();
    this.getRecordDataStr();
  }

  
  getRecordDataStr(whereCondition) {
    getRecordDataStr({"objectName" : this.objectName, viewId : this.selectedViewOption, whereCondition : whereCondition})
        .then(result => {
          console.log('result', result);
          result.forEach(
            item => {
              item.attributes = {
                type : this.objectName
              }
            }
          );
          this.recordDataString = JSON.stringify(result);
          this.dispatchEvent(new FlowAttributeChangeEvent('recordDataString', this.recordDataString));
        })
        .catch(error => {
          console.log(error);
    });
  }

}