public with sharing class SlackChannelLookupController {
    public final static String CHANNEL_LIST_CACHE_KEY = 'channelList';
    public final static String USER_LIST_CACHE_KEY = 'channelList';
    @AuraEnabled
    public static List<SlackEntity> getConversations(String token){
        List<SlackEntity> channelList = new List<SlackEntity>();
        String channelListJSON = (String)Cache.Org.get(CHANNEL_LIST_CACHE_KEY);
        if(String.isNotEmpty(channelListJSON)) {
            channelList = (List<SlackEntity>)JSON.deserialize(channelListJSON, List<SlackEntity>.class);
        } else {
            GetSlackChannelList.Request request = new GetSlackChannelList.Request();
            request.token = token;

            GetSlackChannelList.Response response = GetSlackChannelList.execute(new List<GetSlackChannelList.Request> {request})[0];

            List<SlackConversation> conversationList = response.conversationList;
        
            
            for(SlackConversation conv : conversationList) {
                channelList.add(new SlackEntity(conv.id, conv.name));
            }

            Cache.Org.put(CHANNEL_LIST_CACHE_KEY, JSON.serialize(channelList), 3600);
        }

        return channelList;
    }


    @AuraEnabled
    public static List<SlackEntity> getUsers(String token){
        List<SlackEntity> userList = new List<SlackEntity>();
        String userListJSON = (String)Cache.Org.get(USER_LIST_CACHE_KEY);
        if(String.isNotEmpty(userListJSON)) {
            userList = (List<SlackEntity>)JSON.deserialize(userListJSON, List<SlackEntity>.class);
        } else {
            GetSlackUserList.Request request = new GetSlackUserList.Request();
            request.token = token;

            GetSlackUserList.Response response = GetSlackUserList.execute(new List<GetSlackUserList.Request> {request})[0];

            List<String> userIdList = response.idList;
            List<String> userNameList = response.nameList;

            for(Integer i = 0; i < userIdList.size(); i++) {
                userList.add(new SlackEntity(userIdList[i], userNameList[i]));
            }
            Cache.Org.put(USER_LIST_CACHE_KEY, JSON.serialize(userList), 3600);
        }

        
        return userList;
    }


    @AuraEnabled
    public static List<SlackEntity> getSObjects(String objectType, String valueFieldName){
        String query = 'SELECT Name, ' + valueFieldName + ' FROM ' + objectType + ' LIMIT 50000';
        List<SlackEntity> conversationList = new List<SlackEntity>();
        List<SObject> sObjectList = Database.query(query);

        for(SObject sbj : sObjectList) {
            if(sbj.get('Name') != null){
                conversationList.add(new SlackEntity((String)sbj.get(valueFieldName), (String)sbj.get('Name')));
            }
        }

        return conversationList;
   }

   public class SlackEntity {
        @AuraEnabled
        public String value;

        @AuraEnabled
        public String label;

        SlackEntity(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
}
