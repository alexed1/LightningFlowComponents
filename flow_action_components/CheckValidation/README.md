/** 
 *  Check Validation Flow Action
 * 
 *  Eric Smith - 4/30/21 - v1.4
 *  Fixed default for Commit record to be False
 * 
 *  Eric Smith - 4/30/21 - v1.3
 *  Fixed the default values for the optional attributes
 * 
 *  Eric Smith - 3/13/21 - v1.2
 *  Added an attribute to allow for the checking of Duplication Rules
 *
 *  Eric Smith - March 2021 - v1.1
 * 
 *  This class temporarily writes a record to an SObject to see if any  
 *  validation errors occurr and passes the errors back to the flow
 * 
 *  If there are multiple types of errors, only one type of error will be returned.
 *  If any Text fields are over their size limit, only those errors will be returned.
 *  If any Validation Rule fails, all Validation Rule failures will be returned.
 *  If any Required Fields are missing, only those errors will be returned.
 *  If any Lookup field values violate the defined Filter, only those errors will be returned.
 *  If specified in the attributes, Duplication Rules will be checked on new records.
 * 
 *  Fields over their size limit are handled first, followed by Validation Rules, followed by Required Fields,
 *  followed by Filter violations, optionally followed by Duplicate Rule checks.
 * 
 * 
**/ 
