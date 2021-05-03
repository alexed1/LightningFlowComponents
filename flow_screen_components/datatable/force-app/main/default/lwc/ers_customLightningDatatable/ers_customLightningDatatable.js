import LightningDatatable from "lightning/datatable";
import ers_richTextColumnType from "./ers_richTextColumnType.html";
import ers_comboboxColumnType from "./ers_comboboxColumnType.html";
import stylesheet from '@salesforce/resourceUrl/ers_customLightningDatatableStyles';
import {loadStyle} from "lightning/platformResourceLoader";

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
            console.log("Loaded style sheet");
        }).catch(error => {
            console.error('Error loading stylesheet', error);
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
            standardCellLayout: true,
            typeAttributes: ['editable', 'fieldName', 'keyField', 'keyFieldValue', 'picklistValues']
        }
    }
}
