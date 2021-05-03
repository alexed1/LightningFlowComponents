import { LightningElement, api, track } from 'lwc';

const ORIENTATION = {
    HORIZONTAL: 'horizontal',
    VERTICAL: 'vertical',
    get LIST() { return [this.HORIZONTAL, this.VERTICAL]; },
    get DEFAULT() { return this.HORIZONTAL; }
}
const ALIGNMENT = {
    RIGHT: 'right',
    LEFT: 'left',
    CENTER: 'center',
    get LIST() { return [this.RIGHT, this.LEFT, this.CENTER] },
    get DEFAULT() { return this.RIGHT; }
}

const CLASS = {
    DEFAULT_BUTTON: 'slds-theme_default',
    HIGHLIGHTED_BUTTON: 'slds-theme_info',
}

function Button(label, value, descriptionText) {

}

export default class FlowButtonBarCPE extends LightningElement {
    @api maxNumButtons = 5;

    @api orientation;
    @api alignment;
    @api groupAsToggle;
    @api includeLine;

    @track buttons = [];
    @track selectedButton = {};
    @track draggedButtonIndex = {};
    dragIsActive;
    modalIsNewButton;

    get activeDropZoneIndex() {
        return this._activeDropZoneIndex;
    }
    set activeDropZoneIndex(dzIndex) {
        this._activeDropZoneIndex = dzIndex;
        for (let dz of this.template.querySelectorAll('.dropzone')) {
            if (dzIndex >= 0 && dz.dataset.index == dzIndex) {
                dz.classList.add('dropzone_active');
            } else {
                dz.classList.remove('dropzone_active');
            }        
        }
    }
    _activeDropZoneIndex;

    accordionSections = ['buttons', 'settings'];

    showModal;
    showConfirmDelete;

    connectedCallback() {
        this.setDefaults();
    }

    setDefaults() {
        this.orientation = this.orientation || ORIENTATION.DEFAULT;
        this.alignment = this.alignment || ALIGNMENT.DEFAULT;
        if (this.buttons.length === 0) {
            this.buttons.push(
                { label: 'Previous', value: 'previous' },
                { label: 'Next', value: 'next' },
                { label: 'Submit', value: 'submit' }
            );
            this.reorderButtons();
            console.log('buttons = ' + JSON.stringify(this.buttons));
        }
    }

    addButton() {
        let newButton = {
            value: 'newButton',
            label: 'New button'
            /*
            _label: 'New button',
            get label() { return this._label; },
            set label(label) { 
                this._label = label;
                if (label && !this.value) {
                    this.value = label;
                }
            }
            */
        }
        this.buttons.push(newButton);
        this.reorderButtons();
    }

    /* GETTERS */
    get isVertical() { return this.orientation === ORIENTATION.VERTICAL; }
    get isHorizontal() { return !this.isVertical; }

    get newButtonDisabled() { return this.buttons.length >= this.maxNumButtons; }

    get orientationOptions() {
        return ORIENTATION.LIST.map(el => {
            return { label: el, value: el }
        });
    }

    get alignmentOptions() {
        return ALIGNMENT.LIST.map(el => {
            return { label: el, value: el }
        });
    }

    /* ACTION FUNCTIONS */
    openModal(isNew) {
        // If selectedButton is not passed in, create a new button
        this.modalIsNewButton = isNew;
        this.showModal = true;
    }

    closeModal() {
        this.selectedButton = {};
        this.showModal = false;
    }

    setValueFromLabel() {
        console.log('in setValueFromLabel');
        let sb = this.selectedButton;
        if (sb.label && !sb.value) {
            sb.value = sb.label
        }
    }

    reorderButtons() {
        for (let i = 0; i < this.buttons.length; i++) {
            this.buttons[i].index = i;
            this.buttons[i].num = (i + 1);
        }
    }

    confirmDelete() {
        this.showConfirmDelete = true;
        console.log('showConfirmDelete', this.showConfirmDelete);
    }

    validateModal() {
        let fields = this.template.querySelectorAll('.slds-modal lightning-input');
        let allValid = true;
        for (let field of fields) {
            //if (!field.reportValidity())
            //allValid = false;
        }
    }

    deleteButton(index) {
        this.buttons.splice(index, 1);
        this.reorderButtons();
    }

    toggleHighlight(el, isOn) {
        //console.log('in toggleHighlight', el.dataset.index, isOn);

        if (isOn) {
            el.classList.add(CLASS.HIGHLIGHTED_BUTTON);
        } else {
            el.classList.remove(CLASS.HIGHLIGHTED_BUTTON);
        }
        if (el.classList.contains('dropzone_final')) {
            el.classList.add('slds-p-around_large');
        }

        //console.log('drag leave', el.dataset.index);
        //el.classList.remove(CLASS.HIGHLIGHTED_BUTTON);

    }

    toggleDropzone(dzIndex, isOn) {
        //let dz = this.template.querySelectorAll('.dropzone').find(el => el.dataset.index == dzIndex);
        //console.log('dz = '+ JSON.stringify(dz), isOn);
        if (isOn) {
            //dz.classList.add('dropzone_active');
        } else {
            //dz.classList.remove('dropzone_active');
        }

        //this.activeDropZoneIndex = dzIndex;

        for (let dz of this.template.querySelectorAll('.dropzone')) {
            if (dzIndex == dz.dataset.index) {
                if (isOn) {
                    //console.log('setting dzIndex '+ dzIndex +' to active');
                    dz.classList.add('dropzone_active');
                } else {
                    //console.log('setting dzIndex '+ dzIndex +' to inactive');
                    dz.classList.remove('dropzone_active');
                }        
            } else {                
                dz.classList.remove('dropzone_active');
            }
        }
    }

    /* EVENT HANDLERS */
    handleModalCancelClick() {
        this.closeModal();
    }

    handleModalSaveClick() {
        let existingButton = this.buttons.find(button => {
            //console.log(JSON.stringify(button), button.index === this.selectedButton.index);
            return button.index === this.selectedButton.index;
        });
        console.log('selectedButton = ' + JSON.stringify(this.selectedButton));
        if (existingButton) {
            console.log('existingButton = ' + JSON.stringify(existingButton));
            this.buttons[existingButton.index] = Object.assign({}, this.selectedButton);
            console.log('new existingButton = ' + JSON.stringify(existingButton));
            let testSearchButton = this.buttons.find(button => {
                //console.log(JSON.stringify(button), button.index === this.selectedButton.index);
                return button.index === this.selectedButton.index;
            });
            console.log('testSearchButton = ' + JSON.stringify(testSearchButton));

        } else {
            this.buttons.push(Object.assign({}, this.selectedButton));
        }
        this.reorderButtons();

        this.closeModal();
    }

    handleButtonOpenClick(event) {
        let index = event.currentTarget.dataset.index;
        this.selectedButton = Object.assign({}, this.buttons[index]);

        console.log('selectedButton = ' + JSON.stringify(this.selectedButton));
        this.openModal();
    }

    handleNewButtonClick() {
        //this.addButton();
        this.openModal(true);
    }

    handleOrientationChange(event) {
        this.orientation = event.detail.value;
    }

    handleButtonDeleteClick(event) {
        //this.confirmDelete(); TODO
        let buttonIndex = event.currentTarget.dataset.index || this.selectedButton.index;
        this.deleteButton(buttonIndex);
        this.closeModal();
    }

    handleButtonDragStart(event) {
        //event.preventDefault();
        console.log('in handleButtonDragStart');
        let index = event.currentTarget.dataset.index;
        event.dataTransfer.setData('text/plain', index);
        console.log('index = ' + index);
    }

    handleButtonMousedown(event) {
        console.log('mousedown');
    }

    handleAlignmentChange(event) {
        this.alignment = event.detail.value;
    }

    handleModalLabelChange(event) {
        this.selectedButton.label = event.detail.value;
        console.log('in label change: ' + JSON.stringify(this.selectedButton));
        //console.log(event.detail.value);
        //this.setValueFromLabel();
    }

    handleModalLabelBlur(event) {
        this.setValueFromLabel();
    }

    handleModalValueChange(event) {
        this.selectedButton.value = event.detail.value;
        console.log('in value change: ' + JSON.stringify(this.selectedButton));
    }

    handleModalDescriptionChange(event) {
        this.selectedButton.descriptionText = event.detail.value;
        console.log('in description change: ' + JSON.stringify(this.selectedButton));
    }

    handleDragOver(event) {
        event.preventDefault();
        //this.toggleHighlight(event.currentTarget, true);
        let rect = event.currentTarget.getBoundingClientRect();
        let y = event.clientY - rect.top;
        let dzIndex = event.currentTarget.dataset.index;
        let dropAbove;
        let topHalf
        if (y / rect.height < 0.5) {
            //this.toggleDropzone(dzIndex, true);

            //dropAbove = true;
            this.activeDropZoneIndex = dzIndex;
        } else {
            //this.toggleDropzone((Number(dzIndex)+1), true);
            //dropAbove = false;
            this.activeDropZoneIndex = (Number(dzIndex) + 1);
        }
        

    }

    handleDragLeave(event) {
        //console.log('drag leave', event.currentTarget.dataset.index);
        //this.toggleDropzone(event.currentTarget.dataset.index, false);
        this.activeDropZoneIndex = null;

        /*
        let currentIndex = this.activeDropZoneIndex;
        setTimeout(() => {
            if (this.activeDropZoneIndex == curren)
            this.activeDropZoneIndex = null;
            let sendButton = this.template.querySelector('[data-id="sendButtonForSignIn"]');
            sendButton.focus();
        }, 200);
        */
    }

    handleDrop(event) {
        event.preventDefault();
        console.log('in handleDrop');
        let draggedIndex = event.dataTransfer.getData('text/plain');
        console.log('draggedIndex = ' + draggedIndex);
        let draggedButton = this.buttons.splice(draggedIndex, 1);
        if (!draggedButton.length) {
            console.log('somethings weird, what? error');
        } else {
            this.buttons.splice(event.currentTarget.dataset.index, 0, draggedButton[0]);
        }
        this.reorderButtons();
        this.toggleHighlight(event.currentTarget, false);
        event.currentTarget.classList.remove('insertBelow');
        event.currentTarget.classList.remove('insertAbove');
    }

    handleDropzoneDragOver(event) {
        event.preventDefault();
        this.activeDropZoneIndex = event.currentTarget.dataset.index;
    }

    handleDropzoneDragLeave(event) {
        this.activeDropZoneIndex = null;
    }

    handleDropzoneDrop(event) {
        console.log('in handleDropzoneDrop');
        console.log(event.dataTransfer.getData('text/plain'));
    }

    handleContainerDrop(event) {
        event.preventDefault();
        let originIndex = event.dataTransfer.getData('text/plain');
        if (originIndex || originIndex == 0) {

        }
        console.log('in handleContainerDrop: moving '+ originIndex +' into dropzone #'+ this.activeDropZoneIndex);

        let draggedButton = this.buttons.splice(originIndex, 1);
        if (!draggedButton.length) {
            console.log('somethings weird, what? error');
        } else {
            this.buttons.splice(this.activeDropZoneIndex, 0, draggedButton[0]);
        }
        this.activeDropZoneIndex = null;
        this.reorderButtons();        
    }

    /* UTILITY FUNCTIONS */
    equalsArray(a, b) {
        return a.length === b.length && a.every((v, i) => v === b[i]);      
    }
}