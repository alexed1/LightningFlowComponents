import { LightningElement, api, track, wire } from 'lwc';


export default class SortingConfiguration extends LightningElement {
   

    @api objectName;
    @api get fieldList () {
        return this._fieldList;
    }

    set fieldList(value) {
        console.log('aaaaaaaaa');
        if(value) {
            value = JSON.parse(JSON.stringify(value));
            value.forEach(
                (item, index) => {
                    item.index = index;
                }
            );
            this._fieldList = value;
        } else {
            this._fieldList = [];
        }

        console.log('fieldList', this._fieldList);
    }

    @track _fieldList = [];

    changeSorting(event) {
        console.log('changeSorting', JSON.stringify(event.detail));
    }

}