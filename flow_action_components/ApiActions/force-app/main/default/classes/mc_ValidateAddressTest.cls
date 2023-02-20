@isTest
public with sharing class mc_ValidateAddressTest {
    @isTest
    public static void mc_ValidateAddressTest_Success() {
        mc_ValidateAddress.Request req = new mc_ValidateAddress.Request();
        req.street = '1600 Amphitheatre Pkwy';
        req.city = 'Mountain View';
        req.state = 'CA';
        req.country = 'US';
        req.postalCode = '94043';
        req.googleApiKey = 'AIzaSyDZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2Z';

        List<mc_ValidateAddress.Request> reqList = new list<mc_ValidateAddress.Request>();
        reqList.add(req);

        test.startTest();
        test.setMock(httpCalloutMock.class, new mockSuccess());
        List<mc_ValidateAddress.Results> res = mc_ValidateAddress.mc_ValidateAddress(reqList);

        System.assertEquals('1600 AMPHITHEATRE PKWY', res[0].results.result.uspsData.standardizedAddress.firstAddressLine);
        System.assertEquals('MOUNTAIN VIEW CA 94043-1351', res[0].results.result.uspsData.standardizedAddress.cityStateZipAddressLine);
        System.assertEquals('MOUNTAIN VIEW', res[0].results.result.uspsData.standardizedAddress.city);
        System.assertEquals('CA', res[0].results.result.uspsData.standardizedAddress.state);
        System.assertEquals('94043', res[0].results.result.uspsData.standardizedAddress.zipCode);
        System.assertEquals(37.4223878, res[0].results.result.geocode.location.latitude);
        System.assertEquals(-122.0841877, res[0].results.result.geocode.location.longitude);
        System.assertEquals(37.4220699, res[0].results.result.geocode.bounds.low.latitude);
        System.assertEquals(-122.084958, res[0].results.result.geocode.bounds.low.longitude);
        System.assertEquals(37.4226618, res[0].results.result.geocode.bounds.high.latitude);
        System.assertEquals(-122.0829302, res[0].results.result.geocode.bounds.high.longitude);
        System.assertEquals('849VCWC8+X8', res[0].results.result.geocode.plusCode.globalCode);
        System.assertEquals(0.0, res[0].results.result.geocode.featureSizeMeters);
        System.assertEquals('street_address', res[0].results.result.geocode.placeTypes[0]);
        System.assertEquals('ChIJ2eUgeAK6j4ARbn5u_wAGqWA', res[0].results.result.geocode.placeId);
        System.assertEquals('MOUNTAIN VIEW', res[0].results.result.uspsData.postOfficeCity);
        System.assertEquals('CA', res[0].results.result.uspsData.postOfficeState);
        System.assertEquals('C909', res[0].results.result.uspsData.carrierRoute);
        System.assertEquals(true, res[0].results.result.uspsData.cassProcessed);
        System.assertEquals('AABB', res[0].results.result.uspsData.dpvFootnote);
        System.assertEquals('b8b8b8b8-b8b8-b8b8-b8b8-b8b8b8b8b8b8', res[0].results.responseId);

        test.stopTest();

    }

    public class mockSuccess implements httpCalloutMock {
        public system.HttpResponse respond(system.HttpRequest req){
            httpResponse resp = new system.HttpResponse();
            resp.setStatusCode(200);
            resp.setStatus('OK');
            resp.setHeader('Content-Type', 'application/json');
            // {
            //     "result": {
            //       "geocode": {
            //         "location": {
            //           "latitude": 37.4223878,
            //           "longitude": -122.0841877
            //         },
            //         "plusCode": {
            //           "globalCode": "849VCWC8+X8"
            //         },
            //         "bounds": {
            //           "low": {
            //             "latitude": 37.4220699,
            //             "longitude": -122.084958
            //           },
            //           "high": {
            //             "latitude": 37.4226618,
            //             "longitude": -122.0829302
            //           }
            //         },
            //         "featureSizeMeters": 0.0,
            //         "placeId": "ChIJ2eUgeAK6j4ARbn5u_wAGqWA",
            //         "placeTypes": [
            //           "street_address"
            //         ]    
            //       },
            //       "uspsData": {
            //         "standardizedAddress": {
            //           "firstAddressLine": "1600 AMPHITHEATRE PKWY",
            //           "cityStateZipAddressLine": "MOUNTAIN VIEW CA 94043-1351",
            //           "city": "MOUNTAIN VIEW",
            //           "state": "CA",
            //           "zipCode": "94043",
            //           "zipCodeExtension": "1351"
            //         },
            //         "postOfficeCity": "MOUNTAIN VIEW",
            //         "postOfficeState": "CA",
            //         "carrierRoute": "C909",
            //         "cassProcessed": true,
            //         "dpvFootnote": "AABB"
            //       }
            //     },
            //     "responseId": "b8b8b8b8-b8b8-b8b8-b8b8-b8b8b8b8b8b8"
            // }
            string jsonInp = '{' + '\n';
            jsonInp += '    "result": {' + '\n';
            jsonInp += '      "geocode": {' + '\n';
            jsonInp += '        "location": {' + '\n';
            jsonInp += '          "latitude": 37.4223878,' + '\n';
            jsonInp += '          "longitude": -122.0841877' + '\n';
            jsonInp += '        },' + '\n';
            jsonInp += '        "plusCode": {' + '\n';
            jsonInp += '          "globalCode": "849VCWC8+X8"' + '\n';
            jsonInp += '        },' + '\n';
            jsonInp += '        "bounds": {' + '\n';
            jsonInp += '          "low": {' + '\n';
            jsonInp += '            "latitude": 37.4220699,' + '\n';
            jsonInp += '            "longitude": -122.084958' + '\n';
            jsonInp += '          },' + '\n';
            jsonInp += '          "high": {' + '\n';
            jsonInp += '            "latitude": 37.4226618,' + '\n';
            jsonInp += '            "longitude": -122.0829302' + '\n';
            jsonInp += '          }' + '\n';
            jsonInp += '        },' + '\n';
            jsonInp += '        "featureSizeMeters": 0.0,' + '\n';
            jsonInp += '        "placeId": "ChIJ2eUgeAK6j4ARbn5u_wAGqWA",' + '\n';
            jsonInp += '        "placeTypes": [' + '\n';
            jsonInp += '          "street_address"' + '\n';
            jsonInp += '        ]' + '\n';
            jsonInp += '      },' + '\n';
            jsonInp += '      "uspsData": {' + '\n';
            jsonInp += '        "standardizedAddress": {' + '\n';
            jsonInp += '          "firstAddressLine": "1600 AMPHITHEATRE PKWY",' + '\n';
            jsonInp += '          "cityStateZipAddressLine": "MOUNTAIN VIEW CA 94043-1351",' + '\n';
            jsonInp += '          "city": "MOUNTAIN VIEW",' + '\n';
            jsonInp += '          "state": "CA",' + '\n';
            jsonInp += '          "zipCode": "94043",' + '\n';
            jsonInp += '          "zipCodeExtension": "1351"' + '\n';
            jsonInp += '        },' + '\n';
            jsonInp += '        "postOfficeCity": "MOUNTAIN VIEW",' + '\n';
            jsonInp += '        "postOfficeState": "CA",' + '\n';
            jsonInp += '        "carrierRoute": "C909",' + '\n';
            jsonInp += '        "cassProcessed": true,' + '\n';
            jsonInp += '        "dpvFootnote": "AABB"' + '\n';
            jsonInp += '      }' + '\n';
            jsonInp += '    },' + '\n';
            jsonInp += '    "responseId": "b8b8b8b8-b8b8-b8b8-b8b8-b8b8b8b8b8b8"' + '\n';
            jsonInp += '}';
            resp.setBody(jsonInp);
            return resp;
        }
    }

    @isTest
    public static void mc_ValidateAddressTest_Fail() {
        mc_ValidateAddress.Request req = new mc_ValidateAddress.Request();
        req.street = '1600 Amphitheatre Pkwy';
        req.city = 'Mountain View';
        req.state = 'CA';
        req.country = 'US';
        req.postalCode = '94043';
        req.googleApiKey = 'AIzaSyDZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2ZqZ2Z';

        list<mc_ValidateAddress.Request> reqList = new list<mc_ValidateAddress.Request>();
        reqList.add(req);

        test.startTest();
        test.setMock(httpCalloutMock.class, new mockFail());
        mc_ValidateAddress.mc_ValidateAddress(reqList);
        test.stopTest();
    }

    public class mockFail implements httpCalloutMock {
        public system.HttpResponse respond(system.HttpRequest req){
            httpResponse resp = new system.HttpResponse();
            resp.setStatusCode(500);
            resp.setStatus('ERROR');
            resp.setHeader('Content-Type', 'application/json');
            string jsonInp = '{' + '\n';
            jsonInp += '"status": "INVALID REQUEST",' + '\n';
            jsonInp += '}';
            resp.setBody(jsonInp);
            return resp;
        }
    }
}