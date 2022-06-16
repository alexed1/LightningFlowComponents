const FIELD_TYPES = {
    REFERENCE: { label: 'Lookup/Master-Detail', value: 'Reference', icon: 'utility:record_lookup' },
    ADDRESS: { label: 'Address', value: 'Address', icon: 'utility:location' },
    CHECKBOX: { label: 'Checkbox', value: 'Boolean', icon: 'utility:check' },
    CURRENCY: { label: 'Currency', value: 'Currency', icon: 'utility:currency' },
    DATE: { label: 'Date', value: 'Date', icon: 'utility:date_input' },
    DATETIME: { label: 'Date/Time', value: 'DateTime', icon: 'utility:date_time' },
    EMAIL: { label: 'Email', value: 'Email', icon: 'utility:email' },
    LOCATION: { label: 'Geolocation', value: 'Location', icon: 'utility:location' },
    NUMBER: { label: 'Number', value: 'Integer;Double;Int;Long', icon: 'utility:number_input' },
    PERCENT: { label: 'Percent', value: 'Percent', icon: 'utility:percent' },
    PHONE: { label: 'Phone Number', value: 'Phone', icon: 'utility:phone_portrait' },
    PICKLIST: { label: 'Picklist', value: 'Picklist;ComboBox', icon: 'utility:picklist_type' },
    MULTIPICKLIST: { label: 'Picklist (Multi-Select)', value: 'MultiPicklist', icon: 'utility:multi_picklist' },
    TEXT: { label: 'Text', value: 'String', icon: 'utility:text' },
    TEXTAREA: { label: 'Text Area', value: 'TextArea', icon: 'utility:textbox' },
    TEXTENCRYPTED: { label: 'Text (Encrypted)', value: 'EncryptedString', icon: 'utility:hide' },
    TIME: { label: 'Time', value: 'Time', icon: 'utility:clock' },
    URL: { label: 'URL', value: 'URL', icon: 'utility:link' },
};

const DISPLAY_TYPE_OPTIONS = {
    OBJECT: { label: 'Just Object(s)', value: 'object' },
    FIELD: { label: 'Just Field(s)', value: 'field' },
    BOTH: { label: 'Both', value: 'both', default: true }
}

const AVAILABLE_OBJECT_OPTIONS = {
    BOTH: { label: 'Custom and Standard Objects', value: 'both', subcategories: ['standard', 'custom'], default: true },
    STANDARD: { label: 'Standard Objects Only', value: 'standard' },
    CUSTOM: { label: 'Custom Objects Only', value: 'custom' },
    ALL:  { label: 'ALL Objects (advanced)', value: 'all', subcategories: ['standard', 'custom', 'ancillary'] },
    ANCILLARY:  { label: 'Ancillary Objects Only', value: 'ancillary', hide: true },
    SPECIFIC:  { label: 'Select Specific Objects', value: 'specific' }    
}

const LAYOUT_OPTIONS = {
    VERTICAL: { label: 'Vertical', value: 'vertical', default: true},
    HORIZONTAL: { label: 'Horizontal', value: 'horizontal' },
}

const transformConstantObject = (constant) => {
    return {
        list: constant,
        get options() { return Object.values(this.list).filter(option => !option.hide); },
        get default() { return this.options.find(option => option.default); },
        findFromValue: function (value) {
            let entry = this.options.find(option => option.value == value);
            return entry || this.default;
        },
        findFromLabel: function (label) {
            let entry = this.options.find(option => option.label == label);
            return entry || this.default;
        }
    }
}

const includesIgnoreCase = (arrayToSearch, term) => {
    return arrayToSearch.map(arrayValue => arrayValue.toLowerCase()).includes(term.toLowerCase());
}

export { FIELD_TYPES, DISPLAY_TYPE_OPTIONS, AVAILABLE_OBJECT_OPTIONS, LAYOUT_OPTIONS, transformConstantObject, includesIgnoreCase }