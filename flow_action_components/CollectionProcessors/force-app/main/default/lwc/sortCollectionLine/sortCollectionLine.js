import {LightningElement, api, track} from 'lwc';

export default class sortCollectionLine extends LightningElement {
    @api fields;
    @api position;

    @track _field;
    @track _direction;
    @track allDirections = [{label: 'ASC', value: 'ASC'}, {label: 'DESC', value: 'DESC'}];

    @api get field() {
        return this._field;
    }

    @api get direction() {
        return this._direction;
    }

    set field(value) {
        this._field = value;
    }

    set direction(value) {
        this._direction = value;
    }

    handleDirectionChange(event) {
        this._direction = event.detail.value;
        this.dispatchDataChangedEvent();
    }

    handleFieldChange(event) {
        this._field = event.detail.value;
        this.dispatchDataChangedEvent();
    }

    handleMove(event) {
        const moveEvt = new CustomEvent('reorder', {
            detail: {position: this.position, direction: parseInt(event.currentTarget.dataset.direction)}
        });
        this.dispatchEvent(moveEvt);
    }

    dispatchDataChangedEvent() {
        const dataChangedEvt = new CustomEvent('datachanged', {
            detail: {position: this.position, field: this._field, direction: this._direction}
        });
        this.dispatchEvent(dataChangedEvt);
    }
}