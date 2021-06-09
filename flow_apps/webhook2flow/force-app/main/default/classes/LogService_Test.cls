/**
 * @description       : 
 * @author            : Tom Snyder <tom@3ddd.com>
 * @group             : 
 * @last modified on  : 2021-05-06
 * @last modified by  : Tom Snyder <tom@3ddd.com>
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   2020-12-07   Tom Snyder <tom@3ddd.com>   Initial Version
**/
@isTest
private class LogService_Test {


	static testMethod void test_SimpleMessageLog() {

		LogService.addMessage('UT', 'hello');
		LogService.save();


		LIST<LogService__c> ltests = [Select Type__c, Source__c, Message__c from LogService__c];
		system.assert(ltests.size()==1, 'Exactly 1 log record should be created.');
		LogService__c ltest = ltests[0];
		system.assert(ltest.Source__c=='UT', 'Confirm Source__c is mapped properly');
		system.assert(ltest.Message__c=='hello',  'Confirm Message__c is mapped properly');
	}

	static testMethod void test_SimpleExceptionLog() {

		LogService.addException(new LogService.LogException('Oops',new LogService.LogException('Ouch!')));
		LogService.save();

		LIST<LogService__c> ltests = [Select Type__c, Source__c, ErrorMessage__c from LogService__c];
		system.assert(ltests.size()==1, 'Exactly 1 log record should be created.');
		LogService__c ltest = ltests[0];
		system.debug(ltest);
		system.assert(ltest.Type__c=='Exception', 'Confirm Source__c is mapped properly');
		system.assert(ltest.ErrorMessage__c.contains('Oops') && ltest.ErrorMessage__c.contains('Ouch!'),  'Confirm ErrorMessage__c is contains message and cause');
	}



	static testMethod void test_CalloutSuccess() {


		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://unitTestRUs.com/service');
		request.setHeader('content-type', 'application/json');
		request.setMethod('POST');
		request.setBody('{"param1":"foo"}');

		Test.setMock(HttpCalloutMock.class, new Mock());

		Test.startTest();

		//simulate a success callout
		LogService log = new LogService('UT', request);
		log.appendMessage('Unit Test a callout');
		try {
			Http http = new Http();
			HttpResponse resp = http.send(request);
			log.append(resp);
		}
		catch(exception ex) {
			log.append(ex);
		}
		finally {
			LogService.addLog(log);
		}
		LogService.save();

		Test.stopTest();

		LIST<LogService__c> ltests = [Select Type__c, Source__c, Request__c, RequestHeaders__c, RequestUri__c, 
			Response__c, ResponseHeaders__c, StatusCode__c, HttpMethod__c, Host__c, ErrorMessage__c  from LogService__c];
		system.assert(ltests.size()==1, 'Exactly 1 log record should be created.');
		LogService__c ltest = ltests[0];
		system.debug(ltest);
		system.assertEquals('https://unitTestRUs.com/service',ltest.RequestURI__c, 'Confirm Host__c is mapped properly');
		system.assertEquals('unittestrus.com', ltest.Host__c, 'Confirm Host__c is mapped properly');
		system.assertEquals('POST',ltest.HttpMethod__c, 'Confirm HttpMethod__c is mapped properly');
		system.assertEquals('{"param1":"foo"}',ltest.Request__c, 'Confirm Request__c is mapped properly');
		system.assertEquals('{"answer":"bar"}',ltest.Response__c, 'Confirm Response__c is mapped properly');
		system.assertEquals(200,ltest.StatusCode__c, 'Confirm StatusCode__c is mapped properly');
		system.assertEquals(null,ltest.ErrorMessage__c, 'Confirm ErrorMessage__c is null');
		
		//system.assert(ltest.ErrorMessage__c.contains('Oops') && ltest.ErrorMessage__c.contains('Ouch!'),  'Confirm ErrorMessage__c is contains message and cause');



	}

	static testMethod void coverage() {	
		LogService l= new LogService();
		l.logType='Callout'; 
		l.message='MSG';
		l.source='UT';
		l.severity='ERROR';	
		l.host='callout:service_org';
		l.request='HTTP request BODY';
		l.response='HTTP response BODY';
		l.append(new HttpRequest());
		l.append(new LogService.LogException('Error1'));
		l.append(new LogService.LogException('Error2'));
		l.appendMessage('Message1');
		l.appendMessage('Message2');
		LogService.addLog(l);
		LogService l2= new LogService('UT', new System.RestRequest());
		LogService.addLog(l2);
		LogService.save();
    }

    static testMethod void testPlatformEventSave() {

        Test.startTest();
        // Create a test event instance
        string msg = 'this is a response from a callout...'; 
		LogService.addMessage('UT',msg);
		System.assert(LogService.queue.size()>0);
		LogService.ImmediateSave();  
		Test.getEventBus().deliver(); 
		Test.stopTest();

		System.assertEquals(msg, [Select source__c, Message__c from LogService__c][0].Message__c,'Log record should exist.');
        
		
    }

	private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"answer":"bar"}');
			res.setHeader('content-type', 'application/json');
            res.setStatusCode(200);
            return res;
        }
    }
    

    static testMethod void testPlatformEvent_InvalidType() {

		//Log PlatformEvent (used to save a serialized log async) will also create a log if an error occurs.

        Test.startTest();
		LogServiceEvent__e[] evnts = new LogServiceEvent__e[]{};
		evnts.add(new LogServiceEvent__e(Type__c='UT_Type', body__c='{}'));
		EventBus.publish(evnts);
		Test.getEventBus().deliver(); 
		Test.stopTest();

		LIST<LogService__c> ltests = [Select Type__c, Source__c, ErrorMessage__c from LogService__c];
		system.assert(ltests.size()==1, 'Exactly 1 log record should be created.');
		LogService__c ltest = ltests[0];
		system.debug(ltest);
		//system.assert(ltest.Type__c=='Exception', 'Confirm Source__c is mapped properly');
		system.assert(ltest.ErrorMessage__c.contains('INVALID_TYPE'),  'Confirm ErrorMessage__c is contains message');
    }


	static testMethod void testPlatformEvent_BadJson() {

		//Log PlatformEvent (used to save a serialized log async) will also create a log if an error occurs.

        Test.startTest();
		LogServiceEvent__e[] evnts = new LogServiceEvent__e[]{};
		evnts.add(new LogServiceEvent__e(Type__c='AddLog', body__c='{"bad: JSON"}'));
		EventBus.publish(evnts);
		Test.getEventBus().deliver(); 
		Test.stopTest();

		LIST<LogService__c> ltests = [Select Type__c, Source__c, ErrorMessage__c from LogService__c];
		system.assert(ltests.size()==1, 'Exactly 1 log record should be created.');
		LogService__c ltest = ltests[0];
		system.debug(ltest);
		//system.assert(ltest.Type__c=='Exception', 'Confirm Source__c is mapped properly');
		system.assert(ltest.ErrorMessage__c.contains('Malformed JSON'),  'Confirm ErrorMessage__c');
    }


    /*
        static testMethod void testExceptionLog() {
		
		 Test.startTest();
		
		try {
	       decimal divBy0 = 1/0;	
		} catch (Exception ex) {
			LogService.addException(ex);
			LogService.save();
			system.debug('getLineNumber: '+ex.getLineNumber());
			system.debug('getCause: '+ex.getCause());
			system.debug('getMessage: '+ex.getMessage());
			system.debug('getStackTraceString: '+ex.getStackTraceString());
			system.debug('getTypeName: '+ex.getTypeName());
			LogService__c l = [Select type__c, Message__c from LogService__c];
			System.assertEquals('Exception', l.Type__c); 
			System.assertEquals('Divide by 0', l.Message__c);  
		}			

        Test.stopTest();

    }
	*/
}