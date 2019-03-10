public class RoutesResponse extends GoogleMapsResponse {

    public class Distance {
        
        public String text;

        public Integer value;
    }

    public class Duration {

        public String text;

        public Integer value;
    }

    public class Element {

        public RoutesResponse.Distance distance;

        public RoutesResponse.Duration duration;

        public String status;
    }

    public class Row {

        public RoutesResponse.Element[] elements;

        public Row() {
            elements = new List<RoutesResponse.Element>();
        }
    }
    
    public String[] destination_addresses;

    public String[] origin_addresses;

    public RoutesResponse.Row[] rows;

    public RoutesResponse() {
        destination_addresses = new List<String>();
        origin_addresses = new List<String>();
        rows = new List<RoutesResponse.Row>();
    }

    public static RoutesResponse parseJson(String json) {
        return (RoutesResponse) System.JSON.deserialize(json, RoutesResponse.class);
    }
}
