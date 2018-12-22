public class SheetData {

    private List<List<String>> data;

    public SheetData(List<List<String>> data) {
        this.data = data;
        System.debug(data);
    }

    public Address findAddressByValue(String value) {
        List<Address> result = findAddressesByValue(value);
        return result.size() > 0 ? result[0] : null;
    }

    public List<Address> findAddressesByValue(String value) {
        List<Address> result = new List<Address>();
        for (CellValue cellValue: findCellsByValue(value)) {
            result.add(cellValue.addr);
        }
        return result;
    }

    public List<CellValue> findCellsByValue(String value) {
        List<CellValue> result = new List<CellValue>();
        for (Integer rowIndex = 0; rowIndex < data.size(); rowIndex++) {
            List<String> row = data[rowIndex];
            for (Integer colIndex = 0; colIndex < row.size(); colIndex++) {
                if (row[colIndex].equals(value)) {
                    result.add(new CellValue(new Address(colIndex, rowIndex), row[colIndex]));
                }
            }
        }
        return result;
    }

    public CellValue findCellByValue(String value) {
        List<CellValue> values = findCellsByValue(value);
        return values.size() > 0 ? values[0] : null;
    }

    public CellValue getValueByAddress(Address address) {    
        String value = '';    
        if (address.row >= 0 && address.row < data.size()) {
            List<String> row = data[address.row];            
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

    public CellValue locateValue(String addr, String rightOf, String belowOf) {
        if (!String.isBlank(addr)) {
            return getValueByAddress(Address.parse(addr));
        }
        if (!String.isBlank(rightOf) && !String.isBlank(belowOf)) {
            List<Address> rightAddresses = findAddressesByValue(rightOf);
            List<Address> belowAddresses = findAddressesByValue(belowOf);
            for (Address rightAddress : rightAddresses) {
                for (Address belowAddress : belowAddresses) {
                    if (belowAddress.row >= rightAddress.row || rightAddress.column >= belowAddress.column) {
                        continue;
                    }
                    return getValueByAddress(new Address(belowAddress.column, rightAddress.row));
                }
            }
        } else if (!String.isBlank(rightOf)) {
            Address rightAddress = findAddressByValue(rightOf);
            if (rightAddress != null) {
                return getValueByAddress(rightAddress.shiftRight());
            }
        } else {
            Address belowAddress = findAddressByValue(belowOf);
            if (belowAddress != null) {
                return getValueByAddress(belowAddress.shiftBelow());
            }
        }
        return null;
    }
}
