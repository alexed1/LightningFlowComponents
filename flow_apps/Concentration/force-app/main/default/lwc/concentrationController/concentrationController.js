import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class ConcentrationController extends LightningElement {

    imageCount = 28;
    cardCount = 12;

    waitValue = 500;
    waitEvent;
    priorExposedCount = 0;

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
    get exposedId_31() {
        return this._exposedId_31;
    }
    set exposedId_31(value) {
        this._exposedId_31 = value;
        this.updateExposed(value);
    }
    _exposedId_31;

    @api
    get exposedId_32() {
        return this._exposedId_32;
    }
    set exposedId_32(value) {
        this._exposedId_32 = value;
        this.updateExposed(value);
    }
    _exposedId_32;

    @api
    get exposedId_33() {
        return this._exposedId_33;
    }
    set exposedId_33(value) {
        this._exposedId_33 = value;
        this.updateExposed(value);
    }
    _exposedId_33;

    @api
    get exposedId_41() {
        return this._exposedId_41;
    }
    set exposedId_41(value) {
        this._exposedId_41 = value;
        this.updateExposed(value);
    }
    _exposedId_41;

    @api
    get exposedId_42() {
        return this._exposedId_42;
    }
    set exposedId_42(value) {
        this._exposedId_42 = value;
        this.updateExposed(value);
    }
    _exposedId_42;

    @api
    get exposedId_43() {
        return this._exposedId_43;
    }
    set exposedId_43(value) {
        this._exposedId_43 = value;
        this.updateExposed(value);
    }
    _exposedId_43;

    @api
    get matchId() {
        return this._matchId;
    }
    set matchId(value) {
        this._matchId = value;
    }
    _matchId;

    @api
    get imageOrder() {
        return this._imageOrder;
    }
    set imageOrder(value) {
        this._imageOrder = value;
    }
    _imageOrder;
    
    @api
    get gameKey() {
        return this._gameKey;
    }
    set gameKey(value) {
        this._gameKey = value;
    }
    _gameKey;

    get cardsExposed() {
        return this._cardsExposed;
    }
    set cardsExposed(value) {
        this._cardsExposed = value;
        if (this._cardsExposed != this.priorExposedCount) {
            // this.dispatchFlowAttributeChangedEvent('cardsExposed', this._cardsExposed);
            this.priorExposedCount = this._cardsExposed;
        }
    }
    _cardsExposed;

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
            i++;
        }
        console.log('imageMaster', arr);
        return arr;
    }
    
    shuffled = [];
    // imageOrder = [];

    get buildKey() {
        return `A${this.shuffled[0]}B${this.shuffled[1]}C${this.shuffled[2]}D${this.shuffled[3]}E${this.shuffled[4]}F${this.shuffled[5]}G${this.shuffled[6]}H${this.shuffled[7]}I${this.shuffled[8]}J${this.shuffled[9]}K${this.shuffled[10]}L${this.shuffled[11]}`;
    }

    connectedCallback() {
        console.log('CONTROLLER Connected');
        this.waitEvent = setTimeout(() => {
            // this.shuffled = this.sequence.sort(() => Math.random() - 0.5);
            this.shuffled = this.shuffle(this.sequence);
            this._gameKey = this.buildKey;
            this.dispatchFlowAttributeChangedEvent('gameKey', this._gameKey);
            // localStorage.setItem('gameKey', this.buildKey);
            this._imageOrder = this.shuffle(this.imageMaster).join();
            this.dispatchFlowAttributeChangedEvent('imageOrder', this._imageOrder);
            // localStorage.setItem('imageOrder', this.imageOrder);
            // this.dispatchFlowAttributeChangedEvent('isFirst', this._isFirst);
        }, this.waitValue);
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
            // this.dispatchFlowAttributeChangedEvent('isFirst', this._isFirst);
        }
    }

    handlePlayAgain() {
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
    }
    
    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}