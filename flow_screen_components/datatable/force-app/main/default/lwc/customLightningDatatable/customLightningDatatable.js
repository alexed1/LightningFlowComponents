import LightningDatatable from "lightning/datatable";
import richTextColumnType from "./richTextColumnType.html";
import comboboxColumnType from "./comboboxColumnType.html";
import stylesheet from '@salesforce/resourceUrl/customLightningDatatableStyles';
import {loadStyle} from "lightning/platformResourceLoader";

/**
 * Custom component that extends LightningDatatable
 * and adds a new column type
 */
export default class customLightningDatatable extends LightningDatatable {
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
            template: richTextColumnType,
            standardCellLayout: true
        },
        combobox: {
            template: comboboxColumnType,
            standardCellLayout: true,
            typeAttributes: ['editable', 'fieldName', 'keyField', 'keyFieldValue', 'picklistValues']
        }
    }
}
