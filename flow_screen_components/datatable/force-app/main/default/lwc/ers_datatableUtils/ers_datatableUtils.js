/**
* @description a util class for storing Constants & Functions
*/

const reverse = str => str.split('').reverse().join('');    // Reverse all the characters in a string
const baseURL = window.location.hostname || 'LWR';          // LWR Experience does not support window.xxx
console.log("DATATABLE: environment baseURL", baseURL);

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
    if (baseURL.includes('.develop.')) {        // Running in a developer org - v4.3.3
        myDomain += '.develop';
    }
    if (baseURL.includes('.trailblaze.')) {     // Running in a playground org - v4.3.5
        myDomain += '.trailblaze';
    }
} else {                                        // Running in a Community or Flow Builder
    myDomain = window.location.href;            // https://<domain>.<instance>.force.com/<site title>/s/
    myDomain = myDomain.split('/s/')[0] + '/s/';    // v3.4.5 Remove everything after the /s/ (non-home pages)
    isCommunity = true;
}
if (myDomain.includes('flow/runtime') || myDomain.includes('/flow/')) {     // Running in Flow Builder || Flow Builder (Enhanced Domain)
    myDomain = baseURL;
    isCommunity = false;
    isFlowBuilder = true;
}
console.log("DATATABLE: myDomain:", myDomain);
console.log("DATATABLE: isCommunity, isFlowBuilder:", isCommunity, isFlowBuilder);

const getConstants = () => {
    return {
        VERSION_NUMBER : '4.3.6',           // Current Source Code Version #
        MAXROWCOUNT : 2000,                 // Limit the total number of records to be handled by this component
        ROUNDWIDTH : 5,                     // Used to round off the column widths during Config Mode to nearest value
        WIZROWCOUNT : 6,                    // Number of records to display in the Column Wizard datatable
        MYDOMAIN : myDomain,                // Used for building links for lookup fields
        ISCOMMUNITY : isCommunity,          // Used for building links for lookup fields
        ISFLOWBUILDER : isFlowBuilder,      // Used for building links for lookup fields
        CB_TRUE : 'CB_TRUE',                // Used with fsc_flowCheckbox component
        CB_FALSE : 'CB_FALSE',              // Used with fsc_flowCheckbox component
        CB_ATTRIB_PREFIX : 'cb_',           // Used with fsc_flowCheckbox component
        MIN_SEARCH_TERM_SIZE : 1,           // Set the minimum number of characters required to start searching
        SEARCH_WAIT_TIME : 300,             // Set the delay to start searching while user is typing a search term
        RECORDS_PER_PAGE : 10,              // Default number of records per page for pagination
        DEFAULT_ACTION : 'Remove Row',      // Default Row Action Type
        DEFAULT_DISPLAY_TYPE : 'Icon',      // Default Row Action Display Type
        PERFORM_ACTION_LABEL: 'Perform Action', // Default label for the Perform Action button
        REMOVE_ROW_LABEL : 'Remove Row',    // Default label for the Remove Row button
        RUN_FLOW_LABEL : 'Run Flow',        // Default label for the Run Flow button
        DEFAULT_ICON : 'utility:close',     // Default Icon for the Row Action button-icon
        PERFORM_ACTION_ICON : 'utility:touch_action',  // Default Icon for the Perform Row Action button-icon
        REMOVE_ROW_ICON : 'utility:close',  // Default Icon for the Remove Row button-icon
        RUN_FLOW_ICON : 'utility:flow',     // Default Icon for the Run Flow Action button-icon
        DEFAULT_COLOR : 'remove-icon',      // Default Color for the Row Action button-icon color
        PERFORM_ACTION_COLOR : '',          // Default Color for the Perform Row Action button-icon color
        REMOVE_ROW_COLOR : 'remove-icon',   // Default Color for the Remove Row button-icon color
        RUN_FLOW_COLOR : 'remove-icon-green',   // Default Color for the Run Flow Action button-icon color
        ACTION_BUTTON_SIDE : 'Right',       // Default Side for the Row Action button
        DEBUG_INFO_PREFIX : 'DATATABLE: ',  // Prefix to be used for debug info in the console
        SHOW_DEBUG_INFO : false,            // Set to true to show sensitive debug info in the console and debug logs
        DEFAULT_COL_WIDTH : 200,            // Default width to set a column when Flex is toggled off
        MIN_COLUMN_WIDTH : 80,              // Minimum width allowed for a column, system default is 80px
        MAX_COLUMN_WIDTH : 1500,            // Maximum width allowed for a column, system default is 1000px
        FILTER_BLANKS : '_FILTER_BLANKS_'   // Dummy filter value to use when filtering on blank values
    }
}

const columnValue = (attrib) => {
    // Extract the value from the column attribute
    return attrib.slice(attrib.search(':')+1);
};

const removeSpaces = (string) => {
    return string
        .replace(/, | ,/g,',')
        .replace(/: | :/g,':')
        .replace(/{ | {/g,'{')
        .replace(/} | }/g,'}')
        .replace(/; | ;/g,';');
}

const convertFormat = (colType) => {
    // Set Input Formatter value for different number types
    switch(colType) {
        case 'currency':
            return 'currency';
        case 'percent':
            // return 'percent-fixed';  // This would be to enter 35 to get 35% (0.35)
            return 'percent';
        default:
            return null;
    }
}

const convertType = (colType) => {
    // Set Input Type based on column Data Type
    switch(colType) {
        case 'boolean':
            return 'text';
        case 'date':
            return 'date';
        case 'date-local':
            return 'date';
        case 'datetime':
            return 'datetime';
        case 'time':
            return 'time';
        case 'email':
            return 'email';
        case 'phone':
            return 'tel';
        case 'url':
            return 'url';
        case 'number':
            return 'number';
        case 'currency':
            return 'number';
        case 'percent':
            return 'number';
        case 'number':
            return 'number';                
        case 'text':
            return 'text';
        default:
            return 'richtext';
    }
}

const convertTime = (that, dtValue) => {
    // Return a Salesforce formatted time value based a datetime value
    const dtv = new Date(dtValue);
    const hours = dtv.getHours() - (that.timezoneOffset / 2880000);
    let timeString = ("00"+hours).slice(-2)+":";
    timeString += ("00"+dtv.getMinutes()).slice(-2)+":";
    timeString += ("00"+dtv.getSeconds()).slice(-2)+".";
    timeString += ("000"+dtv.getMilliseconds()).slice(-3);
    timeString += "Z";
    return timeString;
}

const removeRowFromCollection = (that, collection, keyValue) => {
    const index = findRowIndexById(that, collection, keyValue);
    let result = collection;
    if (index !== -1) {
        result = collection.slice(0, index).concat(collection.slice(index+1));
    }
    return result;
}

const replaceRowInCollection = (that, original, updated, keyValue) => {
    // Replace the matching row in the original collection with the matching row from the updated collection
    const oindex = findRowIndexById(that, original, keyValue);
    const uindex = findRowIndexById(that, updated, keyValue);
    let result = original;
    if (oindex !== -1 && uindex !== -1) {
        result = original.slice(0, oindex).concat(updated.slice(uindex,uindex+1)).concat(original.slice(oindex+1));
    }
    return result;
}

const findRowIndexById = (that, collection, id) => {
    let idx = -1;
    collection.some((row, index) => {
        if (row[that.keyField] === id) {
            idx = index;
            return true;
        }
        return false;
    });
    return idx;
}

export { getConstants, columnValue, removeSpaces, convertFormat, convertType, convertTime, removeRowFromCollection, replaceRowInCollection, findRowIndexById };