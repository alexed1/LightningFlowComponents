public class DirectionUtils {
    public static Direction parse(String value) {
        for (Direction dir: Direction.values()) {
            if (dir.name().equalsIgnoreCase(value)) {
                return dir;
            }
        }
        throw new GoogleException('"' + value + '" is not valid');
    }
}