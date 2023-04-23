/**
 * Lightning Web Component for Flow Screens:            concentrationCard
 * 
 * Displays a card showing either the card back, the card front, or a blank space.  
 * It outputs the card value and for input it takes the value of matched cards as well as unique game information.    
 * 
 * This is part of a 2 component package for a Concentration Game screen flow that demonstrates how a compoent's input can be reactive to another component's output.
 * 
 * Additional components packaged with this LWC:
 * 
 *                      Lightning Web Components:       concentrationController

 * CREATED BY:          Eric Smith
 * 
 * VERSION:             1.0.0
 * 
 * DATE:                4/21/2023
 * 
 * RELEASE NOTES:       
 * 
**/

import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import Concentration from '@salesforce/resourceUrl/ers_ConcentrationImages';    // Card Images

export default class ConcentrationCard extends LightningElement {

    waitValue = 1000;
    waitEvent;

    get imageCache() {
        return this._imageCache;
    }
    set imageCache(value) {
        this._imageCache = value;
    }
    _imageCache;

    get notStarted() {
        return !this.isConnected;
    }

    // Card Image Filenames
    imageArray = [
        'Appy', 'Astro', 'Astro18', 'Astro20', 'Brandy', 'C18', 
        'Cloudy', 'Codey', 'Earnie', 'Einstein', 'Einstein19', 
        'Flo', 'Genie', 'Hootie', 'Koa', 'Max', 'Codey23',
        'Ruth', 'S12', 'S14', 'S15', 'S15r', 'Ruth23',
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
    // This is where the output from the concentrationController component gets processed
    set matchId(value) {   
        this.allowClick = false;    // Don't allow another card to be selected until the comparison of the prevous two cards is completed
        if (!this._showBlank) {
            // Pause before removing or flipping cards back over
            if (value == this._cardValue) {     // We have a match, show a blank space instead of a card
                this.waitEvent = setTimeout(() => {
                    this._showBack = false;
                    this._showFront = false;
                    this._showBlank = true;
                    this.allowClick = true;
                }, this.waitValue);
            } else {                            // The two selected cards do not match, flip them back over
                this.waitEvent = setTimeout(() => {
                    this._showBlank = false;
                    this._showFront = false;
                    this._showBack = true;
                    this.dispatchFlowAttributeChangedEvent('exposedId', this.mismatchCounter);
                    this._mismatchCounter++;
                    this.allowClick = true;
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

    @api
    get imageOrder() {
        return this._imageOrder;
    }
    // imageOrder is used to select which image to use for the card front and is randomized and provided by the concentrationController component
    set imageOrder(value) {
        this.imageFront = Concentration + '/' + this.imageArray[value.split(",")[this._cardValue]] + '.png';
        this._imageOrder = value;
    }
    _imageOrder;
    
    @api
    get gameKey() {
        return this._gameKey;
    }
    // gameKey is used to assign the locations of the card value pairs and is randomized and provided by the concentrationController component
    set gameKey(value) {
        const locateId = value.indexOf(this.cardId);
        this._cardValue = parseInt(value.substring(locateId+1,locateId+2));
        this._gameKey = value;
    }
    _gameKey;

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

    isConnected = false;
    allowClick = true;

    connectedCallback() {
        // Try to cache the card images to reduce the lag when a card is first clicked
        this.imageArray.forEach(img => {
            this._imageCache = Concentration + '/' + img + '.png';
        });
        // Pause to allow the concentrationController component to provide the game seeding values
        this.waitEvent = setTimeout(() => {
            this.isConnected = true;
            this.allowClick = true;
        }, this.waitValue/2);
    }

    clickHandler(event) {
        if (this.isConnected && this.allowClick) {
            if (this._showBack) {   // Flip the card over if the back is showing
                this._showBack = false;
                this._showFront = true;
                this.dispatchFlowAttributeChangedEvent('exposedId', this._cardValue);
            }
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {  // Let the flow know an output value has changed
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}