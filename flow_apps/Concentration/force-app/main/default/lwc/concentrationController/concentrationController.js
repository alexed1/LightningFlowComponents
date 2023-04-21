/**
 * Lightning Web Component for Flow Screens:            concentrationController
 * 
 * Displays a Play Again button, count of attempts, and shows confetti on game completeion.  
 * It outputs the card value, when two sequential card selections match, along with unique game information.  For input it takes the value of of each individual card as it is selected.
 * 
 * This is part of a 2 component package for a Concentration Game screen flow that demonstrates how a compoent's input can be reactive to another component's output.
 * 
 * Additional components packaged with this LWC:
 * 
 *                      Lightning Web Components:       concentrationCard

 * CREATED BY:          Eric Smith
 * 
 * VERSION:             1.0.0
 * 
 * DATE:                4/21/2023
 * 
 * RELEASE NOTES:       
 * 
**/

import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import { loadScript } from 'lightning/platformResourceLoader';

// JavaScript confetti app from Kiril Vatev (https://github.com/catdad/canvas-confetti)
import CONFETTI from '@salesforce/resourceUrl/ers_confetti';

export default class ConcentrationController extends LightningElement {

    imageCount = 28;
    cardCount = 12;

    waitValue = 500;
    waitEvent;
    priorExposedCount = 0;
    matchCount = 0;

    myconfetti;
    @track showHide = "slds-hide";

    get mismatchCounter() {
        return this._mismatchCounter * -1;
    }
    set mismatchCounter(value) {
        this._mismatchCounter = value;
    }
    _mismatchCounter = 1;

    //  --- Handle (updateExposed) component logic when any one of the cards has been flipped over ---
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
    //  --- End of possible inputs coming from the output of any of the concentrationCard components ---

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

    get attempts() {    // Text to show the number of pairing attempts
        let number = this._mismatchCounter - 1;
        let word = (number == 1 ? 'Try' : 'Tries');
        return (number > 0) ? `<h3>${number} ${word}</h3>` : ``;
    }

    get isFirst() {
        return _isFirst;
    }
    set isFirst(value) {
        this._isFirst = value;
    }
    _isFirst = true;

    cardValue1 = '';
    cardValue2 = '';

    get sequence() {    // Create an array for each of the card pairs in the game
        let arr = [];
        let i = 0;
        while (i < this.cardCount/2) {
            i++;
            arr.push(i);
            arr.push(i);
        }
        return arr;
    }

    get imageMaster() { // Create an array for each of the possible card images
        let arr = [];
        let i = 0;
        while (arr.push(i) < this.imageCount) {
            i++;
        }
        return arr;
    }
    
    shuffled = [];

    get buildKey() {    // Build the gameKey holding the value of the image to be used by each card.  Each image will be assigned to two cards.
        return `A${this.shuffled[0]}B${this.shuffled[1]}C${this.shuffled[2]}D${this.shuffled[3]}E${this.shuffled[4]}F${this.shuffled[5]}G${this.shuffled[6]}H${this.shuffled[7]}I${this.shuffled[8]}J${this.shuffled[9]}K${this.shuffled[10]}L${this.shuffled[11]}`;
    }

    connectedCallback() {   
        // Load the Confetti code
        Promise.all([
            loadScript(this, CONFETTI )
        ])
            .then(() => {
                this.setUpCanvas();
            })
            .catch(error => {
                console.log('Error loading Confetti', error.message);
            });

        // Create the unique game values (card images and card order)
        this.waitEvent = setTimeout(() => {
            // Shuffle and assign the images to card pairs
            this.shuffled = this.shuffle(this.sequence);
            this._gameKey = this.buildKey;
            this.dispatchFlowAttributeChangedEvent('gameKey', this._gameKey);
            // Shuffle and assign the order the cards will placed on the screen
            this._imageOrder = this.shuffle(this.imageMaster).join();
            this.dispatchFlowAttributeChangedEvent('imageOrder', this._imageOrder);
            // Now that the confetti script has loaded, it is ok to display this component
            this.showHide = "slds-show";
        }, this.waitValue);
    }

    shuffle(array) {    // Shuffle an array of values
        let curId = array.length;
        while (0 !== curId) {   // There remain elements to shuffle
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

    // This is where the output from each of the concentrationCard components gets processed
    updateExposed(value) {
        if (!(value < 0)) {
            if (this._isFirst) {
                this.cardValue1 = value;
                this._isFirst = false;
            } else {
                this.cardValue2 = value;
                if (this.cardValue1 == this.cardValue2) {
                    this._matchId = value;
                    this.matchCount++;
                    if (this.matchCount == this.cardCount/2) {  // All pairs found - fire off the confetti
                        this.fireworks();
                    }
                } else {
                    this._matchId = this.mismatchCounter;
                }
                this.dispatchFlowAttributeChangedEvent('matchId', this._matchId);   // Let each of the concentrationCard components know the results of the card comparison
                this._mismatchCounter++;
                this._isFirst = true;
            }
        }
    }

    handlePlayAgain() {     // Exit the flow so it will restart
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
    }
    
    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {  // Let the flow know an output value has changed
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

    setUpCanvas() {     // Prep the canvas for the confetti
        var confettiCanvas = this.template.querySelector("canvas.confettiCanvas");
        this.myconfetti = confetti.create(confettiCanvas, { resize: true });
        this.myconfetti({
            zIndex: 10000
        });
    }

    fireworks() {       // Fire off the fireworks option for the confetti
        var end = Date.now() + 5 * 1000;    // Show fireworks for 5 seconds
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        let interval = setInterval(function() {
            if (Date.now() > end) {
            return clearInterval(interval);
        }
        // eslint-disable-next-line no-undef
        confetti({
            startVelocity: 30,
            spread: 360,
            ticks: 60,
            origin: {
                x: Math.random(),
                // since they fall down, start a bit higher than random
                y: Math.random() - 0.2
            }
        });
        }, 200);
    }

}