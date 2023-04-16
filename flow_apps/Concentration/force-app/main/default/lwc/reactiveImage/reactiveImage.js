import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import Concentration from '@salesforce/resourceUrl/fsc_Quickchoice_Images';


export default class ReactiveImage extends LightningElement {

    get showBack() {
        return this._showBlank ? false : this._showBack;
    }
    set showBack(value) {
        this._showBack = value;
    }
    _showBack;

    get showFront() {
        return this._showBlank ? false : this._showFront;
    }
    set showFront(value) {
        this._showFront = value;
    }
    _showFront;

    get showBlank() {
        return this._showBlank;
    }
    set showBlank(value) {
        this._showBlank = value;
    }
    _showBlank;

    @api
    get exposedId1() {
        return this._exposedId1;
    }
    set exposedId1(value) {
        this._exposedId1 = value;
        if (value == this._cardId && this._showFront) {
            console.log('Image Show Blank', this._cardId);
            this._showBack = false;
            this._showFront = false;
            this._showBlank = true;
        }
        this.updateStatus();
    }
    _exposedId1;

    @api
    get exposedId2() {
        return this._exposedId2;
    }
    set exposedId2(value) {
        this._exposedId2 = value;
        if (value == this._cardId && this._showFront) {
            console.log('Image Show Blank', this._cardId);
            this._showBack = false;
            this._showFront = false;
            this._showBlank = true;
        }
        this.updateStatus();
    }
    _exposedId2;

    @api 
    get cardId() {
        return this._cardId;
    }
    set cardId(value) {
        this._cardId = value;
    }
    _cardId;

    @api 
    get isSecond() {
        return this._isSecond;
    }
    set isSecond(value) {
        this._isSecond = value;
    }
    _isSecond;

    // @api 
    // get cardStatus() {
    //     return this._cardStatus;
    // }
    // set cardStatus(value) {
    //     if (value == 'REFRESH') {
    //         console.log('Image REFRESH', this._cardId, this._exposedId);
    //         if (this._cardId == this._exposedId && this._showFront) {  // Match
    //             this._showBlank = true;
    //         }
    //         value = 'DONE';
    //     }
    //     this._cardStatus = value;
    //     this.dispatchFlowAttributeChangedEvent('cardStatus', this._cardStatus);
    // }
    // _cardStatus;

    imageBack = Concentration + '/astro.png';
    imageFront = Concentration + '/Sales.PNG';
    imageBlank = Concentration + '/Service.PNG';

    // isClick = false;

    connectedCallback() {
        console.log('Image Connected - Exposed Id', this._cardId, this._exposedId1, this._exposedId2);
        // if (this._exposedId == null && !this._showBlank) {
        //     this._showBack = true;
        // }
    }
    
    renderedCallback() {
        console.log('Image Connected - Exposed Id', this._cardId, this._exposedId1, this._exposedId2);
        // if (this._exposedId == null && !this._showBlank) {
        //     this._showBack = true;
        // }
    }

    clickHandler(event) {
        console.log('Image Click - Exposed Id', this._cardId, this._exposedId1, this._exposedId2);
        // this.isCLick = true;
        if (this._isSecond) {
            if (this._cardId == this._exposedId1) {  // Match
                this._showBlank = true;
            }
            this._exposedId2 = this._cardId;
            this.dispatchFlowAttributeChangedEvent('exposedId2', this._exposedId2);
        } else {
            this._showFront = true;
            this._showBack = false;
            this._exposedId1 = this._cardId;
            this.dispatchFlowAttributeChangedEvent('exposedId1', this._exposedId1);
            this._isSecond = true;
            this.dispatchFlowAttributeChangedEvent('isSecond', this._isSecond);
        }
        this.dispatchFlowAttributeChangedEvent('exposedId', this._cardId);
    }

    updateStatus() {
        // this.dispatchFlowAttributeChangedEvent('cardStatus', 'REFRESH');
        // const currentStatus = this._cardStatus;
        // console.log('Image Current Status', this._cardId, this._cardStatus);
        // if (currentStatus = 'first') {
        //     this._cardStatus = 'second';
        // } else if (currentStatus = 'second') {
        //     this._cardStatus = 'waiting';
        // } else {
        //     this._cardStatus = 'first';
        // }
        // this.dispatchFlowAttributeChangedEvent('cardStatus', this._cardStatus);
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        console.log('Image Dispatch', this._cardId, attributeName, attributeValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}