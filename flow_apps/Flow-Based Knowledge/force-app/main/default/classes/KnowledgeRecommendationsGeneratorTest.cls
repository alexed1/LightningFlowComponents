@IsTest
private class KnowledgeRecommendationsGeneratorTest 
{
    static final String TEST_TITLE = 'Test title';
    static final String TEST_ARTICLETYPE = '???';
    static final String TEST_LANGUAGE = 'en_US';
    static final String TEST_PUBLISHSTATUS = 'Online';
    static final String TEST_URL = 'test-url';
    static final String STRATEGY_NAME = 'Get_Knowledge_Recommendation';

    @TestSetup
    static void makeData()
    {
        Knowledge__kav article = new Knowledge__kav();
        article.Title = TEST_TITLE;
        article.Language = TEST_LANGUAGE;
        article.UrlName = TEST_URL;
        article.Summary = TEST_TITLE;
        
        insert article;

        Knowledge__kav knowledge = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav LIMIT 1];
        KbManagement.PublishingService.publishArticle(knowledge.KnowledgeArticleId, true);

        SearchPromotionRule searchPromotion = new SearchPromotionRule();
        searchPromotion.Query = TEST_TITLE;
        searchPromotion.PromotedEntityId = knowledge.Id;
        insert searchPromotion;
    }

    @IsTest
    static void testGenerateKnowledgeRecommendations() 
    {
        Knowledge__kav knowledge = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav LIMIT 1];
        Id[] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = knowledge.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        List<KnowledgeRecommendationsGenerator.Requests> requests = new List<KnowledgeRecommendationsGenerator.Requests>();
        KnowledgeRecommendationsGenerator.Requests request = new KnowledgeRecommendationsGenerator.Requests();

        request.searchString = TEST_TITLE;
        request.languageLocale = TEST_LANGUAGE;
        request.topic = TEST_TITLE;
        request.publicationStatus = TEST_PUBLISHSTATUS;
        requests.add(request);

        List<Recommendation> recommendations = KnowledgeRecommendationsGenerator.generateKnowledgeRecommendations(requests)[0].outputRecommendations;
        
        System.assertEquals(TEST_TITLE, recommendations[0].Name, 'Wrong search results');
        System.assertEquals(knowledge.Id, recommendations[0].ExternalId, 'Wrong search results');
    }

    @IsTest
    static void testExecuteNBAFlow() {
        Knowledge__kav knowledge = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav LIMIT 1];
        Id[] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = knowledge.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        List<Recommendation> recommendations = KnowledgeRecommendationsGenerator.ExecuteNBAFlow(STRATEGY_NAME, 'id', 'test');
        System.assert(recommendations.size() == 1);
    }

    @isTest
    static void testLaunchFLow() {
        Knowledge__kav knowledge = [SELECT Id,Title, KnowledgeArticleId FROM Knowledge__kav LIMIT 1];
        Recommendation recommendation = new Recommendation();
        recommendation.ExternalId = knowledge.Id;
        recommendation.Name = knowledge.Title;
        recommendation.Description = 'Test Description';
        recommendation.ActionReference = 'Display_Knowledge_Article';
        Account acc = new Account();
        acc.Name = 'Test Acc';
        insert acc;
        String flowType = KnowledgeRecommendationsGenerator.launchFLow(recommendation, STRATEGY_NAME, acc.Id);
        System.assert(flowType == 'Flow');
        recommendation.ActionReference = 'Test_Flow';
        
        flowType = KnowledgeRecommendationsGenerator.launchFLow(recommendation, STRATEGY_NAME, acc.Id);
        System.assert(flowType == 'AutoLaunchedFlow');

    }
}