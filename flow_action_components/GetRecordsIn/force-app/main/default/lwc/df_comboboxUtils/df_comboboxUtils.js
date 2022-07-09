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

// const setValuesFromMultipleInput = (values) => {
//     console.log('in setValuesFromMultipleInput');
//     if (!values) {
//         return [];
//     } else {
//         console.log('values is array? '+ Array.isArray(values));
//         let returnValues = Array.isArray(values) ? [...values] : [values];
//         console.log(returnValues);
//         return returnValues;
//     }
// }
// const setValuesFromSingularInput = (value, delimiter, isMultiSelect) => {
//     console.log('in setValuesFromSingularInput');
//     if (!value) {
//         return [];
//     } else {
//         console.log('isMultiSelect = '+ isMultiSelect);
//         let returnValue = isMultiSelect ? value.split(delimiter).map(val => val.trim()) : [value];
//         console.log(returnValue);
//         return returnValue;
//     }
// }

export { KEYS, setValuesFromMultipleInput, setValuesFromSingularInput }