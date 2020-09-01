/**
 * @description       : 
 * @author            : Matt Comer, CapTech Consulting
 * @group             : 
 * @last modified on  : 08-30-2020
 * @last modified by  : Matt Comer, CapTech Consulting
 * Modifications Log 
 * Ver   Date         Author                               	Modification
 * 1.0   08-30-2020   Matt Comer, CapTech Consulting	 	Initial Version
**/
@IsTest
public with sharing class MassTransactorBatchHelperTest {

    public static Boolean onFinishCalled = false;

    @IsTest
    public static void testIterable() {
        Contact c1 = new Contact(LastName='Contact 1');
        Contact c2 = new Contact(LastName='Contact 2');
        List<Contact> contacts = new List<Contact>{c1, c2};
        MassTransactorBatchHelper.ListIterable itbl = new MassTransactorBatchHelper.ListIterable(contacts);
        Iterator<SObject> it = itbl.Iterator();

        System.assert(it.hasNext());
        System.assert(((Contact)it.next()).LastName == 'Contact 1');
        System.assert(it.hasNext());
        System.assert(((Contact)it.next()).LastName == 'Contact 2');
        System.assert(!it.hasNext());
    }

    @IsTest
    public static void testCallsFinishAction() {
        Contact c1 = new Contact(LastName='Contact 1');
        Contact c2 = new Contact(LastName='Contact 2');
        List<Contact> contacts = new List<Contact>{c1, c2};
        SimpleFinishAction action = new SimpleFinishAction();
        MassTransactorBatchHelper bh = new MassTransactorBatchHelper(contacts, 'create', action);
        Test.startTest();
        Database.executeBatch(bh);
        Test.stopTest();
        System.assert(onFinishCalled);
    }

    public class SimpleFinishAction implements MassTransactorBatchHelper.OnFinishAction {
        public void onFinish(Id jobId) {
            MassTransactorBatchHelperTest.onFinishCalled = true;
        }
    }

}
