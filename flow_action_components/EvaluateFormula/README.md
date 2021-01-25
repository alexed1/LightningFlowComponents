# Formula Evaluator

# See https://unofficialsf.com/formula-builder-expression-builder-and-formula-engine/

Processes Salesforce-style formula strings and returns the result.

This is wrapped around the formula engine written by Enreeco’s rich apex formula parser. (https://blog.enree.co/2015/08/salesforce-apex-formula-help-me-testing.html)  We took his engine and added the ability to include mergefields in formulas, and pass in context information at evaluation time, which replaces the mergefields prior to the formula being evaluated. This makes it possible to create formulas in tools like Flow Builder that include mergefields that won't get calculated until a later runtime.

Basic Formula Support

This action 

Use the syntax described in places like https://help.salesforce.com/articleView?id=customize_functions.htm&type=5
and
https://help.salesforce.com/articleView?id=how_do_i.htm&type=5

Currently supported functions include:
Base object fields (e.g. MyField__c == 4)
Lookup fields (e.g. Relation__r.Account.Name == ‘ACME’)
Constants (e.g. $PI, EE, $TODAY, $NOW, $RANDOM
Logical operators in function style or inline (e.g. AND(true,false) ; true && false)
IF and CASE flow expressions (e.g. IF(true,1,0) )
Various String functions (e.g. LEFT(“String”,2) )
Various Math functions (e.g. POW(2,5) )
Type conversion functions (e.g. DATE(“2015-05-23”) )
DateTime functions (e.g. DATETIME(2015,12,01,0,0,0) ; ADDYEARS($TODAY, 10) )
Multiline comments
Access to Hierarchy Custom Settings (e.g. $Setup.HierarchyCS__c.Value__c)
Access to Hierarchy Custom Settings (e.g. $Setup.ListCS__c[“aName”].Value__c)

The official list is: {'AND', 'OR', 'NOT','XOR', 'IF', 'CASE', 'LEN', 
        'SUBSTRING','LEFT','RIGHT','ISBLANK','ISPICKVAL','CONVERTID',
        'ABS','ROUND','CEIL','FLOOR','SQRT','ACOS','ASIN','ATAN','COS','SIN','TAN','COSH','SINH','TANH','EXP','LOG','LOG10','RINT','SIGNUM','INTEGER',
        'POW','MAX','MIN','MOD',
        'TEXT','DATETIME','DECIMAL','BOOLEAN','DATE',
        'DAY','MONTH','YEAR','HOURS','MINUTES','SECONDS',
        'ADDDAYS','ADDMONTHS','ADDYEARS','ADDHOURS','ADDMINUTES','ADDSECONDS'

Functions that we're interested in adding (volunteers welcome!) include:
