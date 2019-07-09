/* eslint-disable no-console */
import { LightningElement } from 'lwc';

export default class ExpressionLine extends LightningElement {

    handleChange(event) {
        console.log('handleChange triggered: ' + event.target.value);
        
    }
}