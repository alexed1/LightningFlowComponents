@isTest
public class GetDistanceBetweenCitiesTest {

    class GoogleMapsMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName.equalsIgnoreCase('findRoute')) {
                String source = listOfArgs[0].toString();
                if (source == 'source') {
                    return new Route('source', 'destination', 1609.344);
                }
                throw new GoogleException('No route');
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void getDistanceBetweenCities_ReturnsRoute() {
        IGoogleMaps googleMaps = (IGoogleMaps)Test.createStub(IGoogleMaps.class, new GoogleMapsMock());
        GetDistanceBetweenCities.Request request = new GetDistanceBetweenCities.Request();
        request.Source = 'source';
        request.Destination = 'destination';
        GetDistanceBetweenCities.Response response = GetDistanceBetweenCities.GetDistanceBetweenCitiesImpl(googleMaps, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        System.assertEquals('source', response.Source);
        System.assertEquals('destination', response.Destination);
        System.assertEquals(1, response.DistanceInMiles);
        System.assertEquals(1.609, response.DistanceInKilometers);
    }

    @isTest
    public static void getDistanceBetweenCities_WhenRouteDoesntExist_Fails() {
        IGoogleMaps googleMaps = (IGoogleMaps)Test.createStub(IGoogleMaps.class, new GoogleMapsMock());
        GetDistanceBetweenCities.Request request = new GetDistanceBetweenCities.Request();
        request.Source = 'unknown';
        request.Destination = 'unknown';
        GetDistanceBetweenCities.Response response = GetDistanceBetweenCities.GetDistanceBetweenCitiesImpl(googleMaps, request);
        System.assert(!response.IsSuccess);
        System.assertEquals('No route', response.ErrorMessage);
    }

    @isTest
    public static void getDistanceBetweenCities_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GetDistanceBetweenCities.Request request = new GetDistanceBetweenCities.Request();
        request.Source = 'test';
        request.Destination = 'test';
        List<GetDistanceBetweenCities.Request> requests = new List<GetDistanceBetweenCities.Request> { request };
        List<GetDistanceBetweenCities.Response> responses = GetDistanceBetweenCities.GetDistanceBetweenCities(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
    }
}