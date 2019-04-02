global class GetDistanceBetweenCities {

    @InvocableMethod(label='Get Distance Between Cities' description='Calculates the length and duration of the travel between two cities')
    global static List<Response> GetDistanceBetweenCities(List<Request> requests) {
        List<Response> responses = new List<Response>();
        IGoogleMaps googleMaps = new GoogleMaps(new GoogleMapsAPI(false));
        for (Request request : requests) {
            Response response = GetDistanceBetweenCities.GetDistanceBetweenCitiesImpl(googleMaps, request);
            responses.add(response); 
        }
        return responses; 
    }

    public static Response GetDistanceBetweenCitiesImpl(IGoogleMaps googleMaps, Request request) {
        Response response = new Response();
        try {
            Route route = googleMaps.findRoute(request.Source, request.Destination);
            response.Source = route.source;
            response.Destination = route.destination;
            response.DistanceInMiles = route.getDistanceInMiles();
            response.DistanceInKilometers = route.getDistanceInKilometers();
            return response;            
        } 
        catch (GoogleException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }
        return response; 
    }

    global class Request {

        @InvocableVariable(required=True label='Source City' description='Name (and optionally country) of the source city')
        global String Source;

        @InvocableVariable(required=True label='Destination City' description='Name (and optionally country) of the destination city')
        global String Destination;
    }

    global class Response {

        global Response() {
            IsSuccess = true;
            ErrorMessage = '';
        }

        @InvocableVariable(label='Is Success' description='"True" if action was successful, otherwise "False"')
        global Boolean IsSuccess;

        @InvocableVariable(label='Error Message' description='Contains the description of error if action was not successfull"')
        global String ErrorMessage;

        @InvocableVariable(label='Source Location' description='The actual source location used')
        global String Source;

        @InvocableVariable(label='Destination Location' description='The actual destination location used')
        global String Destination;

        @InvocableVariable(label='Distance in Miles' description='Distance (in miles) between source and destination cities')
        global Decimal DistanceInMiles;

        @InvocableVariable(label='Distance in Kilometers' description='Distance (in kilometers) between source and destination cities')
        global Decimal DistanceInKilometers;
    }
}
