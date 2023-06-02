/**
* @description a util class for storing Constants
*/

const reverse = str => str.split('').reverse().join('');    // Reverse all the characters in a string
const baseURL = window.location.hostname || 'LWR';          // LWR Experience does not support window.xxx
console.log("DATATABLE environment baseURL", baseURL);

var myDomain;
var isCommunity = false;
var isFlowBuilder = false;

if (baseURL.includes('--c.visualforce.') || baseURL.includes('--c.vf.')) {     // Running in Flow Builder || Flow Builder (Enhanced Domain)
    // Get domain url by replacing the last occurance of '--c' in the current url
    myDomain = 'https://' + reverse(reverse(window.location.hostname.split('.')[0]).replace(reverse('--c'),''));
} else if (baseURL.includes('.lightning.')) {   // Running in Lightning
    myDomain = 'https://' + window.location.hostname.split('.')[0];
    if (baseURL.includes('.sandbox.')) {        // Running in a sandbox with Enhanced Domain enabled
        myDomain += '.sandbox';
    }
} else {                                        // Running in a Community or Flow Builder
    myDomain = window.location.href;            // https://<domain>.<instance>.force.com/<site title>/s/
    myDomain = myDomain.split('/s/')[0] + '/s/';    // v3.4.5 Remove everything after the /s/ (non-home pages)
    isCommunity = true;
}
if (myDomain.includes('flow/runtime')) {     // Running in Flow Builder || Flow Builder (Enhanced Domain)
    myDomain = baseURL;
    isCommunity = false;
    isFlowBuilder = true;
}

const getConstants = () => {
    return {
        VERSION_NUMBER : '4.1.1',       // Current Source Code Version #
        MAXROWCOUNT : 2000,             // Limit the total number of records to be handled by this component
        ROUNDWIDTH : 5,                 // Used to round off the column widths during Config Mode to nearest value
        WIZROWCOUNT : 6,                // Number of records to display in the Column Wizard datatable
        MYDOMAIN : myDomain,            // Used for building links for lookup fields
        ISCOMMUNITY : isCommunity,      // Used for building links for lookup fields
        ISFLOWBUILDER : isFlowBuilder,  // Used for building links for lookup fields
        CB_TRUE : 'CB_TRUE',            // Used with fsc_flowCheckbox component
        CB_FALSE : 'CB_FALSE',          // Used with fsc_flowCheckbox component
        CB_ATTRIB_PREFIX : 'cb_',       // Used with fsc_flowCheckbox component
        MIN_SEARCH_TERM_SIZE : 2,       // Set the minimum number of characters required to start searching
        SEARCH_WAIT_TIME : 300,         // Set the delay to start searching while user is typing a search term
    }
}

export { getConstants };