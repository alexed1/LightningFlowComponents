import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import Concentration from '@salesforce/resourceUrl/fsc_Quickchoice_Images';

export default class ConcentrationCard extends LightningElement {

    waitValue = 1000;
    waitEvent;

    get mismatchCounter() {
        return this._mismatchCounter * -1;
    }
    set mismatchCounter(value) {
        this._mismatchCounter = value;
    }
    _mismatchCounter = 0;

    @api cardId;

    @api
    get cardValue() {
        return this._cardValue;
    }
    set cardValue(value) {
        this._cardValue = value;
    }
    _cardValue;

    @api
    get matchId() {
        return this._matchId;
    }
    set matchId(value) {
        console.log('Card Match: Id, match, Back, Front, Blank', this._cardValue, value, this._showBack, this._showFront, this._showBlank);
        if (value >= 10000) {
            this._showBlank = false;
            this._showFront = false;
            this._showBack = true;
            this.dispatchFlowAttributeChangedEvent('exposedId', 99);
        } else {
            if (!this._showBlank) {
                console.log('Card is not Blank', this._cardValue);
                if (value == this._cardValue) {
                    console.log('Card value matches', this._cardValue, value);
                    this._showBack = false;
                    this._showFront = false;
                    this._showBlank = true;
                } else {
                    console.log('Card value does not match', this._cardValue, value);
                    this.waitEvent = setTimeout(() => {
                        this._showBlank = false;
                        this._showFront = false;
                        this._showBack = true;
                        this.dispatchFlowAttributeChangedEvent('exposedId', this._mismatchCounter);
                        this._mismatchCounter++;
                    }, this.waitValue);
                }
            }
            this._matchId = value;
        }
    }
    _matchId;

    @api
    get exposedId() {
        return this._exposedId;
    }
    set exposedId(value) {
        this._exposedId = value;

    }
    _exposedId;

    get showBack() {
        return this._showBack
    }
    set showBack(value) {
        this._showBack = value;
    }
    _showBack = true;

    get showFront() {
        return this._showFront
    }
    set showFront(value) {
        this._showFront = value;
    }
    _showFront = false;

    get showBlank() {
        return this._showBlank;
    }
    set showBlank(value) {
        this._showBlank = value;
    }
    _showBlank = false;

    imageBack = Concentration + '/astro.png';
    imageFront = Concentration + '/Sales.PNG';
    imageBlank = Concentration + '/Service.PNG';

    pause(milliseconds) {
        this.waitEvent = setTimeout(() => {}, milliseconds);
    }

    clickHandler(event) {
        console.log('Click Handler Card, showBack', this._cardValue, this._showBack);
        if (this._showBack) {
            this._showBack = false;
            this._showFront = true;
            this.dispatchFlowAttributeChangedEvent('exposedId', this._cardValue);
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        console.log('Card Dispatch', this._cardValue, attributeName, attributeValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}