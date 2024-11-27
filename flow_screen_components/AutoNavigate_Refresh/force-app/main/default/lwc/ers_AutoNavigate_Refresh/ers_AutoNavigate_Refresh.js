/**
 * Lightning Web Component for Flow Screens:            ers_AutoNavigate_Refresh
 * 
 * This component is designed to be used on a FLow Screen when you need to refresh the console tabs and/or 
 * automatically navigate to the previous or next screen.  The refresh and navigation can be further controlled 
 * by making this component conditionally visible so the action(s) will only occur when the conditional 
 * visibility is true.
 * 
 * Additional components packaged with this LWC:
 * 
 *                      Lightning Web Components:       ers_AutoNavigate_RefreshCPE //TODO

 * CREATED BY:          Eric Smith
 * 
 * VERSION:             1.0.0
 * 
 * RELEASE NOTES://TODO https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/ers_AutoNavigate_Refresh/README.md
 * 
**/

import { LightningElement, wire, api } from 'lwc';
import { FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import {
    IsConsoleNavigation,
    getFocusedTabInfo,
    refreshTab
} from 'lightning/platformWorkspaceApi';

export default class Ers_AutoNavigate_Refresh extends LightningElement {

    @api 
    get navDirection() {
        return this._navDirection;
    }
    set navDirection(value) {
        if (value.toLowerCase() === "back" || value.toLowerCase() === "previous") {
            this._navDirection =  "back";
        } else {
            this._navDirection =  "next";
        }
    }
    _navDirection = "Next";

    @api skipRefresh = false;

    /* SYSTEM INPUTS */
    @api availableActions = [];

    rendered;

    @wire(IsConsoleNavigation) isConsoleNavigation;

    async refreshTab() {
        if (!this.isConsoleNavigation) {
            return;
        }
        const { tabId } = await getFocusedTabInfo();
        await refreshTab(tabId, {
            includeAllSubtabs: true
        });
    }

    renderedCallback() {

        if (this.rendered) 
            return;
        this.rendered = true;

        // Refresh Console Tab
        if (!this.skipRefresh) {
            this.refreshTab();
        }
        
        // Auto Navigate to Previous or Next Screen
        if (this._navDirection === "back" && this.availableActions.find(action => action === 'BACK')) {
            this.dispatchEvent(new FlowNavigationBackEvent());
        } else {
            if (this.availableActions.find(action => action === 'FINISH')) {
                this.dispatchEvent(new FlowNavigationFinishEvent());
            } else {
                this.dispatchEvent(new FlowNavigationNextEvent());
            }
        }

    }

}