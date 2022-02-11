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
    @api sortingDirection = 'ASC';
    @api objectName;
    @api index;

    get isFirstItem() {
        return this.index === 0;
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

}