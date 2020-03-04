import {ShowToastEvent} from "lightning/platformShowToastEvent";

export {
    flashElement,
    buildOptions,
    getErrorMessage,
    showToast,
    copyValue,
    iconsPerType
};

const iconsPerType = {
    String: 'utility:text',
    Boolean: 'utility:check',
    Date: 'utility:date_input',
    DateTime: 'utility:date_time',
    Number: 'utility:number_input',
    Int: 'utility:number_input',
    Double: 'utility:number_input',
    Picklist: 'utility:picklist',
    TextArea: 'utility:textarea',
    Phone: 'utility:phone_portrait',
    Address: 'utility:location',
    Currency: 'utility:currency_input',
    Url: 'utility:link',
    SObject: 'utility:sobject'
};

const buildOptions = (dataFields) => {
    let tempOptions = [];
    let localKey = 0;
    Object.keys(dataFields).forEach(curField => {
        let curFieldData = dataFields[curField];
        let curDataType = curFieldData.dataType === 'Reference' ? 'SObject' : curFieldData.dataType;
        let curObjectType = curFieldData.referenceToInfos.length ? curFieldData.referenceToInfos[0].apiName : null;
        tempOptions.push({
            type: curDataType,
            label: (curFieldData.label ? curFieldData.label : curFieldData.apiName),
            value: curFieldData.apiName,
            isCollection: false,
            objectType: curObjectType,
            optionIcon: iconsPerType[curDataType],
            isObject: curDataType === 'SObject' && curFieldData.relationshipName,
            relationshipName: curFieldData.relationshipName,
            displayType: curDataType === 'SObject' ? curObjectType : curDataType,
            key: 'fieldDescriptor' + localKey++
        });
    });
    return tempOptions;
};


const flashElement = (that, selector, styleClass, numberOfIterations, interval) => {
    if (selector) {
        let selectedFields = that.template.querySelectorAll(selector);
        if (selectedFields && selectedFields.length) {
            selectedFields.forEach(curField => {
                let counter = 0;
                const intervalId = setInterval(() => {
                    counter += 1;
                    curField.classList.toggle(styleClass);
                    if (counter === numberOfIterations * 2) {
                        clearInterval(intervalId);
                    }
                }, interval);
            });
        } else {
            setTimeout(() => {
                flashElement(that, selector, styleClass, numberOfIterations, interval);
            }, interval);
        }
    }
};

const getErrorMessage = (errorObject) => {

    if (errorObject.body) {
        let resultMessage = '';
        if (Array.isArray(errorObject.body)) {
            errorObject.body.forEach(curBody => {
                resultMessage += (curBody.message + '; ');
            });
        } else {
            resultMessage += errorObject.body.message;
        }
        return resultMessage;
    } else {
        return JSON.stringify(errorObject);
    }
};

const showToast = (title, message, variant) => {
    const showToast = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    dispatchEvent(showToast);
};

const copyValue = (value) => {
    if (value) {
        return JSON.parse(JSON.stringify(value));
    } else {
        return value;
    }
};