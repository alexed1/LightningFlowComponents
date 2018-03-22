global with sharing class PopulatePicklist {
    @AuraEnabled
    global static list<Map<string, string>> getPicklistValues(string obj, String fld){
        
        list<Map<string, string>> options = new list<Map<string, string>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(obj);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            Map<string, string> newOptions = new Map<string, string>{};
              newOptions.put('value', a.getValue());
              newOptions.put('label', a.getLabel());
            options.add(newOptions); 
        }
        
        return options;
    }
}
