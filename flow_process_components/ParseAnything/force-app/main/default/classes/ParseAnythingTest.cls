@isTest
private class ParseAnythingTest {
    public static testMethod void TestParseText() {
        List<ParseAnything.Request> listRequest =new List<ParseAnything.Request>();
        ParseAnything.Request reqHTML = new ParseAnything.Request();
        ParseAnything.Request reqJSON = new ParseAnything.Request();
        ParseAnything.Request reqXML = new ParseAnything.Request();
        ParseAnything.Request reqSimpleText1 = new ParseAnything.Request();
        ParseAnything.Request reqSimpleText2 = new ParseAnything.Request();
        
        reqHTML.ExpectedTextTemplate = '<p>Hi <b>{?Field_1}</b>,</p><p>I checked out your website, and it looks like you might be trying to <b>{?Field_2}</b>. Without making any assumptions about your business goals, I believe <b>{?Field_3}</b> might play a pivotal role in your success.</p><p><br></p><p>If you’re unfamiliar with <b>{?Field_4}</b>, our solution helps businesses in <b>{?Field_5}</b> space with three main goals:</p><ul><li><b>{?Field_6}</b></li><li><b>{?Field_7}</b></li><li><b>{?Field_8}</b></li></ul><p>Are you free in the next few days for a call to discuss <b>{?Field_9}</b> strategy for <b>{?Field_10}</b>?</p><p>Best,</p><p><b>{?Field_11}</b></p>';
        reqHTML.ActualText = '<p>Hi <b>Munawir</b>,</p><p>I checked out your website, and it looks like you might be trying to <b>Higher Sales</b>. Without making any assumptions about your business goals, I believe <b>Salesforce Flow</b> might play a pivotal role in your success.</p><p><br></p><p>If you’re unfamiliar with <b>Salesforce</b>, our solution helps businesses in <b>YourCompany</b> space with three main goals:</p><ul><li><b>Lead Generation</b></li><li><b>Manage Cases</b></li><li><b>Automate Business Process</b></li></ul><p>Are you free in the next few days for a call to discuss <b>YourCompany</b> strategy for <b>SalesCloud</b>?</p><p>Best,</p><p><b>Anthony</b></p>';
        listRequest.add(reqHTML);
        
        reqJSON.ExpectedTextTemplate = '{"name":"{?Field_1}", "age":{?Field_2}, "city":"{?Field_3}"}';
        reqJSON.ActualText = '{"name":"John", "age":31, "city":"New York"}';
        listRequest.add(reqJSON);
        
        reqXML.ExpectedTextTemplate = '<note><to>{?Field_1}</to><from>{?Field_2}</from><heading>{?Field_3}</heading><body>{?Field_4}</body></note>';
        reqXML.ActualText = '<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Dont forget me this weekend!</body></note>';
        listRequest.add(reqXML);
        
        reqSimpleText1.ExpectedTextTemplate = '{?Field_1} likes ramen';
        reqSimpleText1.ActualText = 'Munawir likes ramen';
        listRequest.add(reqSimpleText1);
        
        reqSimpleText2.ExpectedTextTemplate = 'Munawir likes {?Field_1}';
        reqSimpleText2.ActualText = 'Munawir likes ramen';
        listRequest.add(reqSimpleText2);
        
        Test.StartTest();
        List<ParseAnything.Response> listResult = ParseAnything.Invoke(listRequest);
        Test.stopTest();
        //assertion reqHTML
        System.assertEquals('Munawir', listResult[0].Value01);
        System.assertEquals('Higher Sales', listResult[0].Value02);
        System.assertEquals('Salesforce Flow', listResult[0].Value03);
        System.assertEquals('Salesforce', listResult[0].Value04);
        System.assertEquals('YourCompany', listResult[0].Value05);
        System.assertEquals('Lead Generation', listResult[0].Value06);
        System.assertEquals('Manage Cases', listResult[0].Value07);
        System.assertEquals('Automate Business Process', listResult[0].Value08);
        System.assertEquals('YourCompany', listResult[0].Value09);
        System.assertEquals('SalesCloud', listResult[0].Value10);
        System.assertEquals('Anthony', listResult[0].Value11);
        System.assertEquals(Null, listResult[0].Value12);
        //assertion reqJSON
        System.assertEquals('John', listResult[1].Value01);
        System.assertEquals('31', listResult[1].Value02);
        System.assertEquals('New York', listResult[1].Value03);
        //assertionXML
        System.assertEquals('Tove', listResult[2].Value01);
        System.assertEquals('Jani', listResult[2].Value02);
        System.assertEquals('Reminder', listResult[2].Value03);
        System.assertEquals('Dont forget me this weekend!', listResult[2].Value04);
        //assertion SimpleText1
        System.assertEquals('Munawir', listResult[3].Value01);
        //assertion SimpleText2
        System.assertEquals('ramen', listResult[4].Value01);
    }

}