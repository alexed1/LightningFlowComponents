import LightningDatatable from "lightning/datatable";
import ers_richTextColumnType from "./ers_richTextColumnType.html";
import ers_comboboxColumnType from "./ers_comboboxColumnType.html";
import stylesheet from '@salesforce/resourceUrl/ers_customLightningDatatableStyles';
import {loadStyle} from "lightning/platformResourceLoader";
import { getConstants } from 'c/ers_datatableUtils';

const CONSTANTS = getConstants();   // From ers_datatableUtils : SHOW_DEBUG_INFO, DEBUG_INFO_PREFIX

const SHOW_DEBUG_INFO = CONSTANTS.SHOW_DEBUG_INFO;
const DEBUG_INFO_PREFIX = CONSTANTS.DEBUG_INFO_PREFIX;

/**
 * Custom component that extends LightningDatatable
 * and adds a new column type
 */
export default class ers_customLightningDatatable extends LightningDatatable {
    constructor() {
        super();
        //load style sheets to bypass shadow dom
        Promise.all([
            loadStyle(this, stylesheet)
        ]).then(() => {
            console.log(DEBUG_INFO_PREFIX+"Loaded style sheet");
        }).catch(error => {
            console.error(DEBUG_INFO_PREFIX+'Error loading stylesheet', error);
        });
    }

    static customTypes={
        // custom type definition
        richtext: {
            template: ers_richTextColumnType,
            standardCellLayout: true
        },
        combobox: {
            template: ers_comboboxColumnType,
            standardCellLayout: false,
            typeAttributes: ['editable', 'fieldName', 'keyField', 'keyFieldValue', 'picklistValues', 'alignment']
        }
    }
}
