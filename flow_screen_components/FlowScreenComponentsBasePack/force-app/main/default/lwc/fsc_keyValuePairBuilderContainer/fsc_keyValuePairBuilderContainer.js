import { LightningElement, api, track } from 'lwc';

export default class fsc_KeyValuePairBuilderContainer extends LightningElement {


    @api masterLabel;
    @api addButtonLabel;
    _builderContext;
    _flowVariables;
    
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
               this._itemList = [{key :'', value : '', order: 0}];
           }
       }
    };

    get listData () {
       return this._itemList;
    }

    @api 
    get builderContext() {
        return this._builderContext;
    }

    set builderContext(context) {
        
        this._builderContext = context || {};
        if (this._builderContext) {
            const { variables } = this._builderContext;
            this._flowVariables = [...variables];
        }
    }

    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
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
        this._itemList.forEach(element => {
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