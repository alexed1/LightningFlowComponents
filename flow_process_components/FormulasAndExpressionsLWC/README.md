# Formula Builder

It is an LWC that allows user to created formulas just like you do with standard formula builder when you create a formula field. User is able to insert field from context object or allowed context types like (User, Profile or Organization), Function (AND, OR, CONTAINS, etc...) and operator (+, -, ==, etc...) from predetermined picklist.

## Supported attributes

### formulaString
Allows to specify formula value this component will be initialized with.
### contextObjectType
Standard or custom object API name, determines set of fields which user will be able to choose from 'Insert Field' picklist
### supportedSystemTypes
Comma separated list of Object API Names, which will be used as context variables and user will also be able to choose those objects fields. Usually it is User, Profile or Organization.

## Formula Evaluator

Apex class that is responsible for actually evaluation a formula on run time based on passed in formula and context information. It supports context objects mentioned above and custom context variables, where developer is able to specify some custom constants.

### Supported Context Data

 $Record - put context record.Id here if your formula should take data from real record on run time
 anyCustomLiteral - attribute name and value, which can later be used while evaluating a formula.
 
 #### Example of context configuration: 
 
   `Account acc = new Account(Name = 'Test acc', NumberOfEmployees = 11);
   insert acc;
   List<ContextWrapper> context = new List<ContextWrapper>();
   context.add(new ContextWrapper('$Record', acc.Id));
   context.add(new ContextWrapper('contextVariableOne', '30'));
   context.add(new ContextWrapper('contextVariableTwo', '45'));`
   
   #### Example of evaluating a formula
   `String stringContext = JSON.serialize(context);
   String result = FormulaEvaluator.parseFormula('$Record.NumberOfEmployees + contextVariableOne + contextVariableTwo', stringContext);`
   
   After evaluating above formula with its contexts it will return 11 + 30 + 45 = 86 as a result
### Supported Formula Functions

Currently formula evaluator supports following functions, but this list can be extended by a developer:

`'AND', 'OR', 'NOT', 'XOR', 'IF', 'CASE', 'LEN', 'SUBSTRING', 'LEFT', 'RIGHT',
        'ISBLANK', 'ISPICKVAL', 'CONVERTID', 'ABS', 'ROUND', 'CEILING', 'FLOOR', 'SQRT', 'ACOS',
        'ASIN', 'ATAN', 'COS', 'SIN', 'TAN', 'COSH', 'SINH', 'TANH', 'EXP', 'LOG', 'LOG10', 'RINT',
        'SIGNUM', 'INTEGER', 'POW', 'MAX', 'MIN', 'MOD', 'TEXT', 'DATETIME', 'DECIMAL', 'BOOLEAN',
        'DATE', 'DAY', 'MONTH', 'YEAR', 'HOURS', 'MINUTES', 'SECONDS', 'ADDDAYS', 'ADDMONTHS',
        'ADDYEARS', 'ADDHOURS', 'ADDMINUTES', 'ADDSECONDS', 'CONTAINS', 'FIND', 'LOWER', 'UPPER'
        , 'MID', 'SUBSTITUTE', 'TRIM', 'VALUE', 'CONCATENATE'`
        
### Supported Formula Operators 

Currently formula evaluator supports following operators, but this list can be extended by a developer:

`'+', '-', '/', '*', '==', '!=', '>', '<', '>=', '<=', '<>'`

# Expression Builder

It is an LWC component that allows user to create expressions by selecting fields, operators and fieldValues. It acts like standard expression builder.

## Component description

At background it generates formula string that is later being processed by formula builder.

### Supported Conditions

All Conditions Are Met - result of evaluating this expression will return 'true' only if *ALL* expressions return true
Any Condition Is Met - result of evaluating this expression will return 'true' only if *ANY* expressions return true

### Supported Component Attributes

#### formulaString 
Used to initialize a component with predetermined value or stores formula for current component state 
#### addButtonLabel 
Label for button to add new lines in expression builder
#### contextObjectType 
API name of context object, it determines fields user will be able to choose in "Field" picklist
#### supportedSystemTypes 
Comma separated list of Object API Names, which will be used as context variables and user will also be able to choose those objects fields. Usually it is User, Profile or Organization.
