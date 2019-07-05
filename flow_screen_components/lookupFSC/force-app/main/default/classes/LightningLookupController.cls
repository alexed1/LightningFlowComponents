/* 
Copyright 2017 OpFocus, Inc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.				
*/
public with sharing class LightningLookupController 
{


	// Description	: executes the SOQL query and return records.
	// @param 		: sObjectName - name of SObject 
	// @param 		: valueFieldName - name of field from object to use as the value of the pick list 
	// @param 		: displayedFieldName - name of field from object to display in pick list 
	// @param 		: whereClause - optional where clause to add to the SOQL query 
	// @param		: filteredFieldName - optional field name for filter value
	// @param		: filterValue - filter value for filter field
	@AuraEnabled
	public static LookupRecords getRecords(String sObjectName, String valueFieldName, 
											String displayedFieldName, String otherFields, String whereClause,
                                          	String filteredFieldName, String filterFieldValue)
	{
		try
		{
			system.debug('======> sObjectName = ' + sObjectName + ', valueFieldName = ' + valueFieldName + 
							', displayedFieldName = ' + displayedFieldName + ', whereClause = ' + whereClause + 
                        	', filterField = ' + filteredFieldName + ', filterFieldValue = ' + filterFieldValue);
            
			if(valueFieldName == null || displayedFieldName == null || valueFieldName == '' || displayedFieldName == '')
			{
				return null;
			}
			if(sObjectName != null) sObjectName = String.escapeSingleQuotes(sObjectName); 
			if(valueFieldName != null) valueFieldName = String.escapeSingleQuotes(valueFieldName); 
			if(displayedFieldName != null) displayedFieldName = String.escapeSingleQuotes(displayedFieldName); 
			if(otherFields != null) otherFields = String.escapeSingleQuotes(otherFields); 
			//if(whereClause != null) whereClause = String.escapeSingleQuotes(whereClause); 
			if(filteredFieldName != null) filteredFieldName = String.escapeSingleQuotes(filteredFieldName); 
			if(filterFieldValue != null) filterFieldValue = String.escapeSingleQuotes(filterFieldValue); 
			LookupRecords retVal = new LookupRecords();

			String soql = 'Select ' + valueFieldName + ',' + displayedFieldName;
			soql += otherFields == null || otherFields == '' ? '' : ',' + otherFields ;
			soql += ' FROM ' + sObjectName;
			
            Boolean IsWhere = (whereClause != null && whereClause != '');
            Boolean IsFilter = (filterFieldValue != null && filterFieldValue != '' && filteredFieldName != null && filteredFieldName != '');
            if(IsWhere || IsFilter)
			{
				soql += ' WHERE ';
			}
            if(IsWhere)
            {
                soql += whereClause;
            }
			if(IsWhere && IsFilter)
            {
                soql += ' AND ';
            }
            if (IsFilter)
            {
                soql += filteredFieldName + '=\'' + filterFieldValue + '\'';
            }
            
            soql += ' ORDER BY ' + displayedFieldName + ' Limit 100';
			system.debug('========> soql = ' + soql);
			SObject[] lstRec = Database.query(soql);
			if(lstRec.isEmpty()){
				retVal.add(Schema.getGlobalDescribe().get(sObjectName).newSObject(),'','No records found!');
			}
			for( SObject obj : lstRec)
			{
				retVal.add( obj,
							String.valueOf(obj.get(valueFieldName)), 
							String.valueOf(obj.get(displayedFieldName)));
			}

			return retVal;
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('Exception occured:\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n');
		}
	}

	/**
	 * gets the help text from the field
	 * @param  field [Full Name of the field to describe]
	 * @return       [Help text of given field]
	 */
	@AuraEnabled
	public static String getHelpText(String field){
		try{
			String[] data = field.split('\\.');
			return Schema.getGlobalDescribe().get(data[0]).getDescribe().fields.getMap().get(data[1]).getDescribe().getInlineHelpText();
		}
		catch(Exception ex){
			throw new AuraHandledException('Exception occured:\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n');
		}
	}

	/**
	 * gets the object that the given field is a lookup for
	 * NOTE: does not support polymorphic fields
	 * @param  field [Full Name of the field to describe]
	 * @return       [SObject Name of the lookup reference]
	 */
	@AuraEnabled
	public static String getReference(String field){
		try{
			String[] data = field.split('\\.');
			Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(data[0]).getDescribe().fields.getMap().get(data[1]).getDescribe();
			return f.getReferenceTo()[0].getDescribe().getName();
		}
		catch(Exception ex){
			throw new AuraHandledException('Exception occured:\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n');
		}
	}

	/**
	 * gets the data needed for lookup component based on id provided to the component on init
	 * @param  obj   [SObject API]
	 * @param  objId [Record Id]
	 * @param  label [Search label]
	 * @return       [LookupRecords wrapper]
	 */
	@AuraEnabled
	public static LookupRecords getFieldValue(String obj, String objId, String label){
		try{
			String q = 'Select Id, ' + label + ' from ' + obj + ' where Id = \'' + objId + '\'';
			LookupRecords retVal = new LookupRecords();
			for(SObject so :Database.query(q)){
				retVal.add(so,(String)so.get('Id'),(String)so.get(label));
			}
			return retVal;
		}
		catch(Exception ex){
			throw new AuraHandledException('Exception occured:\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n');
		}
	}

	// Description : Class for return value of getRecords method
	public Class LookupRecords
	{
		@AuraEnabled public List<SObject> lstRecords;
		@AuraEnabled public List<String> lstValue; // list of values corresponding to the display values
		@AuraEnabled public List<String> lstDisplay; // list of display values

		public void add(SObject obj, String value, String display)
		{
			if(lstValue == null)
			{
				lstValue = new List<String>();
			}
			if(lstDisplay == null)
			{
				lstDisplay = new List<String>();
			}
			if(lstRecords == null)
			{
				lstRecords = new List<SObject>();
			}

			lstValue.add(value);	
			lstDisplay.add(display);
			lstRecords.add(obj);
		}
	}

}
