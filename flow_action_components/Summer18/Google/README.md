# Google Sheets Actions

## Installation

1) Create a Google Auth Provider if your org does not already have one. This will require creating a Google Developer Account. See below.
   
2) Deploy/Install the GoogleFlowActions package
   
3) Authorize the installed Named Credentials by editing and saving them OR create your own Named Credentials, as described below.
   
4)Verify your OAuth client with Google (just follow their instructions at https://support.google.com/googleapi/answer/7454865?hl=en&authuser=0). You still can proceed without the verification, but in this case Google doesn't provide the refresh token and their access token lives no longer than 24 hour (most likely less). If the token is expired you'll have to open the specific Named Credential and re-authorize it (open credentials and click *Save*). Otherwise, during the execution of Google activities you will see an error message *'Invalid Credentials'*

## Creating a Google Auth Provider

### Google Developer Account and OAuth Application

- You need to have Google Developer account for your organization. You can get one [here](https://developers.google.com/)

- For you developer account you must enable *Google Drive* and *Google Sheets* API
   
- Open Google Developer Console [here](https://console.developers.google.com/projectselector/apis/library?supportedpurview=project%20)

- Create a new project.

- Open the newly created project. Go to *Credentials* tab and navigate to its *OAuth Consent screen* subtab

- Put meaningful value into *Application Name* field and add your application domain to the *Authorized domains* field. If you have a developer/scratch org then most likely your domain will be *salesforce.com*

- Click *Save*

- Click *Create Credentials* and pick *OAuth client Id*

- Select *Web Application*, put a name for it into *Name* field and click *Create*

- Write down your *client Id* and *client secret* from the next screen (though you can always get it from *Credentials* screen)

### Salesforce Auth Provider

- Login to your Salesforce org where you are going to use Google Sheets Actions

- Click on *Setup* and type *Auth. Provider* in Quick Search Box

- Select *Auth. Provider* and click on *New* button

- Specify the below mentioned values for the input fields:
  
- - *Provider Type*: Google
- - *Name*: google
- - *URL Suffix*: google
- - *Consumer Key*: < put your OAuth client Id from the previous step >
- - *Consumer Secret*: < put your OAuth client secret from the previous step >

- Click *Save*. A *Callback URL* field will be populated. Copy its value

- Navigate to your Google Project and its Web Client you've created, and paste the Callback URL from the Auth Provider into the Google Project's Redirect URL field.

### Salesforce Named Credentials

If you are using the Named Credentials in the package, edit them and then save them to trigger authorization. Perform the following steps only if you are not going to push the named credentials that are part of this package

#### Google Sheets

- Click on *Setup* and type *Named Credential* in Quick Search Box

- Select *Named Credential* and click on *New Named Credential* button

- Specify the below mentioned values for the input fields. **NOTE**: its very important to put the name exactly as specified below. This name will be used by activities to get data from Google API

- - *Label*: google-sheets
- - *Name*: google_sheets
- - *URL*: https://sheets.googleapis.com/v4
- - *Identity Type*: Named Principal
- - *Authentication Protocol*: OAuth 2.0
- - *Authentication Provider*: < lookup the previously created provider (*google* in the example)>
- - *Scope*: openid https://www.googleapis.com/auth/spreadsheets
- - Check *Start Authentication Flow on Save* checkbox and click *Save*

- You'll be redirected to a Google authorization page. Use your Google account credentials to login and allow the application access

#### Google Drive

- Click on *Setup* and type *Named Credential* in Quick Search Box

- Select *Named Credential* and click on *New Named Credential* button

- Specify the below mentioned values for the input fields. **NOTE**: its very important to put the name exactly as specified below. This name will be used by activities to get data from Google API

- - *Label*: google-drive
- - *Name*: google_drive
- - *URL*: https://www.googleapis.com/drive/v3
- - *Identity Type*: Named Principal
- - *Authentication Protocol*: OAuth 2.0
- - *Authentication Provider*: < lookup the previously created provider (*google* in the example)>
- - *Scope*: openid https://www.googleapis.com/auth/drive
- - Check *Start Authentication Flow on Save* checkbox and click *Save*

- You'll be redirected to a Google authorization page. Use your Google account credentials to login and allow the application access

**IMPORTANT NOTE**: you'll have to verify your connected app with Google (just follow their instructions). You still can proceed without the verification, but in this case Google doesn't provide the refresh token and their access token lives no longer than 24 hour (most likely less). If the token is expired you'll have to open the specific Named Credential and re-authorize it (open credentials and click *Save*). Otherwise, during the execution of Google activities you may see an error message *'Invalid Credentials'*