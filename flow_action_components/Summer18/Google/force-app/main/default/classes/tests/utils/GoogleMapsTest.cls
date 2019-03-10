@isTest
public class GoogleMapsTest {
    
    class GoogleMapsAPIMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (stubbedMethodName.equalsIgnoreCase('getDistanceBetween')) {
                String source = listOfArgs[0].toString();
                String destination = listOfArgs[1].toString();
                if (source == 'no') {
                    RoutesResponse response = new RoutesResponse();
                    response.destination_addresses.add('destination'); 
                    return response;
                }
                if (destination == 'no') {
                    RoutesResponse response = new RoutesResponse();
                    response.origin_addresses.add('source');
                    return response;
                }                
                if (source == 'noroutes' && destination == 'noroutes') {
                    RoutesResponse response = new RoutesResponse();
                    response.origin_addresses.add('source');
                    response.destination_addresses.add('destination');
                    return response;
                }
                if (source == 'source' && destination == 'destination') {
                    RoutesResponse response = new RoutesResponse();
                    response.origin_addresses.add('source');
                    response.destination_addresses.add('destination');
                    response.rows.add(new RoutesResponse.Row());
                    response.rows[0].elements.add(new RoutesResponse.Element());
                    response.rows[0].elements[0].status = 'OK';
                    response.rows[0].elements[0].distance = new RoutesResponse.Distance();
                    response.rows[0].elements[0].distance.value = 100;
                    response.rows[0].elements[0].duration = new RoutesResponse.Duration();
                    response.rows[0].elements[0].duration.value = 200;
                    return response;
                }
            }                
            System.debug('Unknown method: ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void findRoute_SourceNotFound() {
        IGoogleMapsAPI api = (IGoogleMapsAPI)Test.createStub(IGoogleMapsAPI.class, new GoogleMapsAPIMock());
        GoogleMaps googleMaps = new GoogleMaps(api);
        try {
            Route route = googleMaps.findRoute('no', 'destination');
            System.assert(false, 'Exception was not thrown');
        }
        catch (GoogleException ex) {
            System.assertEquals('Source "no" was not found', ex.getMessage());
        }
    }

    @isTest
    public static void findRoute_DestinationNotFound() {
        IGoogleMapsAPI api = (IGoogleMapsAPI)Test.createStub(IGoogleMapsAPI.class, new GoogleMapsAPIMock());
        GoogleMaps googleMaps = new GoogleMaps(api);
        try {
            Route route = googleMaps.findRoute('source', 'no');
            System.assert(false, 'Exception was not thrown');
        }
        catch (GoogleException ex) {
            System.assertEquals('Destination "no" was not found', ex.getMessage());
        }
    }

    @isTest
    public static void findRoute_NoRoutes() {
        IGoogleMapsAPI api = (IGoogleMapsAPI)Test.createStub(IGoogleMapsAPI.class, new GoogleMapsAPIMock());
        GoogleMaps googleMaps = new GoogleMaps(api);
        try {
            Route route = googleMaps.findRoute('noroutes', 'noroutes');
            System.assert(false, 'Exception was not thrown');
        }
        catch (GoogleException ex) {
            System.assertEquals('Source and destination were found but there are no routes between them', ex.getMessage());
        }
    }

    @isTest
    public static void findRoute_RouteFound() {
        IGoogleMapsAPI api = (IGoogleMapsAPI)Test.createStub(IGoogleMapsAPI.class, new GoogleMapsAPIMock());
        GoogleMaps googleMaps = new GoogleMaps(api);
        Route route = googleMaps.findRoute('source', 'destination');
        System.assertEquals('source', route.source);
        System.assertEquals('destination', route.destination);
        System.assertEquals(100, route.distance);
    }
}
