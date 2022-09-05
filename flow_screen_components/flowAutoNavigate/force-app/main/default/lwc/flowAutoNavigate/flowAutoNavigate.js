import { LightningElement, api, track, } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class flowAutoNavigate extends LightningElement {
    @track timeVal = '0:0:0:0';
    @api maxTime;
    @api showTimer;
    @api showReset;
    @api timerLabel;
    @api availableActions = [];

    timeIntervalInstance;
    totalMilliseconds = 0;

    connectedCallback() {
        var parentThis = this;


        // Run timer code in every 100 milliseconds
        parentThis.timeIntervalInstance = setInterval(function () {

            // Time calculations for hours, minutes, seconds and milliseconds
            var hours = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((parentThis.totalMilliseconds % (1000 * 60)) / 1000);
            var milliseconds = Math.floor((parentThis.totalMilliseconds % (1000)));

            // Output the result in the timeVal variable
            parentThis.timeVal = hours + ":" + minutes + ":" + seconds + ":" + milliseconds;

            parentThis.totalMilliseconds += 100;
        }, 100);



    }

    renderedCallback() {
        var parentThis = this;
        // Navigate to the next step in the flow either next action or finish
        if (parentThis.timeVal === parentThis.maxTime) {
            if (parentThis.availableActions.find(action => action === 'NEXT')) {
                const navigateNextEvent = new FlowNavigationNextEvent();
                parentThis.dispatchEvent(navigateNextEvent);
                console.log("navigate next");
            } else if (parentThis.availableActions.find(action => action === 'FINISH')) {
                const navigateFinishEvent = new FlowNavigationFinishEvent();
                parentThis.dispatchEvent(navigateFinishEvent);
                console.log("navigate finish");
            }
        }




    }

    reset(event) {
        // Reset the timer
        this.timeVal = '0:0:0:0';
        this.totalMilliseconds = 0;
        clearInterval(this.timeIntervalInstance);
        this.connectedCallback();
    }


}