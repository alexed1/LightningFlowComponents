import { LightningElement, api, track, wire } from 'lwc';


export default class SortingConfiguration extends LightningElement {
   

    @api objectName;
    @api get fieldSortingListString() {
        return JSON.stringify(this.fieldSortingList);
    }

    set fieldSortingListString(value) {
        if(value) {
            this.fieldSortingList = [];
            let fieldSortingList = JSON.parse(value);
            this.fieldList.forEach(
                field => {
                    let fieldSoritng = fieldSortingList.find(item => field.name === item.field);
                    if(fieldSoritng) {
                        this.fieldSortingList.push(fieldSoritng);
                    } else {
                        this.fieldSortingList.push({
                            field : field.name,
                            sortingDirection : 'ASC' 
                        });
                    }
                }
            );
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
    }

    @track _fieldList = [];
    @track fieldSortingList = [];

    @api selectedFieldListString;

    changeSorting(event) {
        this.fieldSortingList[event.detail.index].sortingDirection = event.detail.sortingDirection;
    }

}