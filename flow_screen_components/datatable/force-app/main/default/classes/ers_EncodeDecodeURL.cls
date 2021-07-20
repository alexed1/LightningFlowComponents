public with sharing class ers_EncodeDecodeURL {

    /* Flow Action */
    @invocableMethod(label='URL Encode/Decode String' description='This Encodes or Decodes a string to handle spaces and other characters that are not allowed in urls')
    public static List<Results> decodeStringForURL(List<Requests> requestList) {

        /* Prepare Response */
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();

        /* Process Inputs */
        for (Requests req : requestList) {

            /* Get Input Values */
            String inputStr = req.inputStr;
            String curEncoding = req.curEncoding;
            Boolean encode = req.encode;

            /* Perform Action(s) */
            if (!String.isBlank(inputStr)) {
                if (encode) {
                    response.outputStr = EncodingUtil.urlEncode(inputStr, curEncoding);
                } else {
                    response.outputStr = EncodingUtil.urlDecode(inputStr, curEncoding);
                }
            }

            /* Process Outputs */
            responseWrapper.add(response);
        }

        /* Return Results */
        return responseWrapper;
    }

    /* Input parameters for the Apex action */
    public class Requests {
        @invocableVariable(label='Input String')
        public String inputStr;

        @invocableVariable(label='Encoding Method - Default: UTF-8')
        public String curEncoding = 'UTF-8';

        @invocableVariable(label='Encode? - Default: false(Decode)')
        public Boolean encode = false;
    }

    /* Output parameters of the Apex action */
    public class Results {
        @invocableVariable(label='Output String')
        public String outputStr;
    }

}