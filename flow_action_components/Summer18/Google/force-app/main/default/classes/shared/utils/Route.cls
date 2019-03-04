public class Route {

    public String source;

    public String destination;
    
    public Integer distance;

    public Integer duration;

    public Route(String source, String destination, Integer distance, Integer duration) {
        this.source = source;
        this.destination = destination;
        this.distance = distance;
        this.duration = duration;
    }
}
