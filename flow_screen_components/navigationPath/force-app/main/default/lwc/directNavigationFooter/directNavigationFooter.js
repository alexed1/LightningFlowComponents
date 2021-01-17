import { LightningElement, api} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';


export default class directNavigationFooter extends LightningElement {


        @api nextTargetName;
        @api prevTargetName;
        @api selectedTarget;
        @api lastScreen;
        prevButtonLabel = 'Previous';
        nextFinishLabel = 'Next';

        handleButtonClick(event) {
            console.log ('inbutton click. event is: ' + JSON.stringify(event.detail.selectedTarget));
            if(event.target.title == 'NextButton') {
                this.selectedTarget = this.nextTargetName;
            } else if(event.target.title == 'PreviousButton') {
                this.selectedTarget = this.prevTargetName;
            }
            console.log ('before attribute dispatch, title  ' + JSON.stringify(event.target.title));
            const attributeChangeEvent = new FlowAttributeChangeEvent('selectedTarget', this.selectedTarget );
            this.dispatchEvent(attributeChangeEvent);
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }

        get showPrevButton() {
            return (this.prevTargetName != null);
        }

        get showNextButton() {
            return (this.nextTargetName != null);
        }

        get nextButtonLabel() {
            if (this.lastScreen == true) {
                return 'Finish';
            } else return 'Next';
        }
}