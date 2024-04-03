/**
 * Invocable Apex Action for Flow:  ConvertTextToBase64
 * 
 * Created By:  Eric Smith
 * 
 * Description: This component is designed to be used in a Flow to convert a text string to Base64
 * 
 * Custom Property Editor:      N/A          
 * 
 * CPE Supporting Components:   N/A       
 * 
 * 04/03/24 -   Eric Smith -    Version 1.0.0   
 * 
 **/

 global with sharing class ConvertTextToBase64 {
    
    /* Flow Action */
    @invocableMethod(label='Convert Text to Base64'
        iconName='slds:utility:data_transforms'
        category='Util'
        description='Convert a Text String to Base64 - By Eric Smith')

    global static List<Results> ConvertTextToBase64(List<Requests> requestList) {

        /* Prepare Response */
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        /* Process Inputs */
        for (Requests req : requestList) {  

            /* Get Input Values */
            String textValue = req.textInput;
            
            /* Perform Action(s) */

            // Base64 the Text
            String base64Value = EncodingUtil.Base64Encode(Blob.valueOf(textValue));

            /* Convert the other direction
            // Text the Base64
            // Blob blobValue = EncodingUtil.base64Decode(base64Value);
            // String stringValue = blobValue.toString();
            */

            /* Prepare Output */
            response.base64Output = base64Value;

            /* Process Outputs */
            responseWrapper.add(response);
        }

        /* Return Results */
        return responseWrapper;

    }

    /* Input parameters for the Apex action */
    global class Requests {

        @InvocableVariable(label='Text Value for Conversion' 
            description='Text value to be converted into Base64')
        global String textInput;

    }

    /* Output parameters of the Apex action */
    global class Results {
        @InvocableVariable(label='Base64 Value' 
            description='The converted Base64 value')
        global String base64Output;
    }
                    
}