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
            String layoutFieldsCSV = '';

            layoutName = objectName + '-' + layoutName;
            List<Metadata.Metadata> layouts = 
                Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                            new List<String> {layoutName});

            List<String> lstExcludeFields = excludeFields.split(',');

            Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
            
            
            for (Metadata.LayoutSection section : layoutMd.layoutSections) {
                for (Metadata.LayoutColumn column : section.layoutColumns) {
                    if (column.layoutItems != null) {
                        for (Metadata.LayoutItem item : column.layoutItems) {
                            if(!lstExcludeFields.contains(item.field)){
                                layoutFieldsCSV = layoutFieldsCSV + ',' +item.field;
                            }
                        }
                    }
                }
            }


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

    }
}

