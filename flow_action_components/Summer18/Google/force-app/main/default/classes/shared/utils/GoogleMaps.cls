public class GoogleMaps implements IGoogleMaps{
    
    private IGoogleMapsAPI googleMapsApi;

    public GoogleMaps(IGoogleMapsAPI googleMapsApi) {
        if (googleMapsApi == null) {
            throw new GoogleException('googleMapsApi can\'t be null');
        }
        this.googleMapsApi = googleMapsApi;
    }

    public Route findRoute(String source, String destination) {
        if (String.isBlank(source)) {
            throw new GoogleException('Source can\'t be empty');
        }
        if (String.isBlank(destination)) {
            throw new GoogleException('Destination can\'t be empty');
        }
        RoutesResponse response = googleMapsApi.getDistanceBetween(source, destination);
        response.throwOnError();
        if (response.origin_addresses.size() == 0) {
            throw new GoogleException(String.format('Source "{0}" was not found', new List<String> { source }));
        }
        if (response.destination_addresses.size() == 0) {
            throw new GoogleException(String.format('Destination "{0}" was not found', new List<String> { destination }));
        }
        if (response.rows.size() == 0 || response.rows[0].elements.size() == 0 || response.rows[0].elements[0].status == 'NOT_FOUND') {
            throw new GoogleException('Source and destination were found but there are no routes between them');
        }
        RoutesResponse.Element result = response.rows[0].elements[0];
        return new Route(
            response.origin_addresses[0],
            response.destination_addresses[0],
            result.distance.value);
    }
}
