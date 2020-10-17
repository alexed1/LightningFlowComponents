import LightningDatatable from "lightning/datatable";
import richTextColumnType from "./richTextColumnType.html";

/**
 * Custom component that extends LightningDatatable
 * and adds a new column type
 */
export default class richDatatable extends LightningDatatable {
    static customTypes={
        // custom type definition
        richtext: {
            template: richTextColumnType,
            standardCellLayout: true
        }
    }
}