import { LightningElement, api, track, wire } from 'lwc';


export default class SortingConfiguration extends LightningElement {
   

    @api objectName;
    @api get fieldSortingListString() {
        console.log('fieldSortingListString', this.fieldSortingList);
        return JSON.stringify(this.fieldSortingList);
    }

    set fieldSortingListString(value) {
        console.log('fieldSortingListString', this.fieldSortingList);
        if(value) {
            this.fieldSortingList = JSON.parse(value);
        }
    }

    @api get fieldList () {
        return this._fieldList;
    }
    
    set fieldList(value) {
        if(value) {
            value = JSON.parse(JSON.stringify(value));
            let fieldAPINameList = [];
            let fieldSortingList = [];
            value.forEach(
                (item, index) => {
                    fieldAPINameList.push(item.name);

                    let fieldSorting = this.fieldSortingList.find(
                            element => {
                                console.log('element', element);
                                return element.field === item.name
                            }
                    );
                    if(fieldSorting) {
                        fieldSortingList.push(fieldSorting);
                    } else {
                        
                        fieldSortingList.push({
                            field : item.name,
                            sortingDirection : 'ASC' 
                        });
                    }
                    
                }   
            );
            this.fieldSortingList = fieldSortingList;
            
            this._fieldList = value;
            this.selectedFieldListString = fieldAPINameList.join(',');
        } else {
            this._fieldList = [];
            this.selectedFieldListString = '';
        }
        console.log('fieldList', this._fieldList, this.selectedFieldListString);
    }

    @track _fieldList = [];
    @track fieldSortingList = [];

    @api selectedFieldListString;

    changeSorting(event) {
        console.log('changeSorting', JSON.stringify(event.detail));

        this.fieldSortingList[event.detail.index].sortingDirection = event.detail.sortingDirection;
    }

}