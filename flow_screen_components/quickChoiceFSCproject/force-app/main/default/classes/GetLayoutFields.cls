global with sharing class GetLayoutFields {
    public GetLayoutFields() {

    }

    @InvocableMethod
    global static List <Results> get(List<Requests> requestList) {
        Results response = new Results();
        String layoutName = requestList[0].layoutName;
        String objectName = requestList[0].objectName;
        String layoutFieldsCSV = '';

        layoutName = objectName + '-' + layoutName;
        List<Metadata.Metadata> layouts = 
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                        new List<String> {layoutName});

        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);

        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                            layoutFieldsCSV = layoutFieldsCSV + ',' +item.field;
                        
                            
                    }
                }
            }
        }


        response.layoutFieldsCSV = layoutFieldsCSV;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;


    }


    global class Requests {
       
        @InvocableVariable 
        public String layoutName;

        @InvocableVariable 
        public String objectName;

    }

    global class Results {

       
        @InvocableVariable
        public String layoutFieldsCSV;

    }
}







