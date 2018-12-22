public class Address {

    public Integer row;

    public Integer column;

    public Address() {
        this.column = 0;
        this.row = 0;
     }

    public Address(Integer column, Integer row) {
        this.column = column;
        this.row = row;
    }

    public Integer hashCode() {
        return 10000 * column + row;
    }

    public Boolean equals(Object obj) {
        if (obj instanceof Address) {
            Address other = (Address)obj;
            return row == other.row && column == other.column;
        }
        return false;
    }

    private static Pattern columnPattern = Pattern.compile('^[A-Za-z]+');

    private static Pattern rowPattern = Pattern.compile('\\d+$');  

    private static final Integer ALPHABET_SIZE = 26;

    private static final Integer A_CHAR_CODE = 'a'.charAt(0);

    public Address shiftRight(Integer deltaColumns) {
        return new Address(column + deltaColumns, row);
    }
    
    public Address shiftRight() {
        return shiftRight(1);
    }

    public Address shiftBelow(Integer deltaRows) {
        return new Address(column, row + deltaRows);
    }

    public Address shiftBelow() {
        return shiftBelow(1);
    }

    public static Address parse(String address) {
        if (String.isBlank(address)) {
            return null;
        }
        Matcher matcher = columnPattern.matcher(address);
        String column = null;
        if (matcher.find()) {
            column = matcher.group().toLowerCase();
        }
        else {
            throw new GoogleException('Address "' + address + '" doesn\'t contain column part');
        }
        matcher = rowPattern.matcher(address);
        Integer row = null;
        if (matcher.find()) {
            row = Integer.valueOf(matcher.group()) - 1;
        }
        else {
            throw new GoogleException('Address "' + address + '" doesn\'t contain row part');
        }
        Integer parsedColumn = 0;
        for (Integer i = 0; i < column.length(); i++) {
            parsedColumn = ALPHABET_SIZE * parsedColumn + column.charAt(i) - A_CHAR_CODE + 1;        
        }
        parsedColumn--;
        Address result = new Address();
        result.row = row;
        result.column = parsedColumn;
        return result;
    }

    public override String toString() {
        String result = '';
        Integer charCode = column + 1;
        while (true) {
            if (charCode > ALPHABET_SIZE) {
                result = String.fromCharArray(new List<Integer> { Math.mod(charCode, ALPHABET_SIZE) + A_CHAR_CODE - 1 }) + result;
                charCode = charCode / ALPHABET_SIZE;
            } else {
                result = String.fromCharArray(new List<Integer> { charCode - 1 + A_CHAR_CODE }) + result;
                break;
            }
        }
        return result.toUpperCase() + (row + 1);
    }
}
