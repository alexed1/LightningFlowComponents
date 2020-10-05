
public with sharing class flowDMC_PermissionSet {

    public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';

    
    @auraEnabled
    public String type = 'PermissionSet';
    @auraEnabled
    public String fullName;
    @auraEnabled
    public flowDMC_PermSetApplicationVisibility[] applicationVisibilities;
    @auraEnabled
    public flowDMC_PermissionSetApexClassAccess[] classAccesses;
    @auraEnabled
    public flowDMC_PermSetCustomPermissions[] customPermissions;
    @auraEnabled
    public String description;
    @auraEnabled
    public flowDMC_PermSetExternalDataSourceAccess[] externalDataSourceAccesses;
    @auraEnabled
    public flowDMC_PermSetFieldPermissions[] fieldPermissions;
    @auraEnabled
    public Boolean hasActivationRequired;
    @auraEnabled
    public String label;
    @auraEnabled
    public String license;
    @auraEnabled
    public flowDMC_PermSetObjectPermissions[] objectPermissions;
    @auraEnabled
    public flowDMC_PermSetApexPageAccess[] pageAccesses;
    @auraEnabled
    public flowDMC_PermSetRecordTypeVisibility[] recordTypeVisibilities;
    @auraEnabled
    public flowDMC_PermSetTabSetting[] tabSettings;
    @auraEnabled
    public flowDMC_PermSetUserPermission[] userPermissions;
    private String[] applicationVisibilities_type_info = new String[]{'applicationVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] classAccesses_type_info = new String[]{'classAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] customPermissions_type_info = new String[]{'customPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
    private String[] externalDataSourceAccesses_type_info = new String[]{'externalDataSourceAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] fieldPermissions_type_info = new String[]{'fieldPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] hasActivationRequired_type_info = new String[]{'hasActivationRequired',SOAP_M_URI,null,'0','1','false'};
    private String[] label_type_info = new String[]{'label',SOAP_M_URI,null,'1','1','false'};
    private String[] license_type_info = new String[]{'license',SOAP_M_URI,null,'0','1','false'};
    private String[] objectPermissions_type_info = new String[]{'objectPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] pageAccesses_type_info = new String[]{'pageAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] recordTypeVisibilities_type_info = new String[]{'recordTypeVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] tabSettings_type_info = new String[]{'tabSettings',SOAP_M_URI,null,'0','-1','false'};
    private String[] userPermissions_type_info = new String[]{'userPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
    private String[] type_att_info = new String[]{'xsi:type'};
    private String[] field_order_type_info = new String[]{'fullName', 'applicationVisibilities','classAccesses','customPermissions','description','externalDataSourceAccesses','fieldPermissions','hasActivationRequired','label','license','objectPermissions','pageAccesses','recordTypeVisibilities','tabSettings','userPermissions'};
    private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
   
}
