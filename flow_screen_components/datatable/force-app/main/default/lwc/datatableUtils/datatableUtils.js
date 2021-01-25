/**
* @description a util class for storing Constants
*/

const getConstants = () => {
    return {
        VERSION_NUMBER : '3.0.9',   // Current Source Code Version #
        MAXROWCOUNT : 1000,         // Limit the total number of records to be handled by this component
        ROUNDWIDTH : 5,             // Used to round off the column widths during Config Mode to nearest value
    }
}

export { getConstants };