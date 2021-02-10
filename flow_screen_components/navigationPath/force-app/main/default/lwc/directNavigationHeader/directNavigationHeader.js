import { api, LightningElement, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';




export default class directNavigationHeader extends LightningElement {
  
  @api targetStringCollection;
  @api targetStringCSV;
  @api selectedTarget;
  

  connectedCallback() {
      console.log('entering connectedCallback');

      if((this.targetStringCSV != null) && (this.targetStringCollection != null)) {
          console.log('error situation');
          alert("You can\'t provide both a CSV string and a string collection");
          //throw new Error("You can\'t provide both a CSV string and a string collection");
      }

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
  @track status;
  @track storedStatus;
  //@track visibleStatuses = [{label : 'foo', value : 'bar', class:'slds-is-incomplete'},{label : 'baz', value : 'qux',  class:'slds-is-incomplete'}];
  @track visibleStatuses = [];
  

  //truly private fields
  _hasRendered = false;
  _statuses;

  //private methods and getters

  handleStatusClick(event) {
    console.log('entering handleStatusClick. event label is: ' + JSON.stringify(event.target.title) + ' and event detail id is:  ' + event.detail.id +'and role is: ' + event.target.role);
    event.stopPropagation();
    //update the stored status, but don't update the record
    //till the save button is clicked
    const updatedStatusName = event.target.textContent;

    this.storedStatus = updatedStatusName;

    if (this.status !== this.storedStatus) {
      this._updateVisibleStatuses();
    }

    const attributeChangeEvent = new FlowAttributeChangeEvent('selectedTarget',event.target.title );
    this.dispatchEvent(attributeChangeEvent);
    const navigateNextEvent = new FlowNavigationNextEvent();
    this.dispatchEvent(navigateNextEvent);
  }

 


  _getPathItemFromStatus(status) {
    //console.log('entering getPathItemFromStatus...')
    const ariaSelected = !!this.storedStatus
      ? this.storedStatus.includes(status)
      : false;
    const isCurrent = !!this.status ? this.status.includes(status) : false;
    const classList = ['slds-path__item'];
    
    classList.push('slds-is-active');


    return {
      ariaSelected: false,
      class: classList.join(' '),
      label: status
    };
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

      newStatuses.push(pathItem);
    }
    this.visibleStatuses = newStatuses;
  }
}