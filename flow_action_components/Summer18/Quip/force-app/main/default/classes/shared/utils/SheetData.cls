public class SheetData {

    private List<List<String>> data;

    public SheetData(List<List<String>> data) {
        this.data = data;
        System.debug(data);
    }

    public Address findAddressByValue(String value) {
        CellValue cell = findCellByValue(value);
        if (cell == null) {
            return null;
        }
        return cell.addr;
    }

    public CellValue findCellByValue(String value) {
        for (Integer rowIndex = 0; rowIndex < data.size(); rowIndex++) {
            List<String> row = data[rowIndex];
            for (Integer colIndex = 0; colIndex < row.size(); colIndex++) {
                if (row[colIndex].equalsIgnoreCase(value)) {
                    System.debug('Value "' + value + '" was found at ' + new Address(colIndex, rowIndex));
                    return new CellValue(new Address(colIndex, rowIndex), row[colIndex]);
                }
            }
        }
        System.debug('Value "' + value + '" was not found');
        return null;
    }

    public CellValue getValueByAddress(Address address) {    
        String value = ''; 
        System.debug('Looking for value at ' + address.toString());
        System.debug('Row: ' + String.valueOf(address.row));
        System.debug('Col: ' + String.valueOf(address.column));   
        if (address.row >= 0 && address.row < data.size()) {
            List<String> row = data[address.row];     
            System.debug('Row is ' + String.valueOf(row));      
            if (address.column >= 0 && address.column < row.size()) {
                value = row[address.column];
            } else {
                System.debug('Address column ' + address.column + ' is outside of the data');
            }
        } else {
            System.debug('Address row ' + address.row + ' is outside of the data');
        }
        return new CellValue(address, value);
    }
}