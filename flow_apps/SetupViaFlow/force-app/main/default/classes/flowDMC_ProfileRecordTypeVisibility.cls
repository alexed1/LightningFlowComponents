//notes: while perm sets only store and retrieve metadata for 'true' values, profiles store and retrieve data for both true and false rtv's

public with sharing class flowDMC_ProfileRecordTypeVisibility {
    public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';
    
    
    @AuraEnabled
    public Boolean default_x ; //'default' is used  in the metadata api but isn't allowed as a variable name in Apex. 
    @AuraEnabled
    public Boolean personAccountDefault;
    @AuraEnabled
    public String recordType ;
    @AuraEnabled
    public Boolean visible;

    private String[] default_x_type_info = new String[]{'default',SOAP_M_URI,null,'1','1','false'};
    private String[] personAccountDefault_type_info = new String[]{'personAccountDefault',SOAP_M_URI,null,'0','1','false'};
    private String[] recordType_type_info = new String[]{'recordType',SOAP_M_URI,null,'1','1','false'};
    private String[] visible_type_info = new String[]{'visible',SOAP_M_URI,null,'1','1','false'};
    private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
    private String[] field_order_type_info = new String[]{'default_x','personAccountDefault','recordType','visible'};
}
