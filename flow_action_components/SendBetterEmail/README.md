## Installation Instructions ##

1. Install/update [Flow Base Components](https://unofficialsf.com/introducing-flowbasecomponents "Flow Base Components").  This is a firm pre-requisite.
2. Install the latest package found at [Send Rich Email (Send HTML Email Action)](https://unofficialsf.com/send-rich-email-with-the-new-sendhtmlemail-action/).

# Send HTML Email Flow Action

Flow provides a built-in Send Email action but it’s something of an underachiever. The sendHTMLEmail action uses the power of Apex and Flow Actions, easily installed and used from within Flow Builder. MVP Jeremiah Dohn pioneered this space several years back with his well received HTML Email Flow action. The version here is similar and adds a several of additional capabilities.

This improved email flow action supports:

- Rich, HTML email bodies that can use all of the capabilities of Flow’s Text Templates, including Bold, Italics, Underline, Bullets and Numbers, Left/Center/Right justification, URLs, images, fonts, and text size
- Email Templates (both Classic and Lightning) with field merge and letterheads.
- Any combination of the following, for To, CC, and BCC:

    - A single email address
    - A string collection of email addresses
    - A collection of Contacts
    - A collection of Users
    - A collection of Leads
    - Organization-Wide Email Addresses

- Also supported: 
    - Attachments
    - Ability to toggle on/off the use of the Salesforce per-user email signature
    - Ability to provide a plain text body, an html body, or both
    - Ability to set the ReplyTo email address and the Sender Display Name
    - Multi-Language Support for Lightning Email Templates
    - Mass Email Messaging Support
    - Activity Attachment for targeted recipient records
    - Task Attachments of email information for records related to the targeted recipient records
