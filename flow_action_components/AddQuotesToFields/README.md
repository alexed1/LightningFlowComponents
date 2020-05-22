## AddQuotesToFields
This invocable Flow action lets you encapsulate or wrap single or double quotes around any Text Collection variable or Text variable that is comma-separated
This can be useful for JSON paylouts or more importantly to feed values into the ExecuteSOQL action.
This pairs exceptionally well with the ‘ExtractStringsFromCollection’ action.
The most common use case for this will be running ‘ExtractStringsFromCollection’ on a record collection to get a comma-separated string of IDs, then running this action to feed into ExecuteSOQL.

Example: 0012030203aFs,00135353dascCS becomes `‘0012030203aFs,’00135353dascCS’`
In SOQL: `Select Name,Type from Account where Id in (‘0012030203aFs,’00135353dascCS’)`

### Inputs
fieldCollection
-	Text collection of values
fieldString
-	Comma separated string of values to transform
quoteType
-	Takes a value of SINGLE or DOUBLE. If left blank, defaults to SINGLE

### Outputs
fieldCollection
-	The returned text collection with quotes around each value
fieldString
-	The returned text string with quotes around each value
-	
