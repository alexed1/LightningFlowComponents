import { LightningElement, api, track, wire } from 'lwc';
const MAX_FIELD_SORTING_SIZE = 4;

export default class SortingConfiguration extends LightningElement {
   

    @api objectName;
    @api fieldSortingListString; 
    @track fieldSortingList = [];
    get availableFieldList() {
        let availableFieldList = this._fieldList.filter(
            field => {
                let fieldSorting = this.fieldSortingList.find(
                    item => field.name === item.field
                );

                return !fieldSorting;
            }
        );

        return availableFieldList;
    }

    @api get fieldList () {
        return this._fieldList;
    }
    
    set fieldList(value) {
        if(value) {
            this._fieldList = JSON.parse(JSON.stringify(value)); 
        } else {
            this._fieldList = [];
        }
    }

    @track _fieldList = [];
    @track fieldSortingList = [];

    @api selectedFieldListString;

    connectedCallback() {
        if(this.fieldSortingListString){
            this.fieldSortingList = JSON.parse(this.fieldSortingListString);
        } else {
            this.fieldSortingList = [];
        }
        if(this._fieldList) {
            if(!this.fieldSortingList || this.fieldSortingList.length === 0){
                
                let fieldSortingList = [];
                this._fieldList.forEach(
                    (item, index) => {
                        if(index < 4) {
                            fieldSortingList.push({
                                field : item.name,
                                sortingDirection : 'ASC' 
                            });   
                        }   
                    }   
                );

                this.fieldSortingList = fieldSortingList;
            } else {
                for(let i = this.fieldSortingList.length ; i < MAX_FIELD_SORTING_SIZE ; i++) {
                    this.fieldSortingList.push({
                        field : '',
                        sortingDirection : 'ASC' 
                    });
                }
            }
            let fieldAPINameList = [];
            this._fieldList.forEach(
                (item) => {
                    fieldAPINameList.push(item.name);
                }
            );
            
                
            this.selectedFieldListString = fieldAPINameList.join(',');
            
        } else {
            this._fieldList = [];
            this.selectedFieldListString = '';
        }
    }
    changeSorting(event) {
        this.fieldSortingList[event.detail.index].sortingDirection = event.detail.sortingDirection;
        this.fieldSortingList[event.detail.index].field = event.detail.field;
        let fieldAPINameList = [];
        
        this.fieldSortingList.forEach(
            (item, index) => {
                if(!event.detail.field && index > event.detail.index) {
                    item.field = '';
                }
            }
        );
        this.fieldSortingList.forEach(
            (item, index) => {
                fieldAPINameList.push(item.field);
            }
        );
        this.fieldSortingListString = JSON.stringify(this.fieldSortingList.filter(item => item.field))
    }

    @api validate() {
        let isFieldDuplicate = false;
        this.fieldSortingList.forEach(
            (item, index) => {
                for(let i = index; i < this.fieldSortingList.length - 1; i++) {
                    if(item.field && item.field === this.fieldSortingList[i + 1].field) {
                        isFieldDuplicate = true;
                        break;
                    }
                    
                }
               
            }
        );

        if(isFieldDuplicate) { 
            return { 
                isValid: false, 
                errorMessage: 'Field duplication' 
            };  
        } else { 
            return { isValid: true }; 
        } 
    }

}