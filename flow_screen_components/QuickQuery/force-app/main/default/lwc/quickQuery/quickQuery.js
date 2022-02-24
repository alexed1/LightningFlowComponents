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
import getDefaultView from '@salesforce/apex/QuickRecordViewController.getDefaultView';
import updateRecords from '@salesforce/apex/QuickRecordViewController.updateRecords';
import deleteRecords from '@salesforce/apex/QuickRecordViewController.deleteRecords';
import updateSorting from '@salesforce/apex/QuickRecordViewController.updateSorting'

const CREATE_VALUE = 'Create';
const UPDATE_VALUE = 'Update';

export default class QuickRecordLWC extends NavigationMixin(LightningElement) {

  @api quickRecordViewId;
  @api recordDataString = '';
  @api recordDataStringAll = '';
  @api recordDataStringSelected = '';
  @api recordDataStringChanged = '';
  @api objectName;
  @api displayColumns;
  @api error = false;
  @api recordId;
  @api objectInput;
  @api set sortedBy(value) {
    this._sortedBy = value;
  }
  get sortedBy() {
    return this.sortedBy
  }

  @api set sortDirection(value) {
    this._sortDirection = value;

    setTimeout(
      () => {
        if(this._sortedBy && this._sortDirection) {
          updateSorting({
            viewId : this.selectedViewOption.value, 
            fieldSorting : JSON.stringify([{
              field : this._sortedBy, 
              sortingDirection : this._sortDirection.toUpperCase()
            }])
          }).then().catch(error => {
            console.error(error);
          });
        }
      }
    );
  }
  
  get sortDirection() {
    return this._sortDirection;
  }
  @track selectedViewOption = {};
  @track viewOptionList = [];
  @track filterFields = [];

  allOperators = [
    {value: 'equals', label: 'Equals'},
    {value: 'not_equal_to', label: 'is not'},
    {value: 'greater_then', label: 'is greater than'},
    {value: 'greater_or_equal', label: 'is greater than or equal to'},
    {value: 'less_then', label: 'is less than'},
    {value: 'less_or_equal', label: 'is less than or equal to'},
    {value: 'contains', label: 'Contains'},
    {value: 'starts_with', label: 'Starts with'},
    {value: 'end_with', label: 'End with'}
  ];

  

  viewNameSaveOptionValue = UPDATE_VALUE;
  viewName = '';
  
  selectedObject;
  displayLookup = true;
  displayModal = false;
  displayCSVConvertor = false;
  displayViewEditer = false;
  displayConfigureView = false;
  isRecordsUpdate = false;
  selectedViewId = '';
  
  chosenField = '';
  isShowFlow = false;
  defaultViewId = '';

  query = {operator:'equals'}
  _cancelBlur = false;
  _sortedBy = '';
  _sortDirection = '';

  get getObjectName() {
    return this.objectName.replace('__kav', '');
  }

  get viewNameSaveOptions() {
    if(this.selectedViewOption.value) {
      return [
          { label: 'Update existing View', value: UPDATE_VALUE },
          { label: 'Save as New View', value: CREATE_VALUE },
      ];
    } else {
      this.viewNameSaveOptionValue = CREATE_VALUE;
      return [
          { label: 'Save as New View', value: CREATE_VALUE },
      ];
    }
  }

  get isSaveViewDisabled() {

    let isSaveViewDisabled = true;
    this.filterFields.forEach(
      item => {
        if(item.operator) {
          isSaveViewDisabled = false;
        }
      }
    );
    return !this.selectedViewOption.value && isSaveViewDisabled;
  }
  query = {operator:'equals'}
  _cancelBlur = false;
  get getIcon(){
    return 'standard:'+this.objectName.toLowerCase().replace('__kav', '');
  }

  get flowContentClass() {
    return this.isShowFlow ? '' : 'slds-hide'
  }

  get flowParamsJSON () {
    let allRecordList = this.recordDataStringAll ? JSON.parse(this.recordDataStringAll) : [];
    let selectedRecordList = this.recordDataStringSelected ? JSON.parse(this.recordDataStringSelected) : [];

    return JSON.stringify([
      {
        name : 'allRecordDataIds',
        type : 'String',
        value : allRecordList.map(item => item.Id)
      },
      {
        name : 'selectedRecrodDataIds',
        type : 'String',
        value : selectedRecordList.map(item => item.Id)
      },
      {
        name : 'objectName',
        type : 'String',
        value : this.objectName
      },
      {
        name : 'fieldNames',
        type : 'String',
        value : this.filterFields.map(item => item.fieldName).join(',')
      }
    ]);
  }

  get сonfigureViewFlowParamsJSON () {
    
    return JSON.stringify([
      {
        name : 'flowDifId',
        type : 'String',
        value : this.selectedViewOption.value
      }
    ]);
  }

  get updateLabel() {
    if(this.selectedViewOption && this.selectedViewOption.value) {
      return UPDATE_VALUE;
    } else {
      return CREATE_VALUE;
    }
  }
  connectedCallback() {
    window.addEventListener('message', function(event) {
      if(event.data && event.data.flowStatus == 'FINISHED') {
        this.closeCSVConvertor();
        this.closeConfigureView();
      }
    }.bind(this), false);

    getDefaultView({recordId : this.recordId})
    .then(
      result => {
        if(result) {
          this.objectName = result.objectName;
          this.defaultViewId = result.viewId;
        }
        if(this.objectName) {
          this.handleSelectionChange({detail : [this.objectName]});
        }
      }
    ).catch(
      error => {
        console.error(error);
      }
    );
    // if(this.objectName) {
    //   this.handleSelectionChange({detail : [this.objectName]});
    // }
  }

  displayLookupHandler(){
    this.displayLookup = true;
  }
  blurLookupHandler() {
    if(this.objectName) {
      this.displayLookup = false;
    }
  }

  handleSelectionChange(event) {
    this.objectName = event.detail[0];
    if(this.objectName) {
      this.objectInput = this.objectName;
      this.recordDataStringAll = '';
      this.dispatchEvent(new FlowAttributeChangeEvent('objectName', this.objectName));
      this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
      this.displayLookup = false;
      getFlowTableViewDefinition({
          objectName : this.objectName
        }
      ).then(
        result => {
          this.viewOptionList = result;
          this.selectedViewOption = null;
          if(this.defaultViewId) {
            this.selectedViewOption = this.viewOptionList.find(item => item.value === this.defaultViewId);
          }
          if(!this.selectedViewOption) {
            this.selectedViewOption = this.viewOptionList[0];
          }

          this.selectedViewId = this.selectedViewOption.value;
          this.searcObjectFilterApiFiledsName();
          //this.getRecordDataStr();
        }
      ).catch(
        error => {
          this.error = error;
          console.error(error);
        }
      );
    } else {
      this.recordDataStringAll = '';
      this.selectedViewOption = {};
      this.selectedViewId = this.selectedViewOption.value;
      this.dispatchEvent(new FlowAttributeChangeEvent('objectName', this.objectName));
      this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
    }
  }
  searcObjectFilterApiFiledsName() {
    searcObjectFilterApiFiledsName({"viewId" : this.selectedViewOption.value, "objectName" : this.objectName})
          .then(result => {
            this.filterFields = JSON.parse(JSON.stringify(result));
            let valueList = [];
            this.filterFields.forEach(
            item => {
              valueList.push(item.fieldName);
              if(item.operator) { 
                item.operatorLabel = this.allOperators.find(
                  operator => operator.value === item.operator
                ).label;
              }
            }
          );
          this.dispatchEvent(new FlowAttributeChangeEvent('displayColumns', valueList.join(',')));
          this.updateTable();
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
    this.closeModalHandler();
    let index = event.target.dataset.index;
    this.chosenFieldIndex = index;
    this.filterFields[index].isSelected = true;
    this.chosenField = JSON.parse(JSON.stringify(this.filterFields[index]));
    this.query['filterName'] = this.filterFields[index].fieldName;
    this.query['objectName'] = this.objectName;
    this.displayModal = true;
    setTimeout(() => this.template.querySelector('[data-id="' + this.chosenField.fieldName +'"]').focus());
  }

  closeModalHandler(){
    if(!this._cancelBlur) {
      this.displayModal = false;
      if(this.filterFields) {
        this.filterFields.forEach(
          item => {
            item.isSelected = false;
          }
        );
      }
    }
  }

  setFieldsHandler(event){
    let operator = event.detail.operator;
    let value = event.detail.value;
    if(operator){
      this.query.operator = operator;
      this.query.value = value;
      this.chosenField.operator = operator;
      this.chosenField.value = value;
      this.chosenField.operatorLabel = this.allOperators.find(
        item => item.value === operator
      ).label;

    }
    if(!value){
      this.query.operator = null;
      this.query.value = null;
      this.chosenField.operator = null;
      this.chosenField.value = null;
    }
  }

  updateQueryHandler(){
    this._cancelBlur = false;
    this.filterFields[this.chosenFieldIndex] = this.chosenField;
    if(this.selectedViewOption && this.selectedViewOption.value) {
      this.selectedViewId = '';
    }
    this.updateTable();
    this.closeModalHandler();
  }

  handleKeyDown(event) {
    if(event.code == 'Tab') {
      event.preventDefault();
    }
    if(event.code == 'Escape') {
      this.closeModalHandler();
    }
    if(event.code == 'Enter') {
      this.updateQueryHandler();
    }
  }

  handleConfigureViewKeyDown(event) {
    if(event.code == 'Escape') {
      this.closeConfigureView();
    }
  }

  handleClearPillData(event){
    let index = event.target.dataset.index;
    this.filterFields[index].operator = null;
    this.filterFields[index].operatorLabel = null;
    this.filterFields[index].value = null;
    this.selectedViewId = '';
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
    this.selectedViewOption = this.viewOptionList.find(item => item.value === event.detail.value);
    this.selectedViewId = this.selectedViewOption.value;
    this.searcObjectFilterApiFiledsName();
    //this.getRecordDataStr();
  }

  
  getRecordDataStr(whereCondition) {
    this.isRecordsUpdate = true;
    this.recordDataStringAll = '';
    this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
    setTimeout(
      () => this.isRecordsUpdate = false, 
      2000
    );

    getRecordDataStr({
      objectName : this.objectName,
      viewId : this.selectedViewOption.value, 
      whereCondition : whereCondition, 
      recordId : this.recordId})
        .then(result => {
          result.forEach(
            item => {
              item.attributes = {
                type : this.objectName
              }
            }
          );
          this.recordDataStringAll = JSON.stringify(result);
          this.dispatchEvent(new FlowAttributeChangeEvent('recordDataStringAll', this.recordDataStringAll));
          this.recordDataStringChanged = '';
        })
        .catch(error => {
          console.log(error);
    });
  }

  showViewEditer() {
    this.displayViewEditer = true;
    this.viewName = this.selectedViewOption.label ? this.selectedViewOption.label : '';
    setTimeout(() => {
      let viewNameInput = this.template.querySelector(`[data-target-id="viewName"]`);
      viewNameInput.focus();
    });
    
  }

  changeViewName(event) {
    this.viewName = event.target.value;

    if(this.viewName === this.selectedViewOption.label) {
      this.viewNameSaveOptionValue = UPDATE_VALUE;
    } else {
      this.viewNameSaveOptionValue = CREATE_VALUE;
    }
  }

  focusViewNameHandler(event) {
    event.target.select();
  }
  closeViewEditer() {
    this.displayViewEditer = false;
  }

  updateViewName() {
    let viewName = this.template.querySelector(`[data-target-id="viewName"]`).value;
    this.viewName = viewName;
    let fieldList = [];
    this.filterFields.forEach(
      item => {
        fieldList.push(item.fieldName);
        delete item['isSelected'];
      }
    );
    upsertView({
      viewId : (this.viewNameSaveOptionValue === CREATE_VALUE) ? '' : this.selectedViewOption.value,
      viewName : viewName,
      objectName : this.objectName,
      fieldList : fieldList,
      filtersJSON : JSON.stringify(this.filterFields)
    }).then(
      result => {
        this.selectedViewOption.value = result;
        this.selectedViewOption.label = viewName;
        this.selectedViewId = this.selectedViewOption.value;
        this.viewOptionList = [...this.viewOptionList];
        this.displayViewEditer = false;
        const showToast = new ShowToastEvent({
          title: 'View Name was updated',
          message: 'View Name was updated successfully',
          variant: 'success',
        });
        this.viewNameSaveOptionValue = UPDATE_VALUE;
        this.dispatchEvent(showToast);   
        getFlowTableViewDefinition({
          objectName : this.objectName
        }
        ).then(
          result => {
            this.viewOptionList = result;
            this.updateTable();
          }
        ).catch(
          error => {
            this.error = error;
            console.error(error);
            const showToast = new ShowToastEvent({
              title: 'Error',
              message: 'View Name is duplicated',
              variant: 'Error',
            });
            this.dispatchEvent(showToast);   
          }
        ); 
      }
    ).catch(
      error => {
        console.error(error);
      }
    );
  }

  handleViewNameKeyDown(event) {
    if(event.code == 'Escape') {
      this.closeViewEditer();
    }
    if(event.code == 'Enter') {
      this.updateViewName();
    }
  }

  changeViewNameSaveOption(event) {
    let selectedOption = event.detail.value;
    this.viewNameSaveOptionValue = selectedOption;
    if(selectedOption === CREATE_VALUE && this.viewName === this.selectedViewOption.label) {
      this.viewName ='';
    }

  }

  showCSVConvertor() {
    this.displayCSVConvertor = true;
    this.isShowFlow = false;
    setTimeout(() => {
      this.isShowFlow = true;
    }, 3000);
  }

  closeCSVConvertor() {
    this.displayCSVConvertor = false;
  }

  showConfigureView() {
    this.displayConfigureView = true;
    this.isShowFlow = false;
    setTimeout(() => {
      this.isShowFlow = true;
    }, 3000);
  }

  closeConfigureView() {
    this.displayConfigureView = false;
    this.searcObjectFilterApiFiledsName();
    this.updateTable();
  }

  handleModalMouseDown(event) {
    const mainButton = 0;
    if (event.button === mainButton) {
        this._cancelBlur = true;
    }
  }

  handleModalMouseUp() {
    setTimeout(() => this._cancelBlur = false);
  }

  expressionBlur() {
    this.closeModalHandler();
  }

  saveRecords() {
    updateRecords({
      recordListJSON : this.recordDataStringChanged
    }).then(result => {
      this.updateTable();
    }).catch(error => {
      console.error(error);
      const showToast = new ShowToastEvent({
        title: 'Error',
        message: 'Records saving was not Successful',
        variant: 'Error',
      });
      this.dispatchEvent(showToast);
    })
  }

  deleteRecords() {
    deleteRecords({
      recordListJSON : this.recordDataStringChanged
    }).then(result => {
      this.updateTable();
    }).catch(error => {
      console.error(error);

      const showToast = new ShowToastEvent({
        title: 'Error',
        message: 'Records deletion was not Successful',
        variant: 'Error',
      });
      this.dispatchEvent(showToast);
    })
  }

}