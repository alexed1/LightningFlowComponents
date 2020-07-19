export {
    generateCapabilityColumns,
    splitValues
};

const generateCapabilityColumns = (labels) => {
    let labelsArray = labels.replace(/ /g, '').split(',');
    return labelsArray.map(curLabel => {
        return getColumnDescriptor(curLabel);
    });
};

const getColumnDescriptor = (curButtonLabel) => {
    return {
        type: 'button',
        label: curButtonLabel,
        typeAttributes: {
            label: curButtonLabel,
            name: curButtonLabel, //this is used to determine an apex method to call
            variant: 'neutral',
            disabled: {fieldName: curButtonLabel.replace(/ /g, '') + 'buttonDisabled'}
        },
        initialWidth: 120 //TODO: Calculate based on content
    }
};

const splitValues = (originalString) => {
    if (originalString) {
        return originalString.replace(/ /g, '').split(',');
    } else {
        return [];
    }
};


