import { LightningElement, api } from 'lwc';
import Concentration from '@salesforce/resourceUrl/fsc_Quickchoice_Images';


export default class ReactiveImage extends LightningElement {

    @api
    get showBack() {
        return this._showBack;
    }
    set showBack(value) {
        this._showBack = value;
    }
    _showBack;

    @api
    get showFront() {
        return this._showFront;
    }
    set showFront(value) {
        this._showFront = value;
    }
    _showFront;

    imageBack = Concentration + '/astro.png';
    imageFront = Concentration + '/Sales.PNG';

}