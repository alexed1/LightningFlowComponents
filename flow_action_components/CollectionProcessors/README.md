# Collection Processors


See https://unofficialsf.com/list-actions-for-flow/


## Extract Strings from Collection

### Features
- Extract a text collection or comma-separated string of any field for each record in a Record Collection
    - Particularly useful for Ids, Picklists, Multi-select picklists
- Optionally de-dupe the values returned from all of the records. 
    - Supports Multi-select picklists across all records in the collection 
- Useful when paired with the new AddQuotesToFields and ExecuteSOQL actions to pass in a set of strings wrapped in quotes
- Ex. `Select Name, Email from Contact where Id in (‘003023044333sDl’, ‘003023044333sKF’)`
  
### Version 2 Updates
- Parameterizes dedupeValues functionality (defaults to true)
- Supports extracting + deduping of multi-select picklist fields
- Adds flow documentation
- Supports bulkification
- Adds exception handling to make action more robust
- Adds further unit testing
- Returns a CSV string of fields in addition to the collection for easier processing in Flow
  
### Inputs
-	inputRecordCollection
    - List of records to extract field values from
-	fieldAPIName;
    - API Name of the field you want returned
-	dedupeValues;
    - If true only unique values will be returned. The default value is true
  
### Outputs
-	fieldValueCollection
    - Extracted fields in a text collection
-	fieldValueString;
    - Extracted fields in a comma-separated text variable
