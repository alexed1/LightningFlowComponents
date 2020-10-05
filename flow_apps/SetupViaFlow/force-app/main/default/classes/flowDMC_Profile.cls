public with sharing class flowDMC_Profile {


    public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';

    
    @auraEnabled
    public String type = 'Profile';
    @auraEnabled
    public String fullName;
    @auraEnabled
    public flowDMC_ProfileApplicationVisibility[] applicationVisibilities;
    @auraEnabled
    public flowDMC_ProfileCategoryGroupVisibility[] categoryGroupVisibilities;
    @auraEnabled
    public flowDMC_ProfileApexClassAccess[] classAccesses;
    @auraEnabled
    public Boolean custom;
    @auraEnabled
    public flowDMC_ProfileCustomPermissions[] customPermissions;
    @auraEnabled
    public String description;
    @auraEnabled
    public flowDMC_ProfileExternalDataSourceAccess[] externalDataSourceAccesses;
    @auraEnabled
    public flowDMC_ProfileFieldLevelSecurity[] fieldPermissions;
    @auraEnabled
    public flowDMC_ProfileLayoutAssignments[] layoutAssignments;
    @auraEnabled
    public flowDMC_ProfileLoginHours[]  loginHours;
    @auraEnabled
    public flowDMC_ProfileLoginIpRange[]  loginIpRanges;
    @auraEnabled
    public flowDMC_ProfileObjectPermissions[] objectPermissions;
    @auraEnabled
    public flowDMC_ProfileApexPageAccess[] pageAccesses;
    @auraEnabled
    public flowDMC_ProfileActionOverride[] profileActionOverrides;
    @auraEnabled
    public flowDMC_ProfileRecordTypeVisibility[] recordTypeVisibilities;
    @auraEnabled
    public flowDMC_ProfileTabVisibility[] tabVisibilities;
    @auraEnabled
    public String userLicense;
    @auraEnabled
    public flowDMC_ProfileUserPermission[] userPermissions;
    private String[] applicationVisibilities_type_info = new String[]{'applicationVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] categoryGroupVisibilities_type_info = new String[]{'categoryGroupVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] classAccesses_type_info = new String[]{'classAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] custom_type_info = new String[]{'custom',SOAP_M_URI,null,'0','1','false'};
    private String[] customPermissions_type_info = new String[]{'customPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
    private String[] externalDataSourceAccesses_type_info = new String[]{'externalDataSourceAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] fieldPermissions_type_info = new String[]{'fieldPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] layoutAssignments_type_info = new String[]{'layoutAssignments',SOAP_M_URI,null,'0','-1','false'};
    private String[] loginHours_type_info = new String[]{'loginHours',SOAP_M_URI,null,'0','1','false'};
    private String[] loginIpRanges_type_info = new String[]{'loginIpRanges',SOAP_M_URI,null,'0','-1','false'};
    private String[] objectPermissions_type_info = new String[]{'objectPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] pageAccesses_type_info = new String[]{'pageAccesses',SOAP_M_URI,null,'0','-1','false'};
    private String[] profileActionOverrides_type_info = new String[]{'profileActionOverrides',SOAP_M_URI,null,'0','-1','false'};
    private String[] recordTypeVisibilities_type_info = new String[]{'recordTypeVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] tabVisibilities_type_info = new String[]{'tabVisibilities',SOAP_M_URI,null,'0','-1','false'};
    private String[] userLicense_type_info = new String[]{'userLicense',SOAP_M_URI,null,'0','1','false'};
    private String[] userPermissions_type_info = new String[]{'userPermissions',SOAP_M_URI,null,'0','-1','false'};
    private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
    private String[] type_att_info = new String[]{'xsi:type'};
    private String[] field_order_type_info = new String[]{'fullName', 'applicationVisibilities','categoryGroupVisibilities','classAccesses','custom','customPermissions','description','externalDataSourceAccesses','fieldPermissions','layoutAssignments','loginHours','loginIpRanges','objectPermissions','pageAccesses','profileActionOverrides','recordTypeVisibilities','tabVisibilities','userLicense','userPermissions'};
    private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
   
}


