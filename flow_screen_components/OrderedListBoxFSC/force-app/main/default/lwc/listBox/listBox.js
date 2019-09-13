import {LightningElement, track, api} from 'lwc';

export default class listBox extends LightningElement {
    @track label = 'Select Options';
    @api values = [];
    @api selectedRecords = [];


    get records() {
        if (this.values) {
            return this.values.map(curRec => {
                return {...curRec, ...{selected: this.selectedRecords.find(curSel => curSel == curRec.value) !== undefined}};
            });
        } else {
            return [];
        }
    }

    setSelected(event) {
        let selectedRecords = this.selectedRecords;
        if (event.ctrlKey) {
            selectedRecords.push(event.currentTarget.dataset.recordid);
        } else {
            selectedRecords = [event.currentTarget.dataset.recordid];
        }
        this.dispatchDataRefreshEvent({
            selectedRecords: selectedRecords
        });
    }

    dispatchDataRefreshEvent(detail) {
        const dataRefreshEvent = new CustomEvent('datarefresh', {
            bubbles: true, detail: detail
        });
        this.dispatchEvent(dataRefreshEvent);
    }

    moveUp() {
        this.moveIndex(-1);

    }

    moveDown() {
        this.moveIndex(1);
    }

    moveIndex(shift) {
        let finalValues;
        this.values.forEach(curRec => {
            if (this.selectedRecords.find(curSel => curSel == curRec.value) !== undefined) {
                let originalIndex = this.values.findIndex(curItem => curItem.value === curRec.value);
                let newIndex = originalIndex + shift;
                if (newIndex >= 0 && newIndex < this.values.length) {
                    finalValues = this.move(originalIndex, newIndex, ...this.values);
                }
            }
        });
        this.dispatchDataRefreshEvent({values: finalValues});
    }

    move(from, to, ...a) {
        from === to ? a : (a.splice(to, 0, ...a.splice(from, 1)), a);
        return a;
    }
}