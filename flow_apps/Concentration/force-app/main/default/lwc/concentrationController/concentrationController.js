import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class ConcentrationController extends LightningElement {

    imageCount = 25;
    cardCount = 6;

    get mismatchCounter() {
        return this._mismatchCounter * -1;
    }
    set mismatchCounter(value) {
        this._mismatchCounter = value;
    }
    _mismatchCounter = 1;

    @api
    get exposedId_11() {
        return this._exposedId_11;
    }
    set exposedId_11(value) {
        this._exposedId_11 = value;
        this.updateExposed(value);
    }
    _exposedId_11;

    @api
    get exposedId_12() {
        return this._exposedId_12;
    }
    set exposedId_12(value) {
        this._exposedId_12 = value;
        this.updateExposed(value);
    }
    _exposedId_12;

    @api
    get exposedId_13() {
        return this._exposedId_13;
    }
    set exposedId_13(value) {
        this._exposedId_13 = value;
        this.updateExposed(value);
    }
    _exposedId_13;

    @api
    get exposedId_21() {
        return this._exposedId_21;
    }
    set exposedId_21(value) {
        this._exposedId_21 = value;
        this.updateExposed(value);
    }
    _exposedId_21;

    @api
    get exposedId_22() {
        return this._exposedId_22;
    }
    set exposedId_22(value) {
        this._exposedId_22 = value;
        this.updateExposed(value);
    }
    _exposedId_22;

    @api
    get exposedId_23() {
        return this._exposedId_23;
    }
    set exposedId_23(value) {
        this._exposedId_23 = value;
        this.updateExposed(value);
    }
    _exposedId_23;

    @api
    get matchId() {
        return this._matchId;
    }
    set matchId(value) {
        this._matchId = value;
    }
    _matchId;

    get isFirst() {
        return _isFirst;
    }
    set isFirst(value) {
        this._isFirst = value;
    }
    _isFirst = true;

    cardValue1 = '';
    cardValue2 = '';

    get sequence() {
        let arr = [];
        let i = 0;
        while (i < this.cardCount/2) {
            i++;
            arr.push(i);
            arr.push(i);
        }
        console.log('sequence', arr);
        return arr;
    }

    get imageMaster() {
        let arr = [];
        let i = 0;
        while (arr.push(i) < this.imageCount) {
            i++
        }
        console.log('imageMaster', arr);
        return arr;
    }
    
    shuffled = [];
    imageOrder = [];

    get buildKey() {
        return `A${this.shuffled[0]}B${this.shuffled[1]}C${this.shuffled[2]}D${this.shuffled[3]}E${this.shuffled[4]}F${this.shuffled[5]}`;
    }

    connectedCallback() {
        this.shuffled = this.sequence.sort(() => Math.random() - 0.5);
        localStorage.setItem('gameKey', this.buildKey);
        this.imageOrder = this.shuffle(this.imageMaster);
        localStorage.setItem('imageOrder', this.imageOrder);
    }

    shuffle(array) {
        let curId = array.length;
        // There remain elements to shuffle
        while (0 !== curId) {
            // Pick a remaining element
            let randId = Math.floor(Math.random() * curId);
            curId -= 1;
            // Swap it with the current element.
            let tmp = array[curId];
            array[curId] = array[randId];
            array[randId] = tmp;
        }
        return array;
    }

    updateExposed(value) {
        if (!(value < 0)) {
            if (this._isFirst) {
                this.cardValue1 = value;
                this._isFirst = false;
            } else {
                this.cardValue2 = value;
                this._matchId = (this.cardValue1 == this.cardValue2) ? value :this.mismatchCounter;
                this.dispatchFlowAttributeChangedEvent('matchId', this._matchId);
                this._mismatchCounter++;
                this._isFirst = true;
            }
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