import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import Concentration from '@salesforce/resourceUrl/Concentration';

export default class ConcentrationCard extends LightningElement {

    waitValue = 1000;
    waitEvent;

    imageArray = [
        'Appy',
        'Astro',
        'Brandy',
        'C18',
        'Cloudy',
        'Codey',
        'Einstein',
        'Genie',
        'Hootie',
        'Max',
        'Ruth',
        'S12',
        'S14',
        'S15',
        'S17',
        'S17r',
        'S18',
        'S20'
    ];

    get mismatchCounter() {
        return this._mismatchCounter * -1;
    }
    set mismatchCounter(value) {
        this._mismatchCounter = value;
    }
    _mismatchCounter = 1;

    @api cardId;

    @api
    get matchId() {
        return this._matchId;
    }
    set matchId(value) {
        console.log('Card Match: Id, match, Back, Front, Blank', this.cardId, this._cardValue, value, this._showBack, this._showFront, this._showBlank);
        if (!this._showBlank) {
            console.log('Card is not Blank', this.cardId, this._cardValue);
            if (value == this._cardValue) {
                console.log('Card value matches', this.cardId, this._cardValue, value);
                this.waitEvent = setTimeout(() => {
                    this._showBack = false;
                    this._showFront = false;
                    this._showBlank = true;
                }, this.waitValue);
            } else {
                console.log('Card value does not match', this.cardId, this._cardValue, value);
                this.waitEvent = setTimeout(() => {
                    this._showBlank = false;
                    this._showFront = false;
                    this._showBack = true;
                    this.dispatchFlowAttributeChangedEvent('exposedId', this.mismatchCounter);
                    this._mismatchCounter++;
                }, this.waitValue);
            }
        }
        this._matchId = value;
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

    get cardValue() {
        return this._cardValue;
    }
    set cardValue(value) {
        this._cardValue = value;
    }
    _cardValue;

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

    imageBack = Concentration + '/Salesforce.png';
    imageBlank = Concentration + '/Blank.png';
    imageFront = Concentration + '/S15.png';

    connectedCallback() {
        const gameKey = localStorage.getItem('gameKey');
        const locateId = gameKey.indexOf(this.cardId);
        this._cardValue = parseInt(gameKey.substring(locateId+1,locateId+2));
        const imageOrder = localStorage.getItem('imageOrder').split(",");
        console.log('imageOrder',imageOrder);
        console.log('_cardValue', this._cardValue);
        console.log('imageOrder[cv]', imageOrder[this._cardValue])
        console.log('imageArray', this.imageArray[imageOrder[this._cardValue]]);
        this.imageFront = Concentration + '/' + this.imageArray[imageOrder[this._cardValue]] + '.png';
        console.log('Card Connected', this.cardId, gameKey, imageOrder, this._cardValue, this.imageFront);
    }

    clickHandler(event) {
        console.log('Click Handler Card, showBack', this.cardId, this._cardValue, this._showBack);
        if (this._showBack) {
            this._showBack = false;
            this._showFront = true;
            this.dispatchFlowAttributeChangedEvent('exposedId', this._cardValue);
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        console.log('Card Dispatch', this.cardId, this._cardValue, attributeName, attributeValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}