/**
* @description a util class for storing Constants
*/

const reverse = str => str.split('').reverse().join('');    // Reverse all the characters in a string
const baseURL = window.location.hostname;

var myDomain;
var isCommunity = false;

if (baseURL.includes('--c.visualforce.')) {     // Running in Flow Builder
    // Get domain url by replacing the last occurance of '--c' in the current url
    myDomain = 'https://' + reverse(reverse(window.location.hostname.split('.')[0]).replace(reverse('--c'),''));
} else if (baseURL.includes('.lightning.')) {   // Running in Lightning
    myDomain = 'https://' + window.location.hostname.split('.')[0];
} else {                                        // Running in a Community
    myDomain = window.location.href;            // https://<domain>.<instance>.force.com/<site title>/s/
    myDomain = myDomain.split('/s/')[0] + '/s/';    // v3.4.5 Remove everything after the /s/ (non-home pages)
    isCommunity = true;
}

const getConstants = () => {
    return {
        VERSION_NUMBER : '3.5.1',   // Current Source Code Version #
        MAXROWCOUNT : 1000,         // Limit the total number of records to be handled by this component
        ROUNDWIDTH : 5,             // Used to round off the column widths during Config Mode to nearest value
        WIZROWCOUNT : 6,            // Number of records to display in the Column Wizard datatable
        MYDOMAIN : myDomain,        // Used for building links for lookup fields
        ISCOMMUNITY : isCommunity,  // Used for building links for lookup fields
        CB_TRUE : 'CB_TRUE',        // Used with fsc_flowCheckbox component
        CB_FALSE : 'CB_FALSE',      // Used with fsc_flowCheckbox component
        CB_ATTRIB_PREFIX : 'cb_',   // Used with fsc_flowCheckbox component
    }
}

export { getConstants };