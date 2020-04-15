global with sharing class PostRichChatter {

    private static final Map<String, String> PATTERN_TO_REPLACEMENT_MAP = new Map<String, String>{
            '<\\/?span[^>]*>' => '',
            '(<a href="([^"]+)" target="_blank">([^<]+)<\\/a>)' => '$3 ($2) ',
            ' class="ql-indent-[1-4]"' => '',
            '<img src="([^"]+)">' => 'image: $1'
    };

    @InvocableMethod
    global static List <Results> post(List<Requests> requestList) {


        Id standardCommunityId = Network.getNetworkId();
        Set<String> targetNames = new Set<String>();

        for (Requests curRequest : requestList) {
            if ((curRequest.targetNameOrId == null && (curRequest.collectionTargetStrings == null || curRequest.collectionTargetStrings.isEmpty())) ||
                    (curRequest.targetNameOrId != null && (curRequest.collectionTargetStrings != null && !curRequest.collectionTargetStrings.isEmpty()))) {
                throw new InvocableActionException('You need to provide either targetNameOrId or collectionTargetStrings, but you cant provide both');
            }

            if (curRequest.targetNameOrId != null) {
                curRequest.collectionTargetStrings.add(curRequest.targetNameOrId);
            }

            if (!curRequest.collectionTargetStrings.isEmpty()) {
                targetNames.addAll(curRequest.collectionTargetStrings);
            }
        }

        //check to see if the targetNameOrId matches a Group Name or a Username
        Map<String, String> targetNameToIdMap = getTargetNameToIdMap(targetNames);
        Map<String, List<ConnectApiHelper.FeedTargetBodyPair>> feedItemsMap = new Map<String, List<ConnectApiHelper.FeedTargetBodyPair>>();

        for (Requests curRequest : requestList) {
            String body = formatChatterPost(curRequest.body);

            String communityId = curRequest.communityId;
            if (communityId == null) {
                communityId = standardCommunityId;
            }

            if (!feedItemsMap.containsKey(communityId)) {
                feedItemsMap.put(communityId, new List<ConnectApiHelper.FeedTargetBodyPair>());
            }

            for (String curTargetNameOrId : curRequest.collectionTargetStrings) {
                String targetNameOrId = targetNameToIdMap.get(curTargetNameOrId);
                if (targetNameOrId == null) {
                    targetNameOrId = curTargetNameOrId;
                }
                feedItemsMap.get(communityId).add(new ConnectApiHelper.FeedTargetBodyPair(communityId, targetNameOrId, body));
            }
        }

        List<Results> responseWrapper = new List<Results>();

        for (String communityId : feedItemsMap.keySet()) {
            List<ConnectApi.BatchResult> batchResult = ConnectApiHelper.postFeedItemWithRichTextBulk(communityId, feedItemsMap.get(communityId));
            Results response = new Results();
            for (ConnectApi.BatchResult curResult : batchResult) {
                ConnectApi.FeedElement feedItemResult = (ConnectApi.FeedElement) curResult.getResult();
                if (curResult.isSuccess) {
                    response.feedItemIds.add(feedItemResult.id);
                } else {
                    response.errors.add(curResult.getErrorMessage());
                }
            }
            //Moving this out of the loop, as we can have only one response
            responseWrapper.add(response);
        }

        return responseWrapper;

    }

    private static Map<String, String> getTargetNameToIdMap(Set<String> targetNames) {
        Map<String, String> getTargetNameToIdMap = new Map<String, String>();
        List<Group> targetGroups = [SELECT Id,Name FROM Group WHERE Name IN :targetNames];
        List<User> targetUsers = [SELECT Id,Username FROM User WHERE Username IN :targetNames];

        for (Group curGroup : targetGroups) {
            getTargetNameToIdMap.put(curGroup.Name, curGroup.Id);
        }
        for (User curUser : targetUsers) {
            getTargetNameToIdMap.put(curUser.Username, curUser.Id);
        }

        return getTargetNameToIdMap;
    }

    private static String formatChatterPost(String inputString) {

        for (String curPattern : PATTERN_TO_REPLACEMENT_MAP.keySet()) {
            Pattern MyPattern = Pattern.compile(curPattern);
            Matcher MyMatcher = MyPattern.matcher(inputString);
            inputString = MyMatcher.replaceAll(PATTERN_TO_REPLACEMENT_MAP.get(curPattern));
            System.debug ('body after replacement is: ' + inputString);
        }

        return inputString;
    }

    global class Requests {
        public Requests() {
            this.collectionTargetStrings = new List<String>();
        }

        @InvocableVariable(required=true)
        public String body;

        @InvocableVariable(required=false description='Reference to the user, Chatter group, or record whose feed you want to post to.')
        public String targetNameOrId;

        @InvocableVariable(required=false description='List of References to the user, Chatter group, or record whose feed you want to post to.')
        public List<String> collectionTargetStrings;

        @InvocableVariable(required=false)
        public String communityId;

    }

    global class Results {

        @InvocableVariable
        public List<String> feedItemIds = new List<String>();
        @InvocableVariable
        public List<String> errors = new List<String>();
    }

    global class InvocableActionException extends Exception {
    }
}