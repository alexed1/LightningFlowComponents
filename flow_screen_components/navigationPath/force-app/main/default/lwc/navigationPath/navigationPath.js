import { LightningElement, api } from 'lwc';

export default class NavigationPath extends LightningElement {

    @api placeholder;

    handleStepBlur(event) {
        const stepIndex = event.detail.index;
        console.log('in handleStepBlur...event is:' + JSON.stringify(event.detail));
    }

    handleStepFocus(event) {
        console.log('in handleStepFocus...event is:' + JSON.stringify(event.detail));
    }

    handleStepMouseEnter(event) {
        
        console.log('in handleStepMouseEnter...event is:' + JSON.stringify(event.detail));
    }


    handleStepMouseLeave(event) {
        
        console.log('in handleStepMouseLeave...event is:' + JSON.stringify(event.detail));
    }


}