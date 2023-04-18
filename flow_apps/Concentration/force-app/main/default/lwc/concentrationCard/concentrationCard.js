import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import Concentration from '@salesforce/resourceUrl/ers_ConcentrationImages';

export default class ConcentrationCard extends LightningElement {

    waitValue = 1000;
    waitEvent;

    imageArray = [
        'Appy', 'Astro', 'Astro20', 'Brandy', 'C18', 
        'Cloudy', 'Codey', 'Earnie', 'Einstein', 'Einstein19', 
        'Flo', 'Genie', 'Hootie', 'Koa', 'Max', 
        'Ruth', 'S12', 'S14', 'S15', 'S15r', 
        'S17', 'S17r', 'S18', 'S20', 'S20r'
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
        if (!this._showBlank) {
            if (value == this._cardValue) {
                this.waitEvent = setTimeout(() => {
                    this._showBack = false;
                    this._showFront = false;
                    this._showBlank = true;
                }, this.waitValue);
            } else {
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
    imageFront = Concentration + '/Blank.png';

    connectedCallback() {
        const gameKey = localStorage.getItem('gameKey');
        const locateId = gameKey.indexOf(this.cardId);
        this._cardValue = parseInt(gameKey.substring(locateId+1,locateId+2));
        const imageOrder = localStorage.getItem('imageOrder').split(",");
        this.imageFront = Concentration + '/' + this.imageArray[imageOrder[this._cardValue]] + '.png';
    }

    clickHandler(event) {
        if (this._showBack) {
            this._showBack = false;
            this._showFront = true;
            this.dispatchFlowAttributeChangedEvent('exposedId', this._cardValue);
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}