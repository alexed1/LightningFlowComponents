import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class ReactiveController extends LightningElement {

    @api
    get exposedId_11() {
        return this._exposedId_11;
    }
    set exposedId_11(value) {
        this._exposedId_11 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_11;

    @api
    get exposedId_12() {
        return this._exposedId_12;
    }
    set exposedId_12(value) {
        this._exposedId_12 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_12;

    @api
    get exposedId_13() {
        return this._exposedId_13;
    }
    set exposedId_13(value) {
        this._exposedId_13 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_13;

    @api
    get exposedId_21() {
        return this._exposedId_21;
    }
    set exposedId_21(value) {
        this._exposedId_21 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_21;

    @api
    get exposedId_22() {
        return this._exposedId_22;
    }
    set exposedId_22(value) {
        this._exposedId_22 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_22;

    @api
    get exposedId_23() {
        return this._exposedId_23;
    }
    set exposedId_23(value) {
        this._exposedId_23 = value;
        // this._exposedId = value;
        this.updateExposed(value);
    }
    _exposedId_23;

    @api
    get exposedId1() {
        console.log('Controller Get', this._exposedId1);
        return this._exposedId1;
    }
    set exposedId1(value) {
        console.log('Controller Set', value);
        this._exposedId1 = value;
        // this.dispatchFlowAttributeChangedEvent('exposedId', this._exposedId)
    }
    _exposedId1;

    @api
    get exposedId2() {
        console.log('Controller Get', this._exposedId2);
        return this._exposedId2;
    }
    set exposedId2(value) {
        console.log('Controller Set', value);
        this._exposedId2 = value;
        // this.dispatchFlowAttributeChangedEvent('exposedId', this._exposedId)
    }
    _exposedId2;

    // @api
    // get cardStatus() {
    //     return this._cardStatus;
    // }
    // set cardStatus(value) {
    //     this._cardStatus = value;
    // }
    // _cardStatus;

    @api
    get isSecond() {
        return this._isSecond;
    }
    set isSecond(value) {
        this._isSecond = value;
    }
    _isSecond;

    connectedCallback() {
        // const dummy = this.exposedId;
        console.log('Controller Connected', this._exposedId, this._isSecond);
    }

    renderedCallback() {
        // const dummy = this.exposedId;
        console.log('Controller Rendered', this._exposedId, this._isSecond);
        // this.dispatchFlowAttributeChangedEvent('exposedId', this._exposedId);
    }

    updateExposed(value) {
        // const currentStatus = this._cardStatus;
        // console.log('Controller Current Status', this._cardId, this._cardStatus);
        // if (currentStatus = 'first') {
        //     this._cardStatus = 'second';
        // } else if (currentStatus = 'second') {
        //     this._cardStatus = 'waiting';
        // } else {
        //     this._cardStatus = 'first';
        // }
        if (this._isSecond) {
            this._exposedId2 = value;
            this.dispatchFlowAttributeChangedEvent('exposedId2', this._exposedId2);
            this._isSecond = false;
            this.dispatchFlowAttributeChangedEvent('isSecond', this._isSecond);
        } else {
            this._exposedId1 = value;
            this.dispatchFlowAttributeChangedEvent('exposedId1', this._exposedId1);
            this._isSecond = true;
            this.dispatchFlowAttributeChangedEvent('isSecond', this._isSecond);
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        console.log('Controller Dispatch', attributeName, attributeValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}