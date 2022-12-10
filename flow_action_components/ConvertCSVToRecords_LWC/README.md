# LWC Convert CSV To Records

This component takes the processing from APEX to the client side, allowing larger files to be processed. The existing component here is far more dynamic than this new one, but this component allows flow users to import files and parse all while on the client side. This component will automatically navigate to the next screen when the parsing has been completed.

## Setup
Add the Convert CSV to Records - LWC to the screen.

![Screenshot 2022-11-15 at 21 59 59](https://user-images.githubusercontent.com/22582720/202085645-2fbd50b5-1c83-4254-a74e-590283281f1d.png)


## Inputs
Type in API Name
Search for the Object ( This will be used for the output record )
Enter the Object Name API Name in the Object Name field. ( This is used to get the field definition )

![Screenshot 2022-11-15 at 21 58 33](https://user-images.githubusercontent.com/22582720/202085661-8ce1aada-ad63-4a6f-b70b-ba79421470e7.png)


## Outputs
Output value: This is a List of records from the imported CSV file 

![Screenshot 2022-11-15 at 22 01 22](https://user-images.githubusercontent.com/22582720/202085676-fd88fb8c-44b6-448a-b840-319853d4ca8c.png)


## Column Headers
The header columns are compared against the objects fields, and if the header column is a custom field and the header isn’t labeled that way, the component will rename the header and assign the custom field.

### Example
Object: Account
Fields: Name, Description, Acitve__c
CSV Headers: Name, Description, Active

The code will change the headers to the following.
Name, Description, Active__c

## Implementations
Implementing this component can be as simple as creating records right after parsing like so:

![Screenshot 2022-11-15 at 22 07 45](https://user-images.githubusercontent.com/22582720/202085694-03072343-2d7a-4673-88c1-0e809a33a1e7.png)


Or you can be more complex with loops and filters as the output is an SObject allowing manipulation of the imported data.

![Screenshot 2022-11-15 at 22 10 42](https://user-images.githubusercontent.com/22582720/202085716-842bc6be-76d2-42c5-82d7-6caea9983595.png)


## Install Link
### Production/Dev
https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3C0000006OuB
### Sandbox
https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3C0000006OuB



