import { LightningElement, api, track } from 'lwc';
const SORTING_DIRECTION_OPTIONS = [
    {
        label : 'Ascending',
        value : 'ASC'
    },
    {
        label : 'Descending',
        value : 'DESC'
    }
];
export default class SortingConfigurationLine extends LightningElement {
    get sortingDeriectionOptions () {
        return SORTING_DIRECTION_OPTIONS;
    }

    @api field = {};
    @api fieldList = [];
    @api availableFieldList = [];
    @api sortingDirection = 'ASC';
    @api objectName;
    @api index;
    isAvailableFieldsOpen = false;

    get isFirstItem() {
        return this.index === 0;
    }

    get fieldLabel () {
        console.log('fieldLabel', this.field, this.fieldList);
        let field = this.fieldList.find( item => this.field === item.name );
        console.log('fieldLabel1', field);
        return  field ? field.label : '';
    }

    changeOrderDirection(event) {
        this.sortingDirection = event.detail.value;
        this.dispatchChangeEvent();
    }


    changeField(event) {
        this.field = event.detail.value;
        this.dispatchChangeEvent();
    }

    dispatchChangeEvent() {
        const changeEvent = new CustomEvent('changesorting', {
            detail :{
                field : this.field,
                sortingDirection : this.sortingDirection,
                index : this.index
            }
        });
        this.dispatchEvent(changeEvent);
    }
    
    openAvailableFields() {
        console.log('openAvailableFields');
        this.isAvailableFieldsOpen = true;
    }

    closeAvailableFields() {
        this.isAvailableFieldsOpen = false;
    }

    preventCloseFields(event){
        event.preventDefault();
    }

    openAndSearchFields(event) {
        console.log('openAndSearchFields', event.detail.value);
        if(event.detail.value === '') {
            this.field = '';
            this.dispatchChangeEvent();
        }
    }

    chooseField(event) {
        this.field =  event.currentTarget.dataset.id;
        this.isAvailableFieldsOpen = false;
        this.dispatchChangeEvent();
    }

}