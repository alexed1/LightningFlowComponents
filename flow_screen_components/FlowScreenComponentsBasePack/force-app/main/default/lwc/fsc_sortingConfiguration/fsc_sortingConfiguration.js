import { LightningElement, api, track, wire } from 'lwc';


export default class SortingConfiguration extends LightningElement {
   

    @api objectName;
    @api get fieldSortingListString() {
        return JSON.stringify(this.fieldSortingList);
    }

    set fieldSortingListString(value) {
        console.log('fieldSortingListString', this.fieldSortingList);
        if(value) {
            if(!this.fieldSortingList || this.fieldSortingList.length === 0){
                let fieldSortingList = JSON.parse(value);
                this.fieldSortingList = [];
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
        console.log('fieldSortingListString2', this.fieldSortingList);
    }

    @api get fieldList () {
        return this._fieldList;
    }
    
    set fieldList(value) {
        console.log('fieldList', this.fieldSortingList);
        if(value) {
            value = JSON.parse(JSON.stringify(value));
            let fieldAPINameList = [];
            //let fieldSortingList = [];
            value.forEach(
                (item, index) => {
                    fieldAPINameList.push(item.name);

                    // let fieldSorting = this.fieldSortingList.find(
                    //         element => {
                    //             return element.field === item.name
                    //         }
                    // );
                    // if(fieldSorting) {
                    //     fieldSortingList.push(fieldSorting);
                    // } else {
                            
                    //     fieldSortingList.push({
                    //         field : item.name,
                    //         sortingDirection : 'ASC' 
                    //     });
                    // }
                        
                }   
            );
            //this.fieldSortingList = fieldSortingList;
                
            this._fieldList = value;
            this.selectedFieldListString = fieldAPINameList.join(',');
            
        } else {
            this._fieldList = [];
            this.selectedFieldListString = '';
        }

        console.log('fieldList', this.fieldSortingList);
    }

    @track _fieldList = [];
    @track fieldSortingList = [];

    @api selectedFieldListString;

    changeSorting(event) {
        console.log(JSON.stringify(event.detail));
        this.fieldSortingList[event.detail.index].sortingDirection = event.detail.sortingDirection;
        this.fieldSortingList[event.detail.index].field = event.detail.field;
        console.log('changeSorting', this.fieldSortingList);
        let fieldAPINameList = [];
        this.fieldSortingList.forEach(
            (item, index) => {
                fieldAPINameList.push(item.field);
            }
        );
        this.selectedFieldListString = fieldAPINameList.join(',');
    }

    @api validate() {
        let isFieldDuplicate = false;
        console.log('validate', this.fieldSortingList);
        this.fieldSortingList.forEach(
            (item, index) => {
                for(let i = index; i < this.fieldSortingList.length - 1; i++) {
                    if(item.field === this.fieldSortingList[i + 1].field) {
                        isFieldDuplicate = true;
                        break;
                    }
                }
            }
        );

        if(isFieldDuplicate) { 
            console.log('validate reporting false');
            return { 
                isValid: false, 
                errorMessage: 'Field duplication' 
                }; 
            } 
        else { 
            console.log('validate reporting true');
            return { isValid: true }; 
        } 
    }

}