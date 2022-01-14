import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

import apexSearchObjectApiName from '@salesforce/apex/LookupController.search';
import searcObjectFilterApiFiledsName from '@salesforce/apex/QuickRecordViewController.searchFilterFileds';
import addQueryToObj from '@salesforce/apex/QuickRecordViewController.placeQuery';
import getRecordDataStr from '@salesforce/apex/QuickRecordViewController.getRecordDataString';
import getFlowTableViewDefinition from '@salesforce/apex/QuickRecordViewController.getFlowTableViewDefinition';
import upsertView from '@salesforce/apex/QuickRecordViewController.upsertView';
export default class QuickRecordLWC extends NavigationMixin(LightningElement) {

  @api quickRecordViewId;
  @api recordDataString = '';
  @api recordDataStringAll = '';
  @api recordDataStringSelected = '';
  @api objectName = 'Account';
  @api displayColumns;
  @api error = false;
  @api objectInput;
  selectedObject;
  @track selectedViewOption = {};
  displayLookup = true;
  displayModal = false;
  displayCSVConvertor = false;
  displayViewEditer = false;
  @track viewOptionList = [];
  @track filterFields = [];
  chosenField = '';
  query = {operator:'equals'}
  get getIcon(){
    return 'standard:'+this.objectName.toLowerCase()
  }

  get flowParamsJSON () {
    console.log('flowParams',this.recordDataStringSelected);
    return JSON.stringify([
      {
        name : 'recordDataStringAll',
        type : 'String',
        value : this.recordDataStringAll
      },
      {
        name : 'recordDataStringSelected',
        type : 'String',
        value : this.recordDataStringSelected
      }
      ,
      {
        name : 'objectName',
        type : 'String',
        value : this.objectName
      }
    ]);
  }
  
  connectedCallback() {
    //this.objectName = "Account";
    this.dispatchEvent(new FlowAttributeChangeEvent('objectName', this.objectName));
    this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
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
        this.selectedViewOption = this.viewOptionList[0];
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
    searcObjectFilterApiFiledsName({"viewId" : this.selectedViewOption.value})
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
    this.selectedViewOption = this.viewOptionList.find(item => item.value === event.detail.value) ;
    this.searcObjectFilterApiFiledsName();
    this.getRecordDataStr();
  }

  
  getRecordDataStr(whereCondition) {
    getRecordDataStr({"objectName" : this.objectName, viewId : this.selectedViewOption.value, whereCondition : whereCondition})
        .then(result => {
          console.log('result', result);
          result.forEach(
            item => {
              item.attributes = {
                type : this.objectName
              }
            }
          );
          this.recordDataStringAll = JSON.stringify(result);
          console.log('recordDataStringAll', JSON.stringify(result));
          this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
        })
        .catch(error => {
          console.log(error);
    });
  }

  showViewEditer() {
    this.displayViewEditer = true;
  }
  closeViewEditer() {
    this.displayViewEditer = false;
  }

  updateViewName() {
    let viewName = this.template.querySelector(`[data-target-id="viewName"]`).value;
    console.log('viewName', viewName);
    let fieldList = [];
    this.filterFields.forEach(
      item => {
        fieldList.push(item.fieldName);
      }
    );

    upsertView({
      viewId : this.selectedViewOption.value,
      viewName :viewName,
      objectName : this.objectName,
      fieldList :fieldList
    }).then(
      result => {
        console.log('result', result);
        this.selectedViewOption.value = result;
        this.selectedViewOption.label = viewName;
        this.viewOptionList = [...this.viewOptionList];
        this.displayViewEditer = false;
        const showToast = new ShowToastEvent({
          title: 'View Name was updated',
          message: 'View Name was updated successfully',
          variant: 'success',
        });
        this.dispatchEvent(showToast);      
      }
    ).catch(
      error => {
        console.error(error);
      }
    );
    //
  }

  showCSVConvertor() {
    this.displayCSVConvertor = true;
  }

  closeCSVConvertor() {
    this.displayCSVConvertor = false;
  }



}