@isTest
public with sharing class SlackChannelLookupControllerTest {
    @isTest
    static void getConversationsTest() {
        String token = 'test token';
        List<SlackChannelLookupController.SlackEntity> channelList = SlackChannelLookupController.getConversations(token);
        System.assert(channelList.size() > 0);

        channelList = SlackChannelLookupController.getConversations(token);
        System.assert(channelList.size() > 0);
    }

    @isTest
    static void getUsersTest() {
        String token = 'test token';
        List<SlackChannelLookupController.SlackEntity> channelList = SlackChannelLookupController.getUsers(token);
        System.assert(channelList.size() > 0);

        channelList = SlackChannelLookupController.getUsers(token);
        System.assert(channelList.size() > 0);
    }

    @isTest
    static void getSObjectTest() {
        String token = 'test token';

        Account newAcc = new Account(Name = 'Test Account', AccountNumber = 'W012A3CDE');
        insert newAcc;

        List<SlackChannelLookupController.SlackEntity> sobjectList = SlackChannelLookupController.getSObjects('Account', 'AccountNumber');

        System.assert(sobjectList.size() > 0);
        System.assertEquals(sobjectList[0].value, newAcc.AccountNumber);
        System.assertEquals(sobjectList[0].label, newAcc.Name);
       
    }


}
