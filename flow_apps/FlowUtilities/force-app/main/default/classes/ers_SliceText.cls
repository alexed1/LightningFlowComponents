/** 
 *  Slice Text Flow Action
 * 
 *  Eric Smith - 3/28/23 - v1.0
 * 
 *  This class is a String Utility designed to find a given section of text and return the text before, the text from start to end, the text inside and the text after the search attributes
 *  
 *  It takes an input source text and a start and end(optional) search text.  
 *  Outputs will be the text before the found text, the extracted searched text including the search attributes, 
 *  the extracted searched text inside the search attributes, and the text after the found text. 
 * 
 *  Example:
 *      Source - <div><p>abc</p></div>
 *          Start - <p>
 *          End - </p>
 *      Results:
 *          Before - <div>
 *          Extract - <p>abc</p>
 *          Inner - abc
 *          After - </div>
 * 
**/ 

global inherited sharing class ers_SliceText {

    // Attributes passed in from the Flow
    global class Requests {
    
        @InvocableVariable(Label='Begin Search Text')
        global String searchBegin;

        @InvocableVariable(Label='End Search Text')
        global String searchEnd;

        @InvocableVariable(Label='Source Text')
        global String sourceText;

        @InvocableVariable(Label='Reverse Search (Find Last)?')
        global Boolean reverseSearch = false;

    }

    // Attributes passed back to the Flow
    global class Results {

        @InvocableVariable 
        global Boolean notFound;

        @InvocableVariable
        global String textAfter;

        @InvocableVariable
        global String textBefore;

        @InvocableVariable
        global String textExtract;

        @InvocableVariable
        global String textInner;

    }

    // Standard Exception Handling
    global class InvocableActionException extends Exception {}

    // Expose this Action to the Flow
    @InvocableMethod(label='Text Utility - Slice Text by Eric Smith' iconName='resource:SliceSVG:Layer_1')
    global static List<Results> sliceText(List<Requests> requestList) {

        // Prepare the response to send back to the Flow
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        // Bulkify proccessing of multiple requests
        for (Requests req : requestList) {

            // Get Input Value(s)
            String searchBegin = String.isEmpty(req.searchBegin) ? '' : req.searchBegin;
            String searchEnd = String.isEmpty(req.searchEnd) ? '' : req.searchEnd;
            String sourceText = String.isEmpty(req.sourceText) ? '' : req.sourceText;
            Boolean reverseSearch = (req.reverseSearch != true) ? false : true;

            // Set initial values
            Boolean notFound = false;
            String textAfter = '';
            String textBefore = '';
            String textExtract = '';
            String textInner = '';

            // Process input attributes
            
            // Validate input attributes

// BEGIN APEX ACTION PROCESSING LOGIC

            // Define working variables
            Integer startPosition = -1;
            Integer endPosition = -1;
            Integer indexPosition = -1;
            Integer lenExtract = 0;
            Integer characterCount = 0;
            String holdSearch = '';
            String holdText = '';

            // Start processing
            textBefore = sourceText;

            // Check for Find Last (Reverse Search)
            if (reverseSearch) {
                holdSearch = searchBegin;
                searchBegin = searchEnd.reverse();
                searchEnd = holdSearch.reverse();
                sourceText = sourceText.reverse();
                if (searchBegin.length() == 0) {
                    searchBegin = searchEnd;
                    searchEnd = '';
                }
            }

            // Find the position of the first character in the start search text
            startPosition = sourceText.indexOf(searchBegin);

            // Check to see if the start search text was found
            if (startPosition <> -1) {
                // If an end search text is provided, the extract will be everything starting with the start text and ending with the end text.
                if (searchEnd.length() > 0) {   
                    
                    // Find the position of the last character in the end search text
                    indexPosition = startPosition + searchBegin.length();
                    endPosition = sourceText.indexOf(searchEnd, indexPosition) + searchEnd.length() - 1;

                    // Check to see if the end search text wasn't found
                    if (endPosition <= (searchEnd.length() - 1)) {
                        // Set the error flag to true. 
                        notFound = true;
                    }

                // A slice with just a start search text will find and extract the search text. 
                } else {    
                    // Set the end position to be the end of the single search term
                    endPosition = startPosition + searchBegin.length() - 1;
                }

                // Set the number of characters in the found search to be extracted
                lenExtract = endPosition - startPosition + 1;

                // Slice the source text into the text before the search, the search extracted, and the text after the search

                // BEFORE
                characterCount = startPosition;
                textBefore = sourceText.left(characterCount);

                //EXTRACT
                indexPosition = startPosition;
                characterCount = lenExtract;
                textExtract = sourceText.mid(indexPosition, characterCount);

                //AFTER
                characterCount = sourceText.length() - lenExtract - textBefore.length();
                textAfter = sourceText.right(characterCount);

                // Check for Find Last (Reverse Search)
                if (reverseSearch) {
                    holdText = textBefore;
                    textBefore = textAfter.reverse();
                    textExtract = textExtract.reverse();
                    textAfter = holdText.reverse();
                    holdSearch = searchBegin;
                    searchBegin = searchEnd.reverse();
                    searchEnd = holdSearch.reverse();
                }

                // Extract inner text between the search begin and the search end
                indexPosition = searchBegin.length();
                characterCount = textExtract.length() - searchEnd.length() - searchBegin.length();
                textInner = textExtract.mid(indexPosition, characterCount);

            } else {
                notFound = true;
            }

// END APEX ACTION PROCESSING LOGIC

                // Set Output Values
                response.notFound = notFound;
                response.textAfter = textAfter;
                response.textBefore = textBefore;
                response.textExtract = textExtract;
                response.textInner = textInner;
                responseWrapper.add(response);

            }

        // Return values back to the Flow
        return responseWrapper;
    }

}