@isTest
public with sharing class mc_ConvertGoogleSearchToString_Test {
    @isTest
    public static void mc_ConvertGoogleSearchToString_Test() {
        ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX googleSearchResponse = new ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX();
        // Create a new organic object
        ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_organic organic = new ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_organic();
        organic.title = 'title';
        organic.link = 'link';
        organic.description = 'description';
        organic.displayx5flink = 'display_link';
        
        // Create a new list of organic objects
        List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_organic> organicList = new List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_organic>();
        organicList.add(organic);

        // Add the list of organic objects to the google search response
        googleSearchResponse.organic = organicList;

        // Create a new people also ask object
        ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_peoplex5falsox5fask peopleAlsoAsk = new ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_peoplex5falsox5fask();
        peopleAlsoAsk.answerx5flink = 'answer_link';
        peopleAlsoAsk.questionx5flink  = 'question_link';
        peopleAlsoAsk.answerx5fsource  = 'answer_source';
        peopleAlsoAsk.answerx5fdisplayx5flink  = 'answer_display_link';
        peopleAlsoAsk.question = 'question';

        // Create a new list of people also ask objects
        List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_peoplex5falsox5fask> peopleAlsoAskList = new List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_peoplex5falsox5fask>();
        peopleAlsoAskList.add(peopleAlsoAsk);

        // Add the list of people also ask objects to the google search response
        googleSearchResponse.peoplex5falsox5fask = peopleAlsoAskList;

        // Create a new related searches object
        ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_related relatedSearches = new ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_related();
        relatedSearches.text = 'text';
        relatedSearches.link = 'link';

        // Create a new list of related searches objects
        List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_related> relatedSearchesList = new List<ExternalService.apiLayerGoogleSearch_Googlex20Search_OUT_2XX_related>();
        relatedSearchesList.add(relatedSearches);

        // Add the list of related searches objects to the google search response
        googleSearchResponse.related = relatedSearchesList;

        // Create Request
        mc_ConvertGoogleSearchToString.Request request = new mc_ConvertGoogleSearchToString.Request();
        request.googleSearchResponse = googleSearchResponse;

        List<mc_ConvertGoogleSearchToString.Request> convertGoogleSearchToStringList = new List<mc_ConvertGoogleSearchToString.Request>();
        convertGoogleSearchToStringList.add(request);

        // Start the test
        Test.startTest();
        mc_ConvertGoogleSearchToString.mc_ConvertGoogleSearchToString(convertGoogleSearchToStringList);
        Test.stopTest();

    }
}