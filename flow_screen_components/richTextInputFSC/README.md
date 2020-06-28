# Rich Text Edit Control #

https://unofficialsf.com/rich-text-input-flow-screen-component/


# inputRichTextFSC
Rich Text enhancements for Flows

### Summary:
IMPORTANT:  Use richerText = true input attribute if you want to leverage these enhanced features.  Otherwise leave empty and regular input Rich Text component will be used.
1)	Block disallowed words and symbols
    a.	Control whether this is a block that prevents next/finish of flow.
2)	Search and Replace custom text
3)	Auto-Replace suggested words
4)	Revert mass changes from search/replace or suggested words

### Admin Instructions:
1)  Follow Input/Output map below.
2)  Hard Block will prevent user from advancing the Flow screen if there are disallowedWords or disallowedSymbols used.
3)  Default for disallowed Words/Symbols if hardBlock is false will be a Warning message only.  Setting hardBlock to true will set them to Error messages.

|Parameter	               |I	   |O	     |Information 
|--------------------------|-----|-------|-------------------------------------------------------------------------------|
|**richerText**            |X    |       |  Boolean.  Set to true if you want to use enhanced rich text.  Default if false (regular input component)   |
|**autoReplaceMap**	           |X	   |       |JSON formatted key:value map.  (example => {"Test": "GreatTest™"} )            |
|**disallowedSymbols**	       |X	   |       |Comma-separated list of words to block.  Example: /,@,*                        |
|**disallowedWords**	         |X    |	     |Comma-separated list of words to block.  Example: bad,worse,worst              |
|**warnOnly**	               |X	   |	     |Boolean.  Set to True if you want to allow Next even where disallowed Symbol or Word remains.  Default is false.   |
|**richText**	                 |X	   |X	     |Input and output RichText that you’ll be editing                               |
|**label**                      |X     |X        |Input to provide field-level label if desired                                 |


### User Instructions:
1)  While entering text in the Rich Text Area, if you use words or symbols that are flagged as not allowed, you will receive either a warning message (yellow popup) or an error message (red popup).
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
