@isTest
public with sharing class GoogleCalendarEventSetTest {

    @isTest
    static void canCreateGoogleCalendarEventSet() {

        String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GoogleCalendarEventSet googleCalEventSet= new GoogleCalendarEventSet();
		System.assert(googleCalEventSet != null);
		//System.assert(googleCalEventSet.stationContributions == null);
		//System.assert(googleCalEventSet.values == null);
		System.assert(googleCalEventSet.kind == null);
		System.assert(googleCalEventSet.etag == null);
		System.assert(googleCalEventSet.summary == null);
		System.assert(googleCalEventSet.updated == null);
		System.assert(googleCalEventSet.timeZone == null);
		System.assert(googleCalEventSet.accessRole == null);
		System.assert(googleCalEventSet.defaultReminders == null);
		System.assert(googleCalEventSet.nextPageToken  == null);
		System.assert(googleCalEventSet.items == null);

		//System.assert(googleCalEventSet.alerts == null);

    }
}
