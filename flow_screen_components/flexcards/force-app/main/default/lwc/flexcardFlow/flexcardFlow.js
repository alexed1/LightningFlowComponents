import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class FlexcardFlow extends LightningElement {

    @api value;
    @api selectedLabel;
    @api records;
    @api visibleFieldNames;
    @api visibleFlowNames;
    @api src;
    @api icon;
    @api cardSize = 300;
    @api avatarField;
    @track fieldHTML='';
    @track recordLayoutData={};
    @track objectInfo;
    curRecord;

     @wire(getObjectInfo, { objectApiName: 'Account' })
    recordInfo({ data, error }) {
        if (data) {
            this.objectInfo = data;
            //console.log('AssignedResource Label => ', data.fields.AssignedResource.label);
        }
    } 


    connectedCallback() {
        console.log('entering connectedCallback');
        console.log('records are: ' + JSON.stringify(this.records));
           }

    //for each record:
    // for each fieldname, create a data structure called fieldData with that fieldname, the label of that field, and the value
    // add the fieldData to recordLayoutData 
           //TODO: remove this because it's not used? 
    assembleFieldLayout(item, index) {
        this.curRecord = item;
        console.log('visibleFieldNames is: ' + JSON.stringify(this.visibleFieldNames));
        this.visibleFieldNames.split(",").forEach(this.appendFieldInfo, this);

    }


    retrieveFieldLabels(item, index) {
        console.log('retrieving field label for field named: ' + item);
        //call apex to get field labels for fields
    }
    
    appendFieldInfo(item, index) {
        console.log('entering append...fieldName is: ' + item);
        console.log('and record is: ' + JSON.stringify(this.curRecord));
        //console.log('this is: ' + this);
        this.fieldHTML = this.fieldHTML + ' <h2> ' + item + ' </h2>';
        console.log('fieldHTML is now: ' + this.fieldHTML);
    }

    get isDataLoaded() {
        return this.objectInfo && this.records.length > 0;
    }

//set card width and height

get sizeWidth() {
    return 'width: ' + this.cardSize + 'px ; height: ' + this.cardSize + 'px';
  }


}
