@isTest
public with sharing class UnlockRecordTest {



    @isTest
    public static void CanUnlockRecord () {

        //create record

        Account testAct1 = new Account();
        testAct1.Name = 'testAccount1';
        insert testAct1;

        
        //lock it
        Approval.lock(testAct1.Id);

        //call UnlockRecord
        UnlockRecord.Request testReq = new UnlockRecord.Request();
        testReq.recordId = testAct1.Id;
       
        List<UnlockRecord.Request> reqList = new List<UnlockRecord.Request>();
        reqList.add(testReq);

        List<UnlockRecord.Response> unlockResponseList = UnlockRecord.Unlock(reqList);
         
        //inspect result

        System.assertEquals(unlockResponseList[0].isSuccess,true);
        System.assertEquals(Approval.isLocked(testAct1.Id), false);


    }

}
