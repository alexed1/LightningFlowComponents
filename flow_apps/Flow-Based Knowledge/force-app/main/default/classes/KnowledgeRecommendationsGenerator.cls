public with sharing class KnowledgeRecommendationsGenerator 
{
    @InvocableMethod
    public static List<List<Recommendation>> generateKnowledgeRecommendations(List<Requests> requests)
    {
        List<List<Recommendation>> recommendationsResult = new List<List<Recommendation>>();
        List<Recommendation> recommendations = new List<Recommendation>();

        String searchString = requests[0].searchString;
        String languageLocale = requests[0].languageLocale;
        String articleType = requests[0].articleType;
        String topic = requests[0].topic;
        String publicationStatus = requests[0].publicationStatus;
        Integer resultLimit = requests[0].resultLimit;
        
        if(resultLimit == null)
        {
            resultLimit = 5;
        }

        String queryString = 'FIND {' + searchString + '} IN ALL FIELDS RETURNING KnowledgeArticleVersion(';
        queryString += 'id, title WHERE Language = :languageLocale';
        /* Commented, because such field doesn't exists on KnowledgeArticleVersion object
        if(articleType != null)
        {
            queryString += ' AND ArticleType = :articleType';
        }
        */
        if(topic != null)
        {
            queryString += ' AND Title = :topic';
        }

        if(publicationStatus != null)
        {
            queryString += ' AND PublishStatus = :publicationStatus';
        }

        queryString += ') WITH SNIPPET (target_length=120) LIMIT ' + resultLimit;
        Search.SearchResults searchResults = Search.find(queryString);
        List<Search.SearchResult> articleList = searchResults.get('KnowledgeArticleVersion');
        
        for(Search.SearchResult searchResult : articleList)
        {
            Recommendation recommendation = new Recommendation();
	        KnowledgeArticleVersion article = (KnowledgeArticleVersion) searchResult.getSObject();
            
            recommendation.ExternalId = article.Id;
            recommendation.Name = article.Title;
            recommendation.Description = searchResult.getSnippet();
            recommendation.ActionReference = 'Display_Knowledge_Article';

            recommendations.add(recommendation);
        }

        recommendationsResult.add(recommendations);
        return recommendationsResult;
    }

    @AuraEnabled
    public static List<Recommendation> executeNBAFlow(String strategyName, String contextRecordId, String searchString) {
        Flow.Interview curInterview = Flow.Interview.createInterview(strategyName, new Map<String,Object>{'recordId' =>contextRecordId, 'searchString' => searchString });
        curInterview.start();
        System.debug('searchString' + searchString);
        System.debug(curInterview.getVariableValue('outputRecommendations'));
        return (List<Recommendation>)curInterview.getVariableValue('outputRecommendations');
    }

    public class InvocableErrorException extends Exception {}

    public class Requests 
    {
        @InvocableVariable(required=true)
        public String searchString;

        @InvocableVariable(required=true)
        public String languageLocale;

        @InvocableVariable
        public Integer resultLimit;

        @InvocableVariable
        public String articleType;
        
        @InvocableVariable
        public String topic;
        
        @InvocableVariable
        public String publicationStatus;
    }
}