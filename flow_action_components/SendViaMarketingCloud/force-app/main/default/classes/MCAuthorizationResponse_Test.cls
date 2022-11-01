@isTest
public with sharing class MCAuthorizationResponse_Test {
       
        static testMethod void testParse() {
            String json = '{'+
            '    \"access_token\": \"eyJhbGciOiJIUzI1NiIsImtpZCI6IjQiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiI0WmlMaXdHODFaRWFlRnJwZVF5VVBKYmUiLCJjbGllbnRfaWQiOiJjaXhlMTl3OWJqM3dhdGcydTh6ZnRtbzEiLCJlaWQiOjEzNjMwODYsInN0YWNrX2tleSI6IlM0IiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciIsInBpZCI6MjE4fQ.BnkxneTgUY6y_513POtA-r089SELxP9y7DiT6zmIt0g.JxldyITej3mV9ZbBcRhDmT3op9lyWCdvMBDh_Jl-SF7Izz9pCs4zav4vuJDLHsNlAr5_vbwOCs7x7pdz_ZPgFq04-KLZ2Y9vtT3aQp-XoxFNe_nb_ouiusVxeBs2v21rT6LikyYgjCkvEAd_M8cuWUuGJYGZBRcilT3dZ2BzO\",'+
            '    \"token_type\": \"Bearer\",'+
            '    \"expires_in\": 1080,'+
            '    \"scope\": \"email_read email_write email_send\",'+
            '    \"soap_instance_url\": \"https://mcgs269vcy2ztdsfpt5bjwv1mfl1.soap.marketingcloudapis.com/\",'+
            '    \"rest_instance_url\": \"https://mcgs269vcy2ztdsfpt5bjwv1mfl1.rest.marketingcloudapis.com/\"'+
            '}';
            MCAuthorizationResponse obj = MCAuthorizationResponse.parse(json);
            System.assert(obj != null);
        }
    }
