public with sharing class mc_ConvertGoogleSearchToString {
    @InvocableMethod(label='Convert Google Search to Seralized String' description='Converts the Google Search Response to a seralized string for use in the USF datatable' category='USF')
    public static List<Results> mc_ConvertGoogleSearchToString(List<Request> requests) {
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        Results response = new Results();

        // Go through each request
        for (Request request : requests) {
            // Split the request into the different parts
            List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_related> related = request.googleSearchResponse.related;
            List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_peoplex5falsox5fask> people_also_ask = request.googleSearchResponse.peoplex5falsox5fask;
            List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_organic> organic = request.googleSearchResponse.organic;

            // Serialize the data
            response.related = JSON.serialize(related);
            response.people_also_ask = JSON.serialize(people_also_ask);
            response.organic = JSON.serialize(organic);

            // Set the response
            responseWrapper.add(response);
        }

        // Return the response
        return responseWrapper;
    }

    public class Request {
        @InvocableVariable(required=true label='Array to Parse')
        public ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX googleSearchResponse;
    }

    public class Results {
        @InvocableVariable
        public String organic;
        @InvocableVariable
        public String related;
        @InvocableVariable
        public String people_also_ask;
    }
}