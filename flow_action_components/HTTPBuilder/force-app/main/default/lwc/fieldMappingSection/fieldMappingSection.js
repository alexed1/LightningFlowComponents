import { LightningElement, api, track } from 'lwc';

export default class FieldMappingSection extends LightningElement {
    @api masterLabel;
    @api addButtonLabel;
    @api sobjectType;

    @api set listData(value) {
       if(value) {
           this._itemList = JSON.parse(value);
           let i = 0;
           this._itemList.forEach(
               item => {
                   item.order = i;
                   i++;
               }
           );
       } else {
           //if(!this._itemList) {
               this._itemList = [{key :'', value : '', order: 0}];
           //}
       }

    };

    get listData () {
        if(this._itemList) {
            return this._itemList;
        } else {
            this._itemList = [{key: '', value: '', order: 0}];
            return this._itemList;
        }
    }

    @track _itemList; //= [{key :'', value : ''}];

    addItem() {
        this._itemList.push({key:'', value:'', order : this._itemList.length});   
    }

    changeItem(event) {
        let item = event.detail.entity;
        this._itemList[item.order] = item;

        this.dispatchChange();

    }

    removeItem(event) {
        let item = event.detail.entity;
        
        this._itemList.splice(item.order, 1);
        let count = 1;
        this._itemList.forEach(element => {
            count++;
            if(element.order > item.order){
                element.order--;
            }
        });
        this.dispatchChange();
    }

    dispatchChange() {
        const removeItemEvent = new CustomEvent('changelist', {
            detail: {
                value: JSON.stringify(this._itemList),
            }
        });
        this.dispatchEvent(removeItemEvent);
        
    }
}