import {
  LightningElement,
  api,
  track
} from "lwc";
import {
  FlowAttributeChangeEvent
} from "lightning/flowSupport";
import {
  FlowNavigationNextEvent
} from "lightning/flowSupport";

/* eslint-disable no-alert */
/* eslint-disable no-console */

export default class visualNav extends LightningElement {
  @api value;
  @track item;
  @api choiceLabels; //string collection
  @api choiceSubLabels; //string collection
  @api choiceValues; //string collection
  @api choiceIcons; //string collection
  @api showIcons = false;
  @api showSubLabel = false;
  @api autoNext = false;
  @api extraValue;
  @api iconSize;
  @api required;
  @api outputLabel;
  @api outputSubLabel;
  @api outputUniqueId;
  @api iconVariant;
  @api buttonSize = 165;

  @track items = [];

  connectedCallback() {
    console.log("initializing visualPicker ");
    console.log("showIcons is: " + this.showIcons);
    console.log("choiceIcons is: " + this.choiceIcons);
    let items = [];
    let index = 0;
    console.log("choiceLabels is: " + this.choiceLabels);
    this.choiceLabels.forEach(label => {
      items.push({
        label: label,
        sublabel: this.choiceSubLabels[index],
        value: this.choiceValues[index],
        icon: this.choiceIcons[index],
        uniqueId: this.choiceValues[index] + "+" + index
      });
      console.log("items is: " + items);
      index += 1;
    });
    this.items = items;
  }

  @api
  validate() {
    //If the component is invalid, return the isValid parameter as false and return an error message.
    console.log(
      "entering validate: required=" + this.required + " value=" + this.value
    );
    let errorMessage = "You must make a selection to continue";

    if (this.required === true && !this.value) {
      return {
        isValid: false,
        errorMessage: errorMessage
      };
    }

    return {
      isValid: true
    };
  }

  handleChange(event) {
    this.outputLabel = event.target.dataset.outputlabel;
    this.outputSubLabel = event.target.dataset.outputsublabel;
    this.value = event.target.dataset.outputvalue;
    this.outputUniqueId = event.target.dataset.outputunique;
    console.log("outputLabel: ", this.outputLabel);
    console.log("outputSubLabel: ", this.outputSubLabel);
    console.log("value: ", this.value);
    console.log("uniqueId: ", this.outputUniqueId);
    this.dispatchEvent(new FlowAttributeChangeEvent("value", this.value));
    this.dispatchEvent(
      new FlowAttributeChangeEvent("outputLabel", this.outputLabel)
    );
    this.dispatchEvent(
      new FlowAttributeChangeEvent("outputSubLabel", this.outputSubLabel)
    );
    if (this.autoNext === true) {
      console.log("autoNext: ", this.autoNext);
      const nextNavigationEvent = new FlowNavigationNextEvent("navigate");
      this.dispatchEvent(nextNavigationEvent);
    }
  }

  handleKeyUp(event) {
    console.log("keyCode: ", event.keyCode);
    this.outputLabel = event.target.dataset.outputlabel;
    this.outputSubLabel = event.target.dataset.outputsublabel;
    this.value = event.target.dataset.outputvalue;
    this.outputUniqueId = event.target.dataset.outputunique;
    console.log("outputLabel: ", this.outputLabel);
    console.log("outputSubLabel: ", this.outputSubLabel);
    console.log("value: ", this.value);
    console.log("uniqueId: ", this.outputUniqueId);
    this.dispatchEvent(new FlowAttributeChangeEvent("value", this.value));
    this.dispatchEvent(
      new FlowAttributeChangeEvent("outputLabel", this.outputLabel)
    );
    this.dispatchEvent(
      new FlowAttributeChangeEvent("outputSubLabel", this.outputSubLabel)
    );
    if (event.keyCode === 13 || event.keyCode === 32) {
      const nextNavigationEvent = new FlowNavigationNextEvent("navigate");
      this.dispatchEvent(nextNavigationEvent);
    }
  }

  get sizeWidth() {
    return 'width: ' + this.buttonSize + 'px ; height: ' + this.buttonSize + 'px';
  }

}