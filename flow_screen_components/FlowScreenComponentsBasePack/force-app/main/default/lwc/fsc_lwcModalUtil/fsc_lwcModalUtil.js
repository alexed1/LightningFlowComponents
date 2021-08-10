const CANCEL = 'cancel';
const CONFIRM = 'confirm';
const STRING = 'string';
const EVENT_PREFIX = 'on';

const getConfirmation = (details, onconfirm, oncancel) => {
    let confirmation = {
        onconfirm: onconfirm,
        oncancel: oncancel
    }
    if (details) {
        if (typeof details === STRING) {
            confirmation.text = details;
        } else {
            confirmation.text = details.text;
            confirmation.confirmButtonLabel = details.confirmButtonLabel;
            confirmation.confirmButtonVariant = details.confirmButtonVariant;
            confirmation.cancelButtonLabel = details.cancelButtonLabel;
            confirmation.header = details.header;
        }
    }
    return confirmation;
}

const handleConfirmationButtonClick = (event, confirmation) => {
    const confirmationResult = event.detail;
    const eventName = EVENT_PREFIX + confirmationResult;
    if (confirmation[eventName]) {
        confirmation[eventName]();
    }
}

// Deprecated
const getModalDetails = (text, confirmButtonLabel, confirmButtonVariant, header, cancelButtonLabel) => {
    return {
        text: text,
        confirmButtonLabel: confirmButtonLabel,
        confirmButtonVariant: confirmButtonVariant,
        header: header,
        cancelButtonLabel: cancelButtonLabel
    }
}

export { getConfirmation, getModalDetails, handleConfirmationButtonClick, CANCEL, CONFIRM }