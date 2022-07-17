@isTest
public with sharing class GoogleCalendarEventTest {
	
	// This test method should give 100% coverage
	/* static testMethod void testParse() {
		String json = '{'+
		'\"kind\": \"calendar#event\",'+
		'\"etag\": \"\\\"3313395597464000\\\"\",'+
		'\"id\": \"_60q30c1g60o30e1i60o4ac1g60rj8gpl88rj2c1h84s34h9g60s30c1g60o30c1g65338e267533edpi71248e1g64o30c1g60o30c1g60o30c1g60o32c1g60o30c1g75336hi288qjcdpo8h13chhk890j2chl8ooj4cq66or38g9g6ks0\",'+
		'\"status\": \"confirmed\",'+
		'\"htmlLink\": \"https://www.google.com/calendar/event?eid=XzYwcTMwYzFnNjBvMzBlMWk2MG80YWMxZzYwcmo4Z3BsODhyajJjMWg4NHMzNGg5ZzYwczMwYzFnNjBvMzBjMWc2NTMzOGUyNjc1MzNlZHBpNzEyNDhlMWc2NG8zMGMxZzYwbzMwYzFnNjBvMzBjMWc2MG8zMmMxZzYwbzMwYzFnNzUzMzZoaTI4OHFqY2RwbzhoMTNjaGhrODkwajJjaGw4b29qNGNxNjZvcjM4ZzlnNmtzMCBhZWRlbHN0ZWluQHNhbGVzZm9yY2UuY29t\",'+
		'\"updated\": \"2022-07-01T17:49:58.732Z\",'+
		'\"start\": {'+
		'\"dateTime\": \"2022-07-01T16:30:00-07:00\",'+
		'\"timeZone\": \"America/Los_Angeles\"'+
		'},'+
		'\"end\": {'+
		'\"dateTime\": \"2022-07-01T17:00:00-07:00\",'+
		'\"timeZone\": \"America/Los_Angeles\"'+
		'},'+
		'\"visibility\": \"private\",'+
		'\"iCalUID\": \"040000008200E00074C5B7101A82E008000000001F48F9F7728DD8010000000000000000100000009F3FBB5678DB6F4BA125F123F664A058\"'+
		'}';
		GoogleCalendarEvent r = GoogleCalendarEvent.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GoogleCalendarEvent objGoogleCalendarEvent = new GoogleCalendarEvent(System.JSON.createParser(json));
		System.assert(objGoogleCalendarEvent != null);
		System.assert(objGoogleCalendarEvent.kind == null);
		System.assert(objGoogleCalendarEvent.etag == null);
		System.assert(objGoogleCalendarEvent.id == null);
		System.assert(objGoogleCalendarEvent.status == null);
		System.assert(objGoogleCalendarEvent.htmlLink == null);
		System.assert(objGoogleCalendarEvent.updated == null);
		System.assert(objGoogleCalendarEvent.start == null);
		System.assert(objGoogleCalendarEvent.end_Z == null);
		System.assert(objGoogleCalendarEvent.visibility == null);
		System.assert(objGoogleCalendarEvent.iCalUID == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GoogleCalendarEvent.Start objStart = new GoogleCalendarEvent.Start(System.JSON.createParser(json));
		System.assert(objStart != null);
		System.assert(objStart.dateTime_Z == null);
		System.assert(objStart.timeZone == null);
	} */
}
