/**
 * Class Name : HierarchyController
 * About : Controler of Hierarchy LWC
 */
public class HierarchyController {
  /**
   * Class Name : WrapperData
   * About : Structure wrapper data
   */
  public class WrapperData {
    @AuraEnabled
    public Object record;
    @AuraEnabled
    public Boolean hasChildrenContent;
    public WrapperData(Object record, Boolean hasChildrenContent) {
      this.record = record;
      this.hasChildrenContent = hasChildrenContent;
    }
  }

  /**
   * Method Name : getRecordData()
   * About : this method return wrapper of Hierarchy Data
   */
  @AuraEnabled
  public static List<WrapperData> getRecordData(
    String soql,
    String parentField,
    String recordId
  ) {
    try {
      Map<Id, WrapperData> mapOfRecord = new Map<Id, WrapperData>();
      String firstSOQL = soql, secondSOQL = soql;
      //Get the Parent Record
      firstSOQL += ' WHERE ' + parentField + ' = ' + '\'' + recordId + '\'';
      for (sObject obj : Database.query(firstSOQL)) {
        mapOfRecord.put((Id) obj.get('Id'), new WrapperData(obj, false));
      }
      Set<Id> setOfKeys = mapOfRecord.keySet();
      //Check If Parent Record has children or not
      secondSOQL += ' WHERE ' + parentField + ' IN : setOfKeys ';
      for (sObject obj : Database.query(secondSOQL)) {
        if (mapOfRecord.containsKey((Id) obj.get(parentField))) {
          mapOfRecord.get((Id) obj.get(parentField)).hasChildrenContent = true;
        }
      }
      return mapOfRecord.values();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}