import {ShowToastEvent} from "lightning/platformShowToastEvent";

export {
    flashElement,
    buildOptions,
    getErrorMessage,
    showToast,
    copyValue,
    iconsPerType,
    standardObjectOptions
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
            isSObject: curDataType === 'SObject' && curFieldData.relationshipName,
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

const standardObjectOptions = [
    {value: "Account", label: "Account"},
    {value: "AccountPartner", label: "Account Partner"},
    {value: "Asset", label: "Asset"},
    {value: "AssetRelationship", label: "Asset Relationship"},
    {value: "AssignedResource", label: "Assigned Resource"},
    {value: "Campaign", label: "Campaign"},
    {value: "CampaignMember", label: "Campaign Member"},
    {value: "Case", label: "Case"},
    {value: "Contact", label: "Contact"},
    {value: "ContactRequest", label: "Contact Request"},
    {value: "ContentDocument", label: "File"},
    {value: "ContentVersion", label: "File"},
    {value: "ContentWorkspace", label: "Library"},
    {value: "Contract", label: "Contract"},
    {value: "ContractContactRole", label: "Contract Contact Role"},
    {value: "Image", label: "Image"},
    {value: "Individual", label: "Individual"},
    {value: "Lead", label: "Lead"},
    {value: "MaintenanceAsset", label: "Maintenance Asset"},
    {value: "MaintenancePlan", label: "Maintenance Plan"},
    {value: "Note", label: "Note"},
    {value: "OperatingHours", label: "Operating Hours"},
    {value: "Opportunity", label: "Opportunity"},
    {value: "OpportunityLineItem", label: "Opportunity Product"},
    {value: "OpportunityPartner", label: "Opportunity Partner"},
    {value: "Order", label: "Order"},
    {value: "OrderItem", label: "Order Product"},
    {value: "Partner", label: "Partner"},
    {value: "Pricebook2", label: "Price Book"},
    {value: "PricebookEntry", label: "Price Book Entry"},
    {value: "Product2", label: "Product"},
    {value: "RecordType", label: "Record Type"},
    {value: "ResourceAbsence", label: "Resource Absence"},
    {value: "ResourcePreference", label: "Resource Preference"},
    {value: "ReturnOrder", label: "Return Order"},
    {value: "ReturnOrderLineItem", label: "Return Order Line Item"},
    {value: "ServiceAppointment", label: "Service Appointment"},
    {value: "ServiceCrew", label: "Service Crew"},
    {value: "ServiceCrewMember", label: "Service Crew Member"},
    {value: "ServiceResource", label: "Service Resource"},
    {value: "ServiceResourceCapacity", label: "Resource Capacity"},
    {value: "ServiceResourceSkill", label: "Service Resource Skill"},
    {value: "ServiceTerritory", label: "Service Territory"},
    {value: "ServiceTerritoryLocation", label: "Service Territory Location"},
    {value: "ServiceTerritoryMember", label: "Service Territory Member"},
    {value: "Shift", label: "Shift"},
    {value: "Shipment", label: "Shipment"},
    {value: "SkillRequirement", label: "Skill Requirement"},
    {value: "TimeSheet", label: "Time Sheet"},
    {value: "TimeSheetEntry", label: "Time Sheet Entry"},
    {value: "TimeSlot", label: "Time Slot"},
    {value: "User", label: "User"},
    {value: "WorkOrder", label: "Work Order"},
    {value: "WorkOrderLineItem", label: "Work Order Line Item"},
    {value: "WorkType", label: "Work Type"}
];