import { api, LightningElement, track } from 'lwc';
import Use_these_values_for from '@salesforce/label/c.Use_these_values_for';

export default class MergeFieldReplacer extends LightningElement {
    @api get mergeFieldList () {
        return this._mergeFieldList;
    }

    set mergeFieldList(value) {
        if(value) {
            this._mergeFieldList = [];
            value.forEach(element => {
                this._mergeFieldList.push({
                    mergeValue : element,
                    replacedValue : ""
                });

            });
        }
    }
    _mergeFieldList = [];
    label = {
        Use_these_values_for
    };

    closeModal() {
        const closeModal = new CustomEvent('closemodal'//, {
        //     detail: {
        //         value: JSON.stringify(this.mergeFieldList),
        //     }
        // }
        );
        this.dispatchEvent(closeModal);
    }

    submitDetails() {
        const closeModal = new CustomEvent('closemodal', {
                detail: {
                    value: this.mergeFieldList,
                }
            }
        );
        this.dispatchEvent(closeModal);
    }

    changeMergeValue(event) {
        this._mergeFieldList.forEach(element => {
            if(element && element.mergeValue === event.target.name) {
                element.replacedValue = event.detail.value;
            }
        });
    }
}