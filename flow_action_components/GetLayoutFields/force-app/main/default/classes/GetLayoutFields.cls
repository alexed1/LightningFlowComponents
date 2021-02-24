public with sharing class GetLayoutFields {
    public GetLayoutFields() {

    }

    @InvocableMethod
    public static List <Results> get(List<Requests> requestList) {
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        
        for (Requests req : requestList) {
            String layoutName = req.layoutName;
            String objectName = req.objectName;
            String excludeFields = req.excludeFields;
            String layoutFieldsCSV;
            List<String> layoutFieldsCollection = new List<String>();
            List<String> lstExcludeFields = new List<String>();
            
            layoutName = objectName + '-' + layoutName;
            System.debug('Layout Name is: ' + layoutName);
            
            List<Metadata.Metadata> layouts = 
                Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                            new List<String> {layoutName});

            if (excludeFields != null && excludeFields != '') {
                
                lstExcludeFields = new List<String>();
                
                for (String fld : excludeFields.split(',')){
					lstExcludeFields.add(fld.trim());                    
                }
            }

            Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);     
            
            for (Metadata.LayoutSection section : layoutMd.layoutSections) {
                for (Metadata.LayoutColumn column : section.layoutColumns) {
                    if (column.layoutItems != null) {
                        for (Metadata.LayoutItem item : column.layoutItems) {
                                if(!lstExcludeFields.isEmpty() && !lstExcludeFields.contains(item.field)){
                                    layoutFieldsCollection.add(item.field);                                 
                                }
                        }
                    }
                }
            }
            layoutFieldsCSV = String.join(layoutFieldsCollection, ',');
            
            response.layoutFieldsCollection = layoutFieldsCollection;
            response.layoutFieldsCSV = layoutFieldsCSV;
            responseWrapper.add(response);
        }
        return responseWrapper;
    }


    public class Requests {
       
        @InvocableVariable 
        public String layoutName;

        @InvocableVariable 
        public String objectName;

        @InvocableVariable 
        public String excludeFields;

    }

    public class Results {

       
        @InvocableVariable
        public String layoutFieldsCSV;
        
        @InvocableVariable
        public List<String> layoutFieldsCollection;

    }
}