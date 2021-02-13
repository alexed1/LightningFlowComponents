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
    isCommunity = true;
}

const getConstants = () => {
    return {
        VERSION_NUMBER : '3.0.10',  // Current Source Code Version #
        MAXROWCOUNT : 1000,         // Limit the total number of records to be handled by this component
        ROUNDWIDTH : 5,             // Used to round off the column widths during Config Mode to nearest value
        MYDOMAIN : myDomain,        // Used for building links for lookup fields
        ISCOMMUNITY : isCommunity,  // Used for building links for lookup fields
    }
}

export { getConstants };