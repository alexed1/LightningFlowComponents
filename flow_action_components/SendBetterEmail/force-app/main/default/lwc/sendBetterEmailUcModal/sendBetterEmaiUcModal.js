import {LightningElement, track, api} from 'lwc';

export default class ucModal extends LightningElement {

    @api name;
    @api showFooter = false;
    @api width;
    @api height;
    @api availableReactions;
    @api params;

    @track showModal = false;

    @api openModal() {
        this.showModal = true;
    }

    get containerStyle() {
        let style = '';
        if (this.width) {
            style += 'width: ' + this.width + '; max-width: ' + this.width
        }else{
            style='max-width: 90%';
        }
        return style;
    }

    get bodyStyle() {
        let style = '';
        if (this.height) {
            style += 'height: ' + this.height;
        }
        return style;
    }

    handleReactionButtonClick(event) {
        let reactionValue = event.currentTarget.dataset.value;
        if (reactionValue) {
            this.dispatchReactionEvent(reactionValue);
        }
        this.closeModal();
    }

    dispatchReactionEvent(reaction) {
        const memberRefreshedEvt = new CustomEvent('reaction', {
            bubbles: true,
            detail: {
                name: this.name,
                value: reaction,
                params: this.params
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    @api
    closeModal(event) {
        this.showModal = false;
    }

}