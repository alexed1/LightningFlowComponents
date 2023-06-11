const KEYS = {
    ESCAPE: 'Escape',
    UP: 'ArrowUp',
    DOWN: 'ArrowDown',
    ENTER: 'Enter'
}

const setValuesFromMultipleInput = (values) => {
    if (!values) {
        return [];
    } else {
        return Array.isArray(values) ? [...values] : [values];
    }
}

const setValuesFromSingularInput = (value, delimiter, isMultiSelect) => {
    if (!value) {
        return [];
    } else {
        return isMultiSelect ? value.split(delimiter).map(val => val.trim()) : [value];
    }
}

const includesIgnoreCase = (valueToSearch, valueToSearchFor) => {
    if (Array.isArray(valueToSearch)) {
        return valueToSearch.map(arrayValue => arrayValue.toLowerCase()).includes(valueToSearchFor.toLowerCase());
    } else {
        return valueToSearch.toLowerCase().includes(valueToSearchFor.toLowerCase());
    }
    
}

export { KEYS, setValuesFromMultipleInput, setValuesFromSingularInput, includesIgnoreCase }