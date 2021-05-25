import { LightningElement, api, track } from 'lwc';

export default class TargetKeySection extends LightningElement {
    @api masterLabel;
    @api addButtonLabel;
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
           if(!this._itemList) {
               this._itemList = [{key :'value1', value : '', order: 0}];
           }
       }

    };

    get listData () {
        if(this._itemList) {
            return this._itemList;
        } else {
            this._itemList = [{key: 'value1', value: '', order: 0}];
            return this._itemList;
        }
    }

    get isButtonDisable() {
        if(this.listData.length >= 20) {
            return true;
        }
        return false;
    }

    @track _itemList; //= [{key :'', value : ''}];

    addItem() {
        if(this._itemList.length < 20) {
            this._itemList.push({key:'value' + (this._itemList.length + 1), value:'', order : this._itemList.length});
        }
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
            element.key = 'value' + count;
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