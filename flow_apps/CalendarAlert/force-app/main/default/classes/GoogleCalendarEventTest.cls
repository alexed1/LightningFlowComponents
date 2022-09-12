@isTest
public with sharing class GoogleCalendarEventTest {

	@isTest
    static void canCreateGoogleCalendarEvent() {

        String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GoogleCalendarEvent googleCalEvent= new GoogleCalendarEvent();
		System.assert(googleCalEvent != null);


		System.assert(googleCalEvent.kind == null);
		System.assert(googleCalEvent.etag == null);
		System.assert(googleCalEvent.id == null);
		System.assert(googleCalEvent.status == null);
		System.assert(googleCalEvent.htmlLink == null);
		System.assert(googleCalEvent.updated == null);
		System.assert(googleCalEvent.summary == null);
		System.assert(googleCalEvent.description  == null);
		System.assert(googleCalEvent.start == null);
		System.assert(googleCalEvent.end_Z == null);
		System.assert(googleCalEvent.visibility  == null);
		System.assert(googleCalEvent.iCalUID == null);



    }
}


