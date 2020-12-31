import { LightningElement, api, track } from 'lwc';

export default class SearchableDataTable extends LightningElement {

    @api keyField;
    @api tableData;
    @api columns;
    @api tableStyle;
    @api cssClass;
    @api columnWidthsMode;
    @api defaultSortDirection;
    @api draftValues;
    @api enableInfiniteLoading;
    @api errors;
    @api hideCheckboxColumn;
    @api hideTable;
    @api isLoading;
    @api loadMoreOffset;
    @api maxColumnWidth;
    @api maxRowSelection;
    @api minColumnWidth;
    @api resizeColumnDisabled;
    @api resizeStep;
    @api rowNumberOffset;
    @api selectedRows;
    @api showRowNumberColumn;
    @api sortedBy;
    @api sortedDirection;
    @api suppressBottomBar;
    @api wrapTextMaxLines

    @api searchPlaceholder;
    @track searchText;
    
    @track filteredData;
    @track isGettingIcons;

    get dataForTable() {
        return (this.filteredData && this.filteredData.length > 0) ? this.filteredData : this.tableData;
    }

    connectedCallback() {
        this.isGettingIcons = true;
    }

    renderedCallback() {
        if (this.isGettingIcons) {
            this.isGettingIcons = false;
        }
    }

    onRowSelection(event){
        const rowSelectedEvent = new CustomEvent('rowselection', { detail: event.detail });
        this.dispatchEvent(rowSelectedEvent);
    }

    filterRows(event) {
        let searchText = event.target.value;
        if (searchText && searchText.length > 0) {
            this.filteredData = this.tableData.filter(row => {
                let  concatRow = '';
                this.columns.forEach(column => {
                    concatRow += row[column.fieldName];
                });
                return concatRow.toLowerCase().includes(searchText.toLowerCase());
            });
        }

    }

}