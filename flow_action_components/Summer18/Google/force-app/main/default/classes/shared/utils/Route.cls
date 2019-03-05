public class Route {

    public static final Decimal METERS_PER_MILE = 1609.344;

    public static final Decimal METERS_PER_KILOMETER = 1000;

    public static final Integer SCALE = 1000;

    public String source;

    public String destination;
    
    public Decimal distance;

    public Route(String source, String destination, Decimal distance) {
        this.source = source;
        this.destination = destination;
        this.distance = distance;
    }

    public Decimal getDistanceInMiles() {
        Decimal result = SCALE * distance / METERS_PER_MILE;
        result = (Decimal)result.round(System.RoundingMode.HALF_UP) / SCALE;
        return result;
    }

    public Decimal getDistanceInKilometers() {
        Decimal result = SCALE * distance / METERS_PER_KILOMETER;
        result = (Decimal)result.round(System.RoundingMode.HALF_UP) / SCALE;
        return result;
    }
}
