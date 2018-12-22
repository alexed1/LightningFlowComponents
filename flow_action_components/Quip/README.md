# Quip Actions

A collection of flow actions that allows user to manipulate data inside specific Quip spreadsheets

## Before Installing

1. You need to have Quip developer account. You can get one [here](https://developer.quip.com/)

2. After registration, go to [https://quip.com/dev/token](https://quip.com/dev/token) and generate a new access token 

## Installation

1. Deploy the Quip Flow Actions to your organization

3. Open your org website. Go to *Settings* -> *Custom Metadata Types*

4. Find type labeled *Quip Access Token* and click *Manage Records*

5. Find object labeled *Token* and click *Edit*

6. Paste your Quip access token into the *Token* field and click *Save*

7. Go back to *Settings* and open *Named Credentials*

8. Find the credential labeled *quip* and verify that its URL matches the one that corresponds to your access token. If you just use your personal Quip account then you likely won't need to change anything here but if you have Enterprise version of Quip, you may need to.
