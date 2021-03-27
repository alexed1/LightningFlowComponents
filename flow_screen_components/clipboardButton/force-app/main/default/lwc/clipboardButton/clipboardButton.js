/**
 * Lightning Web Component for Flow Screens:            clipboardButton
 * 
 * This clipboardButton component is designed to be used on a FLow Screen where the value passed to the component 
 * is displayed and when the button is clicked, the value will be inserted into the system clipboard
 * 
 * Additional components packaged with this LWC:
 * 
 *                      Lightning Web Components:       clipboardButtonCPE

 * CREATED BY:          Eric Smith
 * 
 * VERSION:             1.0.0
 * 
 * RELEASE NOTES:       https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/clipboardButton/README.md
 * 
**/

import { LightningElement, api } from "lwc";

const CB_TRUE = "CB_TRUE"; // Used with fsc_flowCheckbox component
const CB_FALSE = "CB_FALSE"; // Used with fsc_flowCheckbox component

export default class ClipboardButton extends LightningElement {
  // Component Input Attributes
  @api buttonLabel = "";
  @api clipboardContent = "";
  @api clipboardLabel = "";
  @api contentSize;
  @api buttonIcon = "utility:copy";
  @api buttonVariant = "nuetral";
  @api buttonClass = "slds-m-left_x-small";
  @api buttonName = "CopyButton_00";
  @api buttonSize = "medium";
  @api visibility = "slds-show";

  @api
  get removeClipboard() {
    return this.cb_removeClipboard == CB_TRUE ? true : false;
  }
  @api cb_removeClipboard;

  @api
  get iconOnly() {
    return this.buttonLabel.length == 0;
  }

  @api
  get hasLabel() {
    return this.clipboardLabel.length > 0;
  }

  handleClick(event) {
    this.pushClipboard(this.clipboardContent);
    if (this.removeClipboard) {
      this.visibility = "slds-hide";
    }
  }

  pushClipboard(content) {
    // Put the selected attribute value in the clipboard
    let inp = this.template.querySelector(".my-clipboard");
    inp.disabled = false;
    inp.value = content;
    inp.select();
    document.execCommand("copy");
    inp.disabled = true;
  }
}
