# Get Case Thread Token Flow Action
Salesforce Email To Case Lightning Threading Token - The new Lightning Threading Token cannot be derived in a formula like the legacy Ref Id (i.e. `ref:_00Dxx1gEW._500xxYktl:ref` or `ref:!00Dxx01gEW.!500xx0Yktl:ref
`).  Rather each recordId has a unique threading token that cannot be derived in the same way.

This invocable apex action allows for passing the case id and returning the thread token.  The class Implements the EmailMessages.getFormattedThreadingToken(caseId) method to return a formatted string such as `thread::pp5XPGfmNf2hRZdRCWnrohc::`

**Use Case:**\
Used when you must stamp the thread token into a screen flow, or onto the case record itself to consume directly, from list view, report, global search, etc for interactivity with your users.

**Post Install:**\
Simply add your own custom text field (255) to the case object, assign to layout, grant permissions, and connect it to an after-save record-triggered flow on case to assign the token field.

**Salesforce install links:**\
prod:     https://login.salesforce.com/packaging/installPackage.apexp?p0=04taj00000039ht \
sandbox:  https://test.salesforce.com/packaging/installPackage.apexp?p0=04taj00000039ht 

**More info:**\
https://help.salesforce.com/s/articleView?id=sf.support_email_to_case_threading.htm&type=5

https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_System_EmailMessages_getFormattedThreadingToken.htm
