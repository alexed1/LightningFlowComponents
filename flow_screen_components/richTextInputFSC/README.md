# Rich Text Edit Control #

https://unofficialsf.com/rich-text-input-flow-screen-component/


# inputRichTextFSC
Rich Text enhancements for Flows

### Summary:
IMPORTANT:  Use enabledAdvancedTools = true input attribute if you want to leverage these enhanced features.  Otherwise leave empty and regular input Rich Text component will be used.
1)	Warn or Block Transition in Flow if disallowed words and/or symbols are present.
2)	Find and Replace
3)	Auto-Replace suggested words
4)	Undo functionality for search/replace or suggested words
5)  Character Count and Max Character limits.

### Admin Instructions:
##### Enabling and Disabling Features in Flow:
1)  Default function is regular rich text input field.  To enable advanced features set enableAdvancedTools to true.
2)  Setting label provides a field label for the rich text input.
3)  Rich Text input/output is provided through the value attribute.
##### Replace Text with Suggested Terms:
1)  If autoReplaceMap is populated, then a button is shown to user.
2)  Use autoReplaceMap to set up key:value pairs in JSON.  Example: {"Test":"GreatTest™"}
     a.  When user employs the button, the key will be replace by value.
##### Managing Disallowed Words and Symbols:
1)  If disallowedSymbols or disallowedWords is filled, then user will be notified while typing one of those words or symbols.
2)  Both disallowedSymbols and disallowedWords accept a comma delimited string.
3)  The default message will say 'Error' and provide the violating word/symbol.  This will also give validation error if user tries to advance while error is still present.
4)  To change the message to a warning only, and turn off the associated validation (allowing user to advance the Flow), set warnOnly attribute to true.
##### Character Counts and Limits:
1)  Character count is off by default.  Set characterLimit to an integer value to show character count and limit.  
2)  If warnOnly is not set when characterLimit is on, then the Flow Next/Finish cannot be used until resolved.

|Parameter	               |I	 |O	     |Information 
|--------------------------|-----|-------|----------------------------------------------------------------------------------------------------------------------------------|
|**enableAdvancedTools**   |X    |       |Boolean.  Set to true if you want to use enhanced rich text.  Default is false (regular input component)                          |
|**autoReplaceMap**	       |X	 |       |JSON formatted key:value map.  (example => {"Test": "GreatTest™"} )                                                               |
|**disallowedSymbols**	   |X	 |       |Comma-separated list of words to block.  Example: /,@,*                                                                           |
|**disallowedWords**	   |X    |	     |Comma-separated list of words to block.  Example: bad,worse,worst                                                                 |
|**warnOnly**	           |X	 |	     |Boolean.  Set to True if you want to allow Next even where disallowed Symbol or Word remains.  Default is false.                  |
|**characterLimit**	       |X	 |	     |Integer.  Set character limit.  This will enable character count and limit, and if warnOnly is not true, then will block next.    |
|**value**	           	   |X	 |X	     |Input and output Rich Text that you’ll be editing                                                                                 |
|**label**                 |X    |X      |Input to provide field-level label if desired                                                                                     |


### User Instructions:
1)  While entering text in the Rich Text Area, if you use words or symbols that are flagged as not allowed, you will receive either a warning message or an error message.
    a.  If the warning message is displayed, this is for notification only, and you will be able to proceed.
    b.  If the error message is shown, this means you will need to correct the noted error prior to continuing.  If you try to click Next/Finish, a validation message will be  given.
2)  To Search and Replace text, click on the magnifying glass icon. titled 'Search and Replace'
    a.  A 'Search Text' field is displayed where you enter the text you want to find.
    b.  A 'Replace with Text' field is shown where you enter the replacement text to be applied where the 'Search Text' is found.
    c.  Use the 'Check' icon to commit the search/replace.
    d.  Use the 'Revert Last Change' button that appears after search/replace to undo the changes just made.
    e.  If you no longer want to use Search/Replace, you can click on the Magnifying Glass icon again to hide these fields.
3)  To replace suggested terms set up by your admin, click on the Merge icon titled 'Apply Suggested Terms'.  Note this will only be shown if your admin has configured this.
    a.  The component will find text to be replaced and overwrite with teh replacement term identified by your admin.  
    b.  Use the 'Revert Last Change' button that appears after search/replace to undo the changes just made. 
