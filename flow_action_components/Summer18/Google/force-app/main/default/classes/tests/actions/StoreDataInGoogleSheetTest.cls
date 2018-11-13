@isTest
public class StoreDataInGoogleSheetTest {

    class GoogleDriveMock implements StubProvider {

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            //Pretend that file Id equals file name requested
            if (stubbedMethodName == 'FindFileIdByName') {
                return listOfArgs[0];
            }
            if (stubbedMethodName == 'GetSpreadsheetData') {
                String fileId = listOfArgs[0].toString();
                if (fileId == 'ByAddress') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByRight') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'ByBelow') {
                    List<List<String>> result = new List<List<String>>();
                    List<String> row = new List<String>();
                    result.add(row);
                    row = new List<String>();
                    row.add('1');
                    result.add(row);
                    row = new List<String>();
                    row.add('test');
                    result.add(row);
                    return result;
                } else if (fileId == 'OutsideOfTheRange') {
                    List<List<String>> result = new List<List<String>>();
                    return result;
                }
                return null;
            }
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void StoreDataInGoogleSheet_CanStoreByAddress() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
    }

    @isTest
    public static void StoreDataInGoogleSheet_CanStoreByRight() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
    }

    @isTest
    public static void StoreDataInGoogleSheet_CanStoreByBelow() {
        IGoogleDrive drive = (IGoogleDrive)Test.createStub(IGoogleDrive.class, new GoogleDriveMock());
    }
}
