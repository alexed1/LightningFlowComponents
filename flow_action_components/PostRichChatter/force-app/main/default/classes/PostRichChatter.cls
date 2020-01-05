global with sharing class PostRichChatter {
  
  
    @InvocableMethod
    global static List <Results> post (List<Requests> requestList) {
        System.debug('entering PostRichChatter');
        String body = requestList[0].body;
        String targetNameOrId = requestList[0].targetNameOrId;
        String communityId = requestList[0].communityId;
        System.debug ('here are the values flow has passed');
        System.debug (requestList[0]);
        //System.debug ('targetNameOrId is: '  + targetNameOrId);
        //System.debug ('targetType is: '  + targetType);
        System.debug ('communityId is: ' + communityId);
        if (communityId == null)
            communityId = Network.getNetworkId();

        //check to see if the targetNameOrId matches a Group Name or a Username
        List<Group> targetGroup = [SELECT Id FROM Group WHERE Name =:targetNameOrId];
        System.debug('targetGroup is: ' + targetGroup);
        if (targetGroup.size() == 1) {
                        
            targetNameOrId = targetGroup[0].Id;
        } else {
            System.debug('targetNameOrId is: ' + targetNameOrId );
            List<User> targetUser = [SELECT Id FROM User WHERE username =:targetNameOrId];
            System.debug('targetUser is: ' + targetUser);
            if (targetUser.size() == 1){
                targetNameOrId = targetUser[0].Id;
            }
        }

        //several things that Flow rich text supports, like color and font size, are represented by span tags. chatter doesn't support, so need to strip them out
        Pattern MyPattern = Pattern.compile('<\\/?span[^>]*>');
        Matcher MyMatcher = MyPattern.matcher(body);
        body = MyMatcher.replaceAll('');

        //chatter's support for hyperlinks is unconventional and I haven't figured out how to convert a normal anchor link (<a href="http://www.salesforce.com" target="_blank">link</a>) into the chatter equivalent
        //so this hack puts the url into a parentheses next to the link word. anyone who has a better approach is encouraged.
        //extract the url
           //find all strings that start with <a and end with > i.e.extract url from an anchor tag
        //extract the text
        //craft a replacement string

        String anchorPattern = '(<a href="([^"]+)" target="_blank">([^<]+)<\\/a>)';
        MyPattern = Pattern.compile(anchorPattern);
        MyMatcher = MyPattern.matcher(body);
        body = MyMatcher.replaceAll('$3 ($2) ');
         System.debug ('body after replacement is: ' + body);

        //also have to strip out indent markup:
        //Here's some indented stuff:</p><p class="ql-indent-2">I'm indented</p><p>
        String indentedClassPattern = ' class="ql-indent-[1-4]"';
        MyPattern = Pattern.compile(indentedClassPattern);
        MyMatcher = MyPattern.matcher(body);
        body = MyMatcher.replaceAll('');
        System.debug ('body after replacement is: ' + body);


        //image links work fine, but we'll do a little reformatting to remove the html 
        String imagePattern = '<img src="([^"]+)">';
        MyPattern = Pattern.compile(imagePattern);
        MyMatcher = MyPattern.matcher(body);
        body = MyMatcher.replaceAll('image: $1');
        System.debug ('body after replacement is: ' + body);

        //ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), 'me', 'Hey there {005D00000015tjz}, how are you?');
        ConnectApi.FeedItem feedItem = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(communityId, targetNameOrId, body);


       
        
        //Create a Results object to hold the return values

        Results response = new Results();

        //add the return values to the Results object
        response.feedItemId = feedItem.id;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    global class Requests {
      @InvocableVariable(required=true)
      public String body;

      @InvocableVariable(required=true description='Reference to the user, Chatter group, or record whose feed you want to post to.')
      public String targetNameOrId;

     // @InvocableVariable(required=false)
      // public String targetType;

      @InvocableVariable(required=false)
      public String communityId;

        
    }
    
    global class Results {
     
      @InvocableVariable
      public String feedItemId;

    }

}