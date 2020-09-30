public  with sharing class flowDMC_PermSetRecordTypeVisibility {
    public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';
    
    @auraEnabled
    public String recordType;
    @auraEnabled
    public Boolean visible;
    

    private String[] recordType_type_info = new String[]{'recordType',SOAP_M_URI,null,'1','1','false'};
    private String[] visible_type_info = new String[]{'visible',SOAP_M_URI,null,'1','1','false'};
    private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
    private String[] field_order_type_info = new String[]{'recordType','visible'};
}
