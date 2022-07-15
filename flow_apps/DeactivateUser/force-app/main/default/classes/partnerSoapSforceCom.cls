

public class partnerSoapSforceCom {

    public class sObject_x {
        public String type_x;
        public String[] fieldsToNull;
        public String Id;

        private String[] type_x_type_info = new String[]{'type','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:sobject.partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fieldsToNull','Id'};
    }

    public class InvalidateSessionsResult {
        public partnerSoapSforceCom.Error[] errors;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','success'};
    }
    public class describePrimaryCompactLayoutsResponse_element {
        public partnerSoapSforceCom.DescribeCompactLayout[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class changeOwnPassword_element {
        public String oldPassword;
        public String newPassword;
        private String[] oldPassword_type_info = new String[]{'oldPassword','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] newPassword_type_info = new String[]{'newPassword','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'oldPassword','newPassword'};
    }
    public class DescribeAppMenuResult {
        public partnerSoapSforceCom.DescribeAppMenuItem[] appMenuItems;
        private String[] appMenuItems_type_info = new String[]{'appMenuItems','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'appMenuItems'};
    }
    public class DescribeColor {
        public String color;
        public String context;
        public String theme;
        private String[] color_type_info = new String[]{'color','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] context_type_info = new String[]{'context','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] theme_type_info = new String[]{'theme','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'color','context','theme'};
    }
    public class MergeResult {
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public String[] mergedRecordIds;
        public Boolean success;
        public String[] updatedRelatedIds;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] mergedRecordIds_type_info = new String[]{'mergedRecordIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] updatedRelatedIds_type_info = new String[]{'updatedRelatedIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','id','mergedRecordIds','success','updatedRelatedIds'};
    }
    public class describeDataCategoryGroupStructures_element {
        public partnerSoapSforceCom.DataCategoryGroupSobjectTypePair[] pairs;
        public Boolean topCategoriesOnly;
        private String[] pairs_type_info = new String[]{'pairs','urn:partner.soap.sforce.com',null,'0','100','false'};
        private String[] topCategoriesOnly_type_info = new String[]{'topCategoriesOnly','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'pairs','topCategoriesOnly'};
    }
    public class queryResponse_element {
        public partnerSoapSforceCom.QueryResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class CallOptions_element {
        public String client;
        public String defaultNamespace;
        private String[] client_type_info = new String[]{'client','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] defaultNamespace_type_info = new String[]{'defaultNamespace','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'client','defaultNamespace'};
    }
    public class SaveResult {
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','id','success'};
    }
    public class describeDataCategoryGroups_element {
        public String[] sObjectType;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType'};
    }
    public class ExtendedErrorDetails {
        public String extendedErrorCode;
        private String[] extendedErrorCode_type_info = new String[]{'extendedErrorCode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorCode'};
    }
    public class upsert_element {
        public String externalIDFieldName;
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] externalIDFieldName_type_info = new String[]{'externalIDFieldName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'externalIDFieldName','sObjects'};
    }
    public class updateResponse_element {
        public partnerSoapSforceCom.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class MergeRequest {
        public partnerSoapSforceCom.AdditionalInformationMap[] additionalInformationMap;
        public partnerSoapSforceCom.sObject_x masterRecord;
        public String[] recordToMergeIds;
        private String[] additionalInformationMap_type_info = new String[]{'additionalInformationMap','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] masterRecord_type_info = new String[]{'masterRecord','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordToMergeIds_type_info = new String[]{'recordToMergeIds','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'additionalInformationMap','masterRecord','recordToMergeIds'};
    }
    public class RecordTypeInfo {
        public Boolean active;
        public Boolean available;
        public Boolean defaultRecordTypeMapping;
        public String developerName;
        public Boolean master;
        public String name;
        public String recordTypeId;
        private String[] active_type_info = new String[]{'active','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] available_type_info = new String[]{'available','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] defaultRecordTypeMapping_type_info = new String[]{'defaultRecordTypeMapping','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] master_type_info = new String[]{'master','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','available','defaultRecordTypeMapping','developerName','master','name','recordTypeId'};
    }
    public class sendEmailResponse_element {
        public partnerSoapSforceCom.SendEmailResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeRelatedContentItem {
        public partnerSoapSforceCom.DescribeLayoutItem describeLayoutItem;
        private String[] describeLayoutItem_type_info = new String[]{'describeLayoutItem','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'describeLayoutItem'};
    }
    public class describeSObjectsResponse_element {
        public partnerSoapSforceCom.DescribeSObjectResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','100','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeQuickActionResult {
        public String accessLevelRequired;
        public String actionEnumOrId;
        public String canvasApplicationId;
        public String canvasApplicationName;
        public partnerSoapSforceCom.DescribeColor[] colors;
        public String contextSobjectType;
        public partnerSoapSforceCom.DescribeQuickActionDefaultValue[] defaultValues;
        public String flowDevName;
        public String flowRecordIdVar;
        public Integer height;
        public String iconName;
        public String iconUrl;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String label;
        public partnerSoapSforceCom.DescribeLayoutSection layout;
        public String lightningComponentBundleId;
        public String lightningComponentBundleName;
        public String lightningComponentQualifiedName;
        public String lightningWebComponentBundleId;
        public String lightningWebComponentBundleName;
        public String lightningWebComponentQualifiedName;
        public String miniIconUrl;
        public String mobileExtensionId;
        public String name;
        public Boolean showQuickActionLcHeader;
        public Boolean showQuickActionVfHeader;
        public String targetParentField;
        public String targetRecordTypeId;
        public String targetSobjectType;
        public String type_x;
        public String visualforcePageName;
        public String visualforcePageUrl;
        public Integer width;
        private String[] accessLevelRequired_type_info = new String[]{'accessLevelRequired','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] actionEnumOrId_type_info = new String[]{'actionEnumOrId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] canvasApplicationId_type_info = new String[]{'canvasApplicationId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] canvasApplicationName_type_info = new String[]{'canvasApplicationName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] contextSobjectType_type_info = new String[]{'contextSobjectType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] defaultValues_type_info = new String[]{'defaultValues','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] flowDevName_type_info = new String[]{'flowDevName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] flowRecordIdVar_type_info = new String[]{'flowRecordIdVar','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] height_type_info = new String[]{'height','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] iconName_type_info = new String[]{'iconName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] iconUrl_type_info = new String[]{'iconUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layout_type_info = new String[]{'layout','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningComponentBundleId_type_info = new String[]{'lightningComponentBundleId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningComponentBundleName_type_info = new String[]{'lightningComponentBundleName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningComponentQualifiedName_type_info = new String[]{'lightningComponentQualifiedName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningWebComponentBundleId_type_info = new String[]{'lightningWebComponentBundleId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningWebComponentBundleName_type_info = new String[]{'lightningWebComponentBundleName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] lightningWebComponentQualifiedName_type_info = new String[]{'lightningWebComponentQualifiedName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] miniIconUrl_type_info = new String[]{'miniIconUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] mobileExtensionId_type_info = new String[]{'mobileExtensionId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showQuickActionLcHeader_type_info = new String[]{'showQuickActionLcHeader','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showQuickActionVfHeader_type_info = new String[]{'showQuickActionVfHeader','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] targetParentField_type_info = new String[]{'targetParentField','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] targetRecordTypeId_type_info = new String[]{'targetRecordTypeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] targetSobjectType_type_info = new String[]{'targetSobjectType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] visualforcePageName_type_info = new String[]{'visualforcePageName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] visualforcePageUrl_type_info = new String[]{'visualforcePageUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] width_type_info = new String[]{'width','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevelRequired','actionEnumOrId','canvasApplicationId','canvasApplicationName','colors','contextSobjectType','defaultValues','flowDevName','flowRecordIdVar','height','iconName','iconUrl','icons','label','layout','lightningComponentBundleId','lightningComponentBundleName','lightningComponentQualifiedName','lightningWebComponentBundleId','lightningWebComponentBundleName','lightningWebComponentQualifiedName','miniIconUrl','mobileExtensionId','name','showQuickActionLcHeader','showQuickActionVfHeader','targetParentField','targetRecordTypeId','targetSobjectType','type_x','visualforcePageName','visualforcePageUrl','width'};
    }
    public class JunctionIdListNames {
        public String[] names;
        private String[] names_type_info = new String[]{'names','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'names'};
    }
    public class UpsertResult {
        public Boolean created;
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public Boolean success;
        private String[] created_type_info = new String[]{'created','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'created','errors','id','success'};
    }
    public class deleteByExampleResponse_element {
        public partnerSoapSforceCom.DeleteByExampleResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeQuickActionsResponse_element {
        public partnerSoapSforceCom.DescribeQuickActionResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class LeadConvert {
        public String accountId;
        public partnerSoapSforceCom.sObject_x accountRecord;
        public Boolean bypassAccountDedupeCheck;
        public Boolean bypassContactDedupeCheck;
        public String contactId;
        public partnerSoapSforceCom.sObject_x contactRecord;
        public String convertedStatus;
        public Boolean doNotCreateOpportunity;
        public String leadId;
        public String opportunityId;
        public String opportunityName;
        public partnerSoapSforceCom.sObject_x opportunityRecord;
        public Boolean overwriteLeadSource;
        public String ownerId;
        public String relatedPersonAccountId;
        public partnerSoapSforceCom.sObject_x relatedPersonAccountRecord;
        public Boolean sendNotificationEmail;
        private String[] accountId_type_info = new String[]{'accountId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] accountRecord_type_info = new String[]{'accountRecord','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] bypassAccountDedupeCheck_type_info = new String[]{'bypassAccountDedupeCheck','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] bypassContactDedupeCheck_type_info = new String[]{'bypassContactDedupeCheck','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] contactId_type_info = new String[]{'contactId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] contactRecord_type_info = new String[]{'contactRecord','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] convertedStatus_type_info = new String[]{'convertedStatus','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] doNotCreateOpportunity_type_info = new String[]{'doNotCreateOpportunity','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] leadId_type_info = new String[]{'leadId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] opportunityId_type_info = new String[]{'opportunityId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] opportunityName_type_info = new String[]{'opportunityName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] opportunityRecord_type_info = new String[]{'opportunityRecord','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] overwriteLeadSource_type_info = new String[]{'overwriteLeadSource','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] ownerId_type_info = new String[]{'ownerId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] relatedPersonAccountId_type_info = new String[]{'relatedPersonAccountId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] relatedPersonAccountRecord_type_info = new String[]{'relatedPersonAccountRecord','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sendNotificationEmail_type_info = new String[]{'sendNotificationEmail','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accountId','accountRecord','bypassAccountDedupeCheck','bypassContactDedupeCheck','contactId','contactRecord','convertedStatus','doNotCreateOpportunity','leadId','opportunityId','opportunityName','opportunityRecord','overwriteLeadSource','ownerId','relatedPersonAccountId','relatedPersonAccountRecord','sendNotificationEmail'};
    }
    public class RenderEmailTemplateError {
        public String fieldName;
        public String message;
        public Integer offset;
        public String statusCode;
        private String[] fieldName_type_info = new String[]{'fieldName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] offset_type_info = new String[]{'offset','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldName','message','offset','statusCode'};
    }
    public class DescribeAvailableQuickActionResult {
        public String actionEnumOrId;
        public String label;
        public String name;
        public String type_x;
        private String[] actionEnumOrId_type_info = new String[]{'actionEnumOrId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actionEnumOrId','label','name','type_x'};
    }
    public class EmptyRecycleBinResult {
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','id','success'};
    }
    public class RenderStoredEmailTemplateRequest {
        public String attachmentRetrievalOption;
        public String templateId;
        public Boolean updateTemplateUsage;
        public String whatId;
        public String whoId;
        private String[] attachmentRetrievalOption_type_info = new String[]{'attachmentRetrievalOption','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] templateId_type_info = new String[]{'templateId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] updateTemplateUsage_type_info = new String[]{'updateTemplateUsage','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] whatId_type_info = new String[]{'whatId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] whoId_type_info = new String[]{'whoId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'attachmentRetrievalOption','templateId','updateTemplateUsage','whatId','whoId'};
    }
    public class SingleEmailMessage {
        public String[] bccAddresses;
        public String[] ccAddresses;
        public String charset;
        public String[] documentAttachments;
        public String[] entityAttachments;
        public partnerSoapSforceCom.EmailFileAttachment[] fileAttachments;
        public String htmlBody;
        public String inReplyTo;
        public String optOutPolicy;
        public String orgWideEmailAddressId;
        public String plainTextBody;
        public String references;
        public String targetObjectId;
        public String templateId;
        public String templateName;
        public String[] toAddresses;
        public Boolean treatBodiesAsTemplate;
        public Boolean treatTargetObjectAsRecipient;
        public String whatId;
        private String[] bccAddresses_type_info = new String[]{'bccAddresses','urn:partner.soap.sforce.com',null,'0','25','true'};
        private String[] ccAddresses_type_info = new String[]{'ccAddresses','urn:partner.soap.sforce.com',null,'0','25','true'};
        private String[] charset_type_info = new String[]{'charset','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] documentAttachments_type_info = new String[]{'documentAttachments','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] entityAttachments_type_info = new String[]{'entityAttachments','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] fileAttachments_type_info = new String[]{'fileAttachments','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] htmlBody_type_info = new String[]{'htmlBody','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] inReplyTo_type_info = new String[]{'inReplyTo','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] optOutPolicy_type_info = new String[]{'optOutPolicy','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] orgWideEmailAddressId_type_info = new String[]{'orgWideEmailAddressId','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] plainTextBody_type_info = new String[]{'plainTextBody','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] references_type_info = new String[]{'references','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] targetObjectId_type_info = new String[]{'targetObjectId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] templateId_type_info = new String[]{'templateId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] templateName_type_info = new String[]{'templateName','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] toAddresses_type_info = new String[]{'toAddresses','urn:partner.soap.sforce.com',null,'0','100','true'};
        private String[] treatBodiesAsTemplate_type_info = new String[]{'treatBodiesAsTemplate','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] treatTargetObjectAsRecipient_type_info = new String[]{'treatTargetObjectAsRecipient','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] whatId_type_info = new String[]{'whatId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'bccAddresses','ccAddresses','charset','documentAttachments','entityAttachments','fileAttachments','htmlBody','inReplyTo','optOutPolicy','orgWideEmailAddressId','plainTextBody','references','targetObjectId','templateId','templateName','toAddresses','treatBodiesAsTemplate','treatTargetObjectAsRecipient','whatId'};
    }
    public class DescribeSearchScopeOrderResult {
        public String keyPrefix;
        public String name;
        private String[] keyPrefix_type_info = new String[]{'keyPrefix','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'keyPrefix','name'};
    }
    public class DescribeSoftphoneScreenPopOption {
        public String matchType;
        public String screenPopData;
        public String screenPopType;
        private String[] matchType_type_info = new String[]{'matchType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] screenPopData_type_info = new String[]{'screenPopData','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] screenPopType_type_info = new String[]{'screenPopType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'matchType','screenPopData','screenPopType'};
    }
    public class describeSearchScopeOrder_element {
        public Boolean includeRealTimeEntities;
        private String[] includeRealTimeEntities_type_info = new String[]{'includeRealTimeEntities','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'includeRealTimeEntities'};
    }
    public class create_element {
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjects'};
    }
    public class LimitInfoHeader_element {
        public partnerSoapSforceCom.LimitInfo[] limitInfo;
        private String[] limitInfo_type_info = new String[]{'limitInfo','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'limitInfo'};
    }
    public class describeDataCategoryMappingsResponse_element {
        public partnerSoapSforceCom.DescribeDataCategoryMappingResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class MassEmailMessage {
        public String description;
        public String[] targetObjectIds;
        public String templateId;
        public String[] whatIds;
        private String[] description_type_info = new String[]{'description','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] targetObjectIds_type_info = new String[]{'targetObjectIds','urn:partner.soap.sforce.com',null,'0','250','false'};
        private String[] templateId_type_info = new String[]{'templateId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] whatIds_type_info = new String[]{'whatIds','urn:partner.soap.sforce.com',null,'0','250','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'description','targetObjectIds','templateId','whatIds'};
    }
    public class renderStoredEmailTemplateResponse_element {
        public partnerSoapSforceCom.RenderStoredEmailTemplateResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class NameCaseValue {
        public String article;
        public String caseType;
        public String number_x;
        public String possessive;
        public String value;
        private String[] article_type_info = new String[]{'article','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] caseType_type_info = new String[]{'caseType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] number_x_type_info = new String[]{'number','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] possessive_type_info = new String[]{'possessive','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'article','caseType','number_x','possessive','value'};
    }
    public class describeApprovalLayout_element {
        public String sObjectType;
        public String[] approvalProcessNames;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] approvalProcessNames_type_info = new String[]{'approvalProcessNames','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','approvalProcessNames'};
    }
    public class SetPasswordResult {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class retrieveQuickActionTemplates_element {
        public String[] quickActionNames;
        public String contextId;
        private String[] quickActionNames_type_info = new String[]{'quickActionNames','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] contextId_type_info = new String[]{'contextId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionNames','contextId'};
    }
    public class retrieve_element {
        public String fieldList;
        public String sObjectType;
        public String[] ids;
        private String[] fieldList_type_info = new String[]{'fieldList','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldList','sObjectType','ids'};
    }
    public class DeleteResult {
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','id','success'};
    }
    public class SearchLayoutField {
        public String apiName;
        public String label;
        public Boolean sortable;
        private String[] apiName_type_info = new String[]{'apiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sortable_type_info = new String[]{'sortable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'apiName','label','sortable'};
    }
    public class DescribeQuickActionDefaultValue {
        public String defaultValue;
        public String field;
        private String[] defaultValue_type_info = new String[]{'defaultValue','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'defaultValue','field'};
    }
    public class describePrimaryCompactLayouts_element {
        public String[] sObjectTypes;
        private String[] sObjectTypes_type_info = new String[]{'sObjectTypes','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectTypes'};
    }
    public class describeGlobalThemeResponse_element {
        public partnerSoapSforceCom.DescribeGlobalTheme result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class query_element {
        public String queryString;
        private String[] queryString_type_info = new String[]{'queryString','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryString'};
    }
    public class describeLayout_element {
        public String sObjectType;
        public String layoutName;
        public String[] recordTypeIds;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layoutName_type_info = new String[]{'layoutName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] recordTypeIds_type_info = new String[]{'recordTypeIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','layoutName','recordTypeIds'};
    }
    public class describeSObjectListViewsResponse_element {
        public partnerSoapSforceCom.DescribeSoqlListViewResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeVisualForceResult {
        public String domain;
        private String[] domain_type_info = new String[]{'domain','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'domain'};
    }
    public class DescribeSoftphoneLayoutInfoField {
        public String name;
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'name'};
    }
    public class DebuggingHeader_element {
        public partnerSoapSforceCom.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class PackageVersion {
        public Integer majorNumber;
        public Integer minorNumber;
        public String namespace;
        private String[] majorNumber_type_info = new String[]{'majorNumber','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] minorNumber_type_info = new String[]{'minorNumber','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'majorNumber','minorNumber','namespace'};
    }
    public class DataCategoryGroupSobjectTypePair {
        public String dataCategoryGroupName;
        public String sobject_x;
        private String[] dataCategoryGroupName_type_info = new String[]{'dataCategoryGroupName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobject_x_type_info = new String[]{'sobject','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'dataCategoryGroupName','sobject_x'};
    }
    public class SearchRecord {
        public partnerSoapSforceCom.sObject_x record;
        public partnerSoapSforceCom.SearchRecordMetadata searchRecordMetadata;
        public partnerSoapSforceCom.SearchSnippet snippet;
        private String[] record_type_info = new String[]{'record','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchRecordMetadata_type_info = new String[]{'searchRecordMetadata','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] snippet_type_info = new String[]{'snippet','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'record','searchRecordMetadata','snippet'};
    }
    public class EntityErrorMetadata {
        public String errorCode;
        public String message;
        private String[] errorCode_type_info = new String[]{'errorCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] message_type_info = new String[]{'message','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errorCode','message'};
    }
    public class DescribeLayoutButtonSection {
        public partnerSoapSforceCom.DescribeLayoutButton[] detailButtons;
        private String[] detailButtons_type_info = new String[]{'detailButtons','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'detailButtons'};
    }
    public class AllOrNoneHeader_element {
        public Boolean allOrNone;
        private String[] allOrNone_type_info = new String[]{'allOrNone','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allOrNone'};
    }
    public class DescribeSoftphoneLayoutResult {
        public partnerSoapSforceCom.DescribeSoftphoneLayoutCallType[] callTypes;
        public String id;
        public String name;
        private String[] callTypes_type_info = new String[]{'callTypes','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'callTypes','id','name'};
    }
    public class describeDataCategoryMappings_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class LocaleOptions_element {
        public String language;
        public Boolean localizeErrors;
        private String[] language_type_info = new String[]{'language','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] localizeErrors_type_info = new String[]{'localizeErrors','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'language','localizeErrors'};
    }
    public class DescribeDataCategoryMappingResult {
        public String dataCategoryGroupId;
        public String dataCategoryGroupLabel;
        public String dataCategoryGroupName;
        public String dataCategoryId;
        public String dataCategoryLabel;
        public String dataCategoryName;
        public String id;
        public String mappedEntity;
        public String mappedField;
        private String[] dataCategoryGroupId_type_info = new String[]{'dataCategoryGroupId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataCategoryGroupLabel_type_info = new String[]{'dataCategoryGroupLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataCategoryGroupName_type_info = new String[]{'dataCategoryGroupName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataCategoryId_type_info = new String[]{'dataCategoryId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataCategoryLabel_type_info = new String[]{'dataCategoryLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataCategoryName_type_info = new String[]{'dataCategoryName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mappedEntity_type_info = new String[]{'mappedEntity','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mappedField_type_info = new String[]{'mappedField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'dataCategoryGroupId','dataCategoryGroupLabel','dataCategoryGroupName','dataCategoryId','dataCategoryLabel','dataCategoryName','id','mappedEntity','mappedField'};
    }
    public class DescribeLayoutSaveOption {
        public Boolean defaultValue;
        public Boolean isDisplayed;
        public String label;
        public String name;
        public String restHeaderName;
        public String soapHeaderName;
        private String[] defaultValue_type_info = new String[]{'defaultValue','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isDisplayed_type_info = new String[]{'isDisplayed','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] restHeaderName_type_info = new String[]{'restHeaderName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] soapHeaderName_type_info = new String[]{'soapHeaderName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'defaultValue','isDisplayed','label','name','restHeaderName','soapHeaderName'};
    }
    public class describeSearchLayoutsResponse_element {
        public partnerSoapSforceCom.DescribeSearchLayoutResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class UserTerritoryDeleteHeader_element {
        public String transferToUserId;
        private String[] transferToUserId_type_info = new String[]{'transferToUserId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'transferToUserId'};
    }
    public class FindDuplicatesResult {
        public partnerSoapSforceCom.DuplicateResult[] duplicateResults;
        public partnerSoapSforceCom.Error[] errors;
        public Boolean success;
        private String[] duplicateResults_type_info = new String[]{'duplicateResults','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'duplicateResults','errors','success'};
    }
    public class DescribeAnimationRule {
        public String animationFrequency;
        public Boolean isActive;
        public String recordTypeContext;
        public String recordTypeId;
        public String targetField;
        public String targetFieldChangeToValues;
        private String[] animationFrequency_type_info = new String[]{'animationFrequency','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeContext_type_info = new String[]{'recordTypeContext','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] targetField_type_info = new String[]{'targetField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] targetFieldChangeToValues_type_info = new String[]{'targetFieldChangeToValues','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'animationFrequency','isActive','recordTypeContext','recordTypeId','targetField','targetFieldChangeToValues'};
    }
    public class describeSearchLayouts_element {
        public String[] sObjectType;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType'};
    }
    public class address {
        public String city;
        public String country;
        public String countryCode;
        public String geocodeAccuracy;
        public String postalCode;
        public String state;
        public String stateCode;
        public String street;
        private String[] city_type_info = new String[]{'city','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] countryCode_type_info = new String[]{'countryCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] geocodeAccuracy_type_info = new String[]{'geocodeAccuracy','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] postalCode_type_info = new String[]{'postalCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] state_type_info = new String[]{'state','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] stateCode_type_info = new String[]{'stateCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] street_type_info = new String[]{'street','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'city','country','countryCode','geocodeAccuracy','postalCode','state','stateCode','street'};
    }
    public class sendEmail_element {
        public partnerSoapSforceCom.Email[] messages;
        private String[] messages_type_info = new String[]{'messages','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'messages'};
    }
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class DeletedRecord {
        public DateTime deletedDate;
        public String id;
        private String[] deletedDate_type_info = new String[]{'deletedDate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'deletedDate','id'};
    }
    public class emptyRecycleBin_element {
        public String[] ids;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids'};
    }
    public class SearchResult {
        public String queryId;
        public partnerSoapSforceCom.SearchRecord[] searchRecords;
        public partnerSoapSforceCom.SearchResultsMetadata searchResultsMetadata;
        private String[] queryId_type_info = new String[]{'queryId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchRecords_type_info = new String[]{'searchRecords','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] searchResultsMetadata_type_info = new String[]{'searchResultsMetadata','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryId','searchRecords','searchResultsMetadata'};
    }
    public class DescribeColumn {
        public String field;
        public String format;
        public String label;
        public String name;
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] format_type_info = new String[]{'format','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'field','format','label','name'};
    }
    public class describeLayoutResponse_element {
        public partnerSoapSforceCom.DescribeLayoutResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class login_element {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    public class undelete_element {
        public String[] ids;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids'};
    }
    public class ChangeOwnPasswordResult {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class DescribeCompactLayoutsResult {
        public partnerSoapSforceCom.DescribeCompactLayout[] compactLayouts;
        public String defaultCompactLayoutId;
        public partnerSoapSforceCom.RecordTypeCompactLayoutMapping[] recordTypeCompactLayoutMappings;
        private String[] compactLayouts_type_info = new String[]{'compactLayouts','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] defaultCompactLayoutId_type_info = new String[]{'defaultCompactLayoutId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeCompactLayoutMappings_type_info = new String[]{'recordTypeCompactLayoutMappings','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'compactLayouts','defaultCompactLayoutId','recordTypeCompactLayoutMappings'};
    }
    public class DescribeDataCategoryGroupStructureResult {
        public String description;
        public String label;
        public String name;
        public String sobject_x;
        public partnerSoapSforceCom.DataCategory[] topCategories;
        private String[] description_type_info = new String[]{'description','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobject_x_type_info = new String[]{'sobject','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] topCategories_type_info = new String[]{'topCategories','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'description','label','name','sobject_x','topCategories'};
    }
    public class GetUserInfoResult {
        public Boolean accessibilityMode;
        public Boolean chatterExternal;
        public String currencySymbol;
        public Integer orgAttachmentFileSizeLimit;
        public String orgDefaultCurrencyIsoCode;
        public String orgDefaultCurrencyLocale;
        public Boolean orgDisallowHtmlAttachments;
        public Boolean orgHasPersonAccounts;
        public String organizationId;
        public Boolean organizationMultiCurrency;
        public String organizationName;
        public String profileId;
        public String roleId;
        public Integer sessionSecondsValid;
        public String userDefaultCurrencyIsoCode;
        public String userEmail;
        public String userFullName;
        public String userId;
        public String userLanguage;
        public String userLocale;
        public String userName;
        public String userTimeZone;
        public String userType;
        public String userUiSkin;
        private String[] accessibilityMode_type_info = new String[]{'accessibilityMode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] chatterExternal_type_info = new String[]{'chatterExternal','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] currencySymbol_type_info = new String[]{'currencySymbol','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] orgAttachmentFileSizeLimit_type_info = new String[]{'orgAttachmentFileSizeLimit','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] orgDefaultCurrencyIsoCode_type_info = new String[]{'orgDefaultCurrencyIsoCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] orgDefaultCurrencyLocale_type_info = new String[]{'orgDefaultCurrencyLocale','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] orgDisallowHtmlAttachments_type_info = new String[]{'orgDisallowHtmlAttachments','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] orgHasPersonAccounts_type_info = new String[]{'orgHasPersonAccounts','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] organizationMultiCurrency_type_info = new String[]{'organizationMultiCurrency','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] organizationName_type_info = new String[]{'organizationName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] profileId_type_info = new String[]{'profileId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] roleId_type_info = new String[]{'roleId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sessionSecondsValid_type_info = new String[]{'sessionSecondsValid','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userDefaultCurrencyIsoCode_type_info = new String[]{'userDefaultCurrencyIsoCode','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] userEmail_type_info = new String[]{'userEmail','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userFullName_type_info = new String[]{'userFullName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userLanguage_type_info = new String[]{'userLanguage','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userLocale_type_info = new String[]{'userLocale','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userName_type_info = new String[]{'userName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userTimeZone_type_info = new String[]{'userTimeZone','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userType_type_info = new String[]{'userType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] userUiSkin_type_info = new String[]{'userUiSkin','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessibilityMode','chatterExternal','currencySymbol','orgAttachmentFileSizeLimit','orgDefaultCurrencyIsoCode','orgDefaultCurrencyLocale','orgDisallowHtmlAttachments','orgHasPersonAccounts','organizationId','organizationMultiCurrency','organizationName','profileId','roleId','sessionSecondsValid','userDefaultCurrencyIsoCode','userEmail','userFullName','userId','userLanguage','userLocale','userName','userTimeZone','userType','userUiSkin'};
    }
    public class EmailFileAttachment {
        public String body;
        public String contentType;
        public String fileName;
        public String id;
        public Boolean inline;
        private String[] body_type_info = new String[]{'body','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] contentType_type_info = new String[]{'contentType','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] fileName_type_info = new String[]{'fileName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] inline_type_info = new String[]{'inline','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'body','contentType','fileName','id','inline'};
    }
    public class sendEmailMessageResponse_element {
        public partnerSoapSforceCom.SendEmailResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class findDuplicates_element {
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjects'};
    }
    public class getServerTimestamp_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Email {
        public Boolean bccSender;
        public String emailPriority;
        public String replyTo;
        public Boolean saveAsActivity;
        public String senderDisplayName;
        public String subject;
        public Boolean useSignature;
        private String[] bccSender_type_info = new String[]{'bccSender','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] emailPriority_type_info = new String[]{'emailPriority','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] replyTo_type_info = new String[]{'replyTo','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] saveAsActivity_type_info = new String[]{'saveAsActivity','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] senderDisplayName_type_info = new String[]{'senderDisplayName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] subject_type_info = new String[]{'subject','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] useSignature_type_info = new String[]{'useSignature','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'bccSender','emailPriority','replyTo','saveAsActivity','senderDisplayName','subject','useSignature'};
    }
    public class DescribeIcon {
        public String contentType;
        public Integer height;
        public String theme;
        public String url;
        public Integer width;
        private String[] contentType_type_info = new String[]{'contentType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] theme_type_info = new String[]{'theme','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] width_type_info = new String[]{'width','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'contentType','height','theme','url','width'};
    }
    public class executeListView_element {
        public partnerSoapSforceCom.ExecuteListViewRequest request;
        private String[] request_type_info = new String[]{'request','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class deleteByExample_element {
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjects'};
    }
    public class loginResponse_element {
        public partnerSoapSforceCom.LoginResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class QueryOptions_element {
        public Integer batchSize;
        private String[] batchSize_type_info = new String[]{'batchSize','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'batchSize'};
    }
    public class describeGlobalResponse_element {
        public partnerSoapSforceCom.DescribeGlobalResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class RenderEmailTemplateBodyResult {
        public partnerSoapSforceCom.RenderEmailTemplateError[] errors;
        public String mergedBody;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] mergedBody_type_info = new String[]{'mergedBody','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','mergedBody','success'};
    }
    public class EmailHeader_element {
        public Boolean triggerAutoResponseEmail;
        public Boolean triggerOtherEmail;
        public Boolean triggerUserEmail;
        private String[] triggerAutoResponseEmail_type_info = new String[]{'triggerAutoResponseEmail','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] triggerOtherEmail_type_info = new String[]{'triggerOtherEmail','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] triggerUserEmail_type_info = new String[]{'triggerUserEmail','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'triggerAutoResponseEmail','triggerOtherEmail','triggerUserEmail'};
    }
    public class getServerTimestampResponse_element {
        public partnerSoapSforceCom.GetServerTimestampResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class findDuplicatesByIdsResponse_element {
        public partnerSoapSforceCom.FindDuplicatesResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class ReportChartComponent {
        public Boolean cacheData;
        public String contextFilterableField;
        public String error;
        public Boolean hideOnError;
        public Boolean includeContext;
        public Boolean showTitle;
        public String size;
        private String[] cacheData_type_info = new String[]{'cacheData','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] contextFilterableField_type_info = new String[]{'contextFilterableField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] error_type_info = new String[]{'error','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] hideOnError_type_info = new String[]{'hideOnError','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] includeContext_type_info = new String[]{'includeContext','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showTitle_type_info = new String[]{'showTitle','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] size_type_info = new String[]{'size','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'cacheData','contextFilterableField','error','hideOnError','includeContext','showTitle','size'};
    }
    public class DescribeQuickActionListItemResult {
        public String accessLevelRequired;
        public partnerSoapSforceCom.DescribeColor[] colors;
        public String iconUrl;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String label;
        public String miniIconUrl;
        public String quickActionName;
        public String targetSobjectType;
        public String type_x;
        private String[] accessLevelRequired_type_info = new String[]{'accessLevelRequired','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] iconUrl_type_info = new String[]{'iconUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] miniIconUrl_type_info = new String[]{'miniIconUrl','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] quickActionName_type_info = new String[]{'quickActionName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] targetSobjectType_type_info = new String[]{'targetSobjectType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevelRequired','colors','iconUrl','icons','label','miniIconUrl','quickActionName','targetSobjectType','type_x'};
    }
    public class describeAvailableQuickActionsResponse_element {
        public partnerSoapSforceCom.DescribeAvailableQuickActionResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeSObjects_element {
        public String[] sObjectType;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'0','100','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType'};
    }
    public class undeleteResponse_element {
        public partnerSoapSforceCom.UndeleteResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describePathAssistantsResponse_element {
        public partnerSoapSforceCom.DescribePathAssistantsResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class OwnerChangeOptions_element {
        public partnerSoapSforceCom.OwnerChangeOption[] options;
        private String[] options_type_info = new String[]{'options','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'options'};
    }
    public class DescribeLayoutItem {
        public Boolean editableForNew;
        public Boolean editableForUpdate;
        public String label;
        public partnerSoapSforceCom.DescribeLayoutComponent[] layoutComponents;
        public Boolean placeholder;
        public Boolean required;
        private String[] editableForNew_type_info = new String[]{'editableForNew','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] editableForUpdate_type_info = new String[]{'editableForUpdate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] layoutComponents_type_info = new String[]{'layoutComponents','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] placeholder_type_info = new String[]{'placeholder','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] required_type_info = new String[]{'required','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'editableForNew','editableForUpdate','label','layoutComponents','placeholder','required'};
    }
    public class describeAppMenuResponse_element {
        public partnerSoapSforceCom.DescribeAppMenuResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class resetPasswordResponse_element {
        public partnerSoapSforceCom.ResetPasswordResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class Canvas {
        public String displayLocation;
        public String referenceId;
        public Boolean showLabel;
        public Boolean showScrollbars;
        public String suggestedHeight;
        public String suggestedWidth;
        private String[] displayLocation_type_info = new String[]{'displayLocation','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] referenceId_type_info = new String[]{'referenceId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showLabel_type_info = new String[]{'showLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showScrollbars_type_info = new String[]{'showScrollbars','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] suggestedHeight_type_info = new String[]{'suggestedHeight','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] suggestedWidth_type_info = new String[]{'suggestedWidth','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'displayLocation','referenceId','showLabel','showScrollbars','suggestedHeight','suggestedWidth'};
    }
    public class ProcessResult {
        public String[] actorIds;
        public String entityId;
        public partnerSoapSforceCom.Error[] errors;
        public String instanceId;
        public String instanceStatus;
        public String[] newWorkitemIds;
        public Boolean success;
        private String[] actorIds_type_info = new String[]{'actorIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] entityId_type_info = new String[]{'entityId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] instanceId_type_info = new String[]{'instanceId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] instanceStatus_type_info = new String[]{'instanceStatus','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] newWorkitemIds_type_info = new String[]{'newWorkitemIds','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actorIds','entityId','errors','instanceId','instanceStatus','newWorkitemIds','success'};
    }
    public class RelatedListColumn {
        public String field;
        public String fieldApiName;
        public String format;
        public String label;
        public String lookupId;
        public String name;
        public Boolean sortable;
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] fieldApiName_type_info = new String[]{'fieldApiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] format_type_info = new String[]{'format','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] lookupId_type_info = new String[]{'lookupId','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sortable_type_info = new String[]{'sortable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'field','fieldApiName','format','label','lookupId','name','sortable'};
    }
    public class findDuplicatesResponse_element {
        public partnerSoapSforceCom.FindDuplicatesResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class queryMoreResponse_element {
        public partnerSoapSforceCom.QueryResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class FieldLevelSearchMetadata {
        public String label;
        public String name;
        public String type_x;
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'label','name','type_x'};
    }
    public class MatchRecord {
        public partnerSoapSforceCom.AdditionalInformationMap[] additionalInformation;
        public partnerSoapSforceCom.FieldDiff[] fieldDiffs;
        public Double matchConfidence;
        public partnerSoapSforceCom.sObject_x record;
        private String[] additionalInformation_type_info = new String[]{'additionalInformation','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] fieldDiffs_type_info = new String[]{'fieldDiffs','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] matchConfidence_type_info = new String[]{'matchConfidence','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] record_type_info = new String[]{'record','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'additionalInformation','fieldDiffs','matchConfidence','record'};
    }
    public class SoqlSubQueryCondition {
        public String field;
        public String operator;
        public String subQuery;
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] subQuery_type_info = new String[]{'subQuery','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'field','operator','subQuery'};
    }
    public class describeGlobal_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class DescribeApprovalLayoutResult {
        public partnerSoapSforceCom.DescribeApprovalLayout[] approvalLayouts;
        private String[] approvalLayouts_type_info = new String[]{'approvalLayouts','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'approvalLayouts'};
    }
    public class describeApprovalLayoutResponse_element {
        public partnerSoapSforceCom.DescribeApprovalLayoutResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeLayoutSection {
        public Boolean collapsed;
        public Integer columns;
        public String heading;
        public partnerSoapSforceCom.DescribeLayoutRow[] layoutRows;
        public String layoutSectionId;
        public String parentLayoutId;
        public Integer rows;
        public String tabOrder;
        public Boolean useCollapsibleSection;
        public Boolean useHeading;
        private String[] collapsed_type_info = new String[]{'collapsed','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] columns_type_info = new String[]{'columns','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] heading_type_info = new String[]{'heading','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] layoutRows_type_info = new String[]{'layoutRows','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] layoutSectionId_type_info = new String[]{'layoutSectionId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] parentLayoutId_type_info = new String[]{'parentLayoutId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] rows_type_info = new String[]{'rows','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] tabOrder_type_info = new String[]{'tabOrder','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] useCollapsibleSection_type_info = new String[]{'useCollapsibleSection','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] useHeading_type_info = new String[]{'useHeading','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'collapsed','columns','heading','layoutRows','layoutSectionId','parentLayoutId','rows','tabOrder','useCollapsibleSection','useHeading'};
    }
    public class setPasswordResponse_element {
        public partnerSoapSforceCom.SetPasswordResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class ActionOverride {
        public String formFactor;
        public Boolean isAvailableInTouch;
        public String name;
        public String pageId;
        public String url;
        private String[] formFactor_type_info = new String[]{'formFactor','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] isAvailableInTouch_type_info = new String[]{'isAvailableInTouch','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] pageId_type_info = new String[]{'pageId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'formFactor','isAvailableInTouch','name','pageId','url'};
    }
    public class processResponse_element {
        public partnerSoapSforceCom.ProcessResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeGlobalResult {
        public String encoding;
        public Integer maxBatchSize;
        public partnerSoapSforceCom.DescribeGlobalSObjectResult[] sobjects;
        private String[] encoding_type_info = new String[]{'encoding','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] maxBatchSize_type_info = new String[]{'maxBatchSize','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobjects_type_info = new String[]{'sobjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'encoding','maxBatchSize','sobjects'};
    }
    public class sendEmailMessage_element {
        public String[] ids;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids'};
    }
    public class searchResponse_element {
        public partnerSoapSforceCom.SearchResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeLayoutResult {
        public partnerSoapSforceCom.DescribeLayout[] layouts;
        public partnerSoapSforceCom.RecordTypeMapping[] recordTypeMappings;
        public Boolean recordTypeSelectorRequired;
        private String[] layouts_type_info = new String[]{'layouts','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] recordTypeMappings_type_info = new String[]{'recordTypeMappings','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] recordTypeSelectorRequired_type_info = new String[]{'recordTypeSelectorRequired','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'layouts','recordTypeMappings','recordTypeSelectorRequired'};
    }
    public class changeOwnPasswordResponse_element {
        public partnerSoapSforceCom.ChangeOwnPasswordResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribePathAssistant {
        public Boolean active;
        public partnerSoapSforceCom.DescribeAnimationRule[] animationRule;
        public String apiName;
        public String label;
        public String pathPicklistField;
        public partnerSoapSforceCom.PicklistForRecordType[] picklistsForRecordType;
        public String recordTypeId;
        public partnerSoapSforceCom.DescribePathAssistantStep[] steps;
        private String[] active_type_info = new String[]{'active','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] animationRule_type_info = new String[]{'animationRule','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apiName_type_info = new String[]{'apiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] pathPicklistField_type_info = new String[]{'pathPicklistField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistsForRecordType_type_info = new String[]{'picklistsForRecordType','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] steps_type_info = new String[]{'steps','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','animationRule','apiName','label','pathPicklistField','picklistsForRecordType','recordTypeId','steps'};
    }
    public class AdditionalInformationMap {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public class FilteredLookupInfo {
        public String[] controllingFields;
        public Boolean dependent;
        public Boolean optionalFilter;
        private String[] controllingFields_type_info = new String[]{'controllingFields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] dependent_type_info = new String[]{'dependent','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] optionalFilter_type_info = new String[]{'optionalFilter','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'controllingFields','dependent','optionalFilter'};
    }
    public class MatchResult {
        public String entityType;
        public partnerSoapSforceCom.Error[] errors;
        public String matchEngine;
        public partnerSoapSforceCom.MatchRecord[] matchRecords;
        public String rule;
        public Integer size;
        public Boolean success;
        private String[] entityType_type_info = new String[]{'entityType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] matchEngine_type_info = new String[]{'matchEngine','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] matchRecords_type_info = new String[]{'matchRecords','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] rule_type_info = new String[]{'rule','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] size_type_info = new String[]{'size','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityType','errors','matchEngine','matchRecords','rule','size','success'};
    }
    public class DescribeCompactLayout {
        public partnerSoapSforceCom.DescribeLayoutButton[] actions;
        public partnerSoapSforceCom.DescribeLayoutItem[] fieldItems;
        public String id;
        public partnerSoapSforceCom.DescribeLayoutItem[] imageItems;
        public String label;
        public String name;
        public String objectType;
        private String[] actions_type_info = new String[]{'actions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] fieldItems_type_info = new String[]{'fieldItems','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] imageItems_type_info = new String[]{'imageItems','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] objectType_type_info = new String[]{'objectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actions','fieldItems','id','imageItems','label','name','objectType'};
    }
    public class CurrencyConversionHeader_element {
        public Boolean skipCurrencyConversion;
        private String[] skipCurrencyConversion_type_info = new String[]{'skipCurrencyConversion','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'skipCurrencyConversion'};
    }
    public class Field {
        public Boolean aggregatable;
        public Boolean aiPredictionField;
        public Boolean autoNumber;
        public Integer byteLength;
        public Boolean calculated;
        public String calculatedFormula;
        public Boolean cascadeDelete;
        public Boolean caseSensitive;
        public String compoundFieldName;
        public String controllerName;
        public Boolean createable;
        public Boolean custom;
        public Boolean dataTranslationEnabled;
        public String defaultValue;
        public String defaultValueFormula;
        public Boolean defaultedOnCreate;
        public Boolean dependentPicklist;
        public Boolean deprecatedAndHidden;
        public Integer digits;
        public Boolean displayLocationInDecimal;
        public Boolean encrypted;
        public Boolean externalId;
        public String extraTypeInfo;
        public Boolean filterable;
        public partnerSoapSforceCom.FilteredLookupInfo filteredLookupInfo;
        public Boolean formulaTreatNullNumberAsZero;
        public Boolean groupable;
        public Boolean highScaleNumber;
        public Boolean htmlFormatted;
        public Boolean idLookup;
        public String inlineHelpText;
        public String label;
        public Integer length;
        public String mask;
        public String maskType;
        public String name;
        public Boolean nameField;
        public Boolean namePointing;
        public Boolean nillable;
        public Boolean permissionable;
        public partnerSoapSforceCom.PicklistEntry[] picklistValues;
        public Boolean polymorphicForeignKey;
        public Integer precision;
        public Boolean queryByDistance;
        public String referenceTargetField;
        public String[] referenceTo;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean restrictedDelete;
        public Boolean restrictedPicklist;
        public Integer scale;
        public Boolean searchPrefilterable;
        public String soapType;
        public Boolean sortable;
        public String type_x;
        public Boolean unique;
        public Boolean updateable;
        public Boolean writeRequiresMasterRead;
        private String[] aggregatable_type_info = new String[]{'aggregatable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] aiPredictionField_type_info = new String[]{'aiPredictionField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] autoNumber_type_info = new String[]{'autoNumber','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] byteLength_type_info = new String[]{'byteLength','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] calculated_type_info = new String[]{'calculated','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] calculatedFormula_type_info = new String[]{'calculatedFormula','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] cascadeDelete_type_info = new String[]{'cascadeDelete','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] caseSensitive_type_info = new String[]{'caseSensitive','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] compoundFieldName_type_info = new String[]{'compoundFieldName','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] controllerName_type_info = new String[]{'controllerName','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] createable_type_info = new String[]{'createable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataTranslationEnabled_type_info = new String[]{'dataTranslationEnabled','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] defaultValueFormula_type_info = new String[]{'defaultValueFormula','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] defaultedOnCreate_type_info = new String[]{'defaultedOnCreate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dependentPicklist_type_info = new String[]{'dependentPicklist','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] digits_type_info = new String[]{'digits','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] displayLocationInDecimal_type_info = new String[]{'displayLocationInDecimal','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] encrypted_type_info = new String[]{'encrypted','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] externalId_type_info = new String[]{'externalId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] extraTypeInfo_type_info = new String[]{'extraTypeInfo','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] filterable_type_info = new String[]{'filterable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] filteredLookupInfo_type_info = new String[]{'filteredLookupInfo','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] formulaTreatNullNumberAsZero_type_info = new String[]{'formulaTreatNullNumberAsZero','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] groupable_type_info = new String[]{'groupable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] highScaleNumber_type_info = new String[]{'highScaleNumber','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] htmlFormatted_type_info = new String[]{'htmlFormatted','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] idLookup_type_info = new String[]{'idLookup','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] inlineHelpText_type_info = new String[]{'inlineHelpText','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] length_type_info = new String[]{'length','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mask_type_info = new String[]{'mask','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] maskType_type_info = new String[]{'maskType','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] nameField_type_info = new String[]{'nameField','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] namePointing_type_info = new String[]{'namePointing','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] nillable_type_info = new String[]{'nillable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] permissionable_type_info = new String[]{'permissionable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] polymorphicForeignKey_type_info = new String[]{'polymorphicForeignKey','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] precision_type_info = new String[]{'precision','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] queryByDistance_type_info = new String[]{'queryByDistance','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] referenceTargetField_type_info = new String[]{'referenceTargetField','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] referenceTo_type_info = new String[]{'referenceTo','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] relationshipOrder_type_info = new String[]{'relationshipOrder','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedDelete_type_info = new String[]{'restrictedDelete','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedPicklist_type_info = new String[]{'restrictedPicklist','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] scale_type_info = new String[]{'scale','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchPrefilterable_type_info = new String[]{'searchPrefilterable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] soapType_type_info = new String[]{'soapType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sortable_type_info = new String[]{'sortable','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] unique_type_info = new String[]{'unique','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] updateable_type_info = new String[]{'updateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] writeRequiresMasterRead_type_info = new String[]{'writeRequiresMasterRead','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'aggregatable','aiPredictionField','autoNumber','byteLength','calculated','calculatedFormula','cascadeDelete','caseSensitive','compoundFieldName','controllerName','createable','custom','dataTranslationEnabled','defaultValue','defaultValueFormula','defaultedOnCreate','dependentPicklist','deprecatedAndHidden','digits','displayLocationInDecimal','encrypted','externalId','extraTypeInfo','filterable','filteredLookupInfo','formulaTreatNullNumberAsZero','groupable','highScaleNumber','htmlFormatted','idLookup','inlineHelpText','label','length','mask','maskType','name','nameField','namePointing','nillable','permissionable','picklistValues','polymorphicForeignKey','precision','queryByDistance','referenceTargetField','referenceTo','relationshipName','relationshipOrder','restrictedDelete','restrictedPicklist','scale','searchPrefilterable','soapType','sortable','type_x','unique','updateable','writeRequiresMasterRead'};
    }
    public class invalidateSessionsResponse_element {
        public partnerSoapSforceCom.InvalidateSessionsResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeSoftphoneLayoutResponse_element {
        public partnerSoapSforceCom.DescribeSoftphoneLayoutResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class PicklistEntry {
        public Boolean active;
        public Boolean defaultValue;
        public String label;
        public String validFor;
        public String value;
        private String[] active_type_info = new String[]{'active','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] validFor_type_info = new String[]{'validFor','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','defaultValue','label','validFor','value'};
    }
    public class DescribeSearchLayoutResult {
        public String errorMsg;
        public String label;
        public Integer limitRows;
        public String objectType;
        public partnerSoapSforceCom.DescribeColumn[] searchColumns;
        private String[] errorMsg_type_info = new String[]{'errorMsg','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] limitRows_type_info = new String[]{'limitRows','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] objectType_type_info = new String[]{'objectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchColumns_type_info = new String[]{'searchColumns','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errorMsg','label','limitRows','objectType','searchColumns'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class mergeResponse_element {
        public partnerSoapSforceCom.MergeResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeSoqlListViewParams {
        public String developerNameOrId;
        public String sobjectType;
        private String[] developerNameOrId_type_info = new String[]{'developerNameOrId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobjectType_type_info = new String[]{'sobjectType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'developerNameOrId','sobjectType'};
    }
    public class ExecuteListViewRequest {
        public String developerNameOrId;
        public Integer limit_x;
        public Integer offset;
        public partnerSoapSforceCom.ListViewOrderBy[] orderBy;
        public String sobjectType;
        private String[] developerNameOrId_type_info = new String[]{'developerNameOrId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] limit_x_type_info = new String[]{'limit','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] offset_type_info = new String[]{'offset','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] orderBy_type_info = new String[]{'orderBy','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] sobjectType_type_info = new String[]{'sobjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'developerNameOrId','limit_x','offset','orderBy','sobjectType'};
    }
    public class DescribePathAssistantField {
        public String apiName;
        public String label;
        public Boolean readOnly;
        public Boolean required;
        private String[] apiName_type_info = new String[]{'apiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] readOnly_type_info = new String[]{'readOnly','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] required_type_info = new String[]{'required','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'apiName','label','readOnly','required'};
    }
    public class DescribeDataCategoryGroupResult {
        public Integer categoryCount;
        public String description;
        public String label;
        public String name;
        public String sobject_x;
        private String[] categoryCount_type_info = new String[]{'categoryCount','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobject_x_type_info = new String[]{'sobject','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'categoryCount','description','label','name','sobject_x'};
    }
    public class DescribeThemeItem {
        public partnerSoapSforceCom.DescribeColor[] colors;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String name;
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'colors','icons','name'};
    }
    public class RenderStoredEmailTemplateResult {
        public partnerSoapSforceCom.Error[] errors;
        public partnerSoapSforceCom.SingleEmailMessage renderedEmail;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] renderedEmail_type_info = new String[]{'renderedEmail','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','renderedEmail','success'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class describeAllTabsResponse_element {
        public partnerSoapSforceCom.DescribeTab[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeSObjectResult {
        public partnerSoapSforceCom.ActionOverride[] actionOverrides;
        public Boolean activateable;
        public String associateEntityType;
        public String associateParentEntity;
        public partnerSoapSforceCom.ChildRelationship[] childRelationships;
        public Boolean compactLayoutable;
        public Boolean createable;
        public Boolean custom;
        public Boolean customSetting;
        public Boolean dataTranslationEnabled;
        public Boolean deepCloneable;
        public String defaultImplementation;
        public Boolean deletable;
        public Boolean deprecatedAndHidden;
        public Boolean feedEnabled;
        public partnerSoapSforceCom.Field[] fields;
        public Boolean hasSubtypes;
        public Boolean idEnabled;
        public String implementedBy;
        public String implementsInterfaces;
        public Boolean isInterface;
        public Boolean isSubtype;
        public String keyPrefix;
        public String label;
        public String labelPlural;
        public Boolean layoutable;
        public Boolean mergeable;
        public Boolean mruEnabled;
        public String name;
        public partnerSoapSforceCom.NamedLayoutInfo[] namedLayoutInfos;
        public String networkScopeFieldName;
        public Boolean queryable;
        public partnerSoapSforceCom.RecordTypeInfo[] recordTypeInfos;
        public Boolean replicateable;
        public Boolean retrieveable;
        public Boolean searchLayoutable;
        public Boolean searchable;
        public partnerSoapSforceCom.ScopeInfo[] supportedScopes;
        public Boolean triggerable;
        public Boolean undeletable;
        public Boolean updateable;
        public String urlDetail;
        public String urlEdit;
        public String urlNew;
        private String[] actionOverrides_type_info = new String[]{'actionOverrides','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] activateable_type_info = new String[]{'activateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] associateEntityType_type_info = new String[]{'associateEntityType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] associateParentEntity_type_info = new String[]{'associateParentEntity','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] childRelationships_type_info = new String[]{'childRelationships','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] compactLayoutable_type_info = new String[]{'compactLayoutable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] createable_type_info = new String[]{'createable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] customSetting_type_info = new String[]{'customSetting','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataTranslationEnabled_type_info = new String[]{'dataTranslationEnabled','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] deepCloneable_type_info = new String[]{'deepCloneable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] defaultImplementation_type_info = new String[]{'defaultImplementation','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] deletable_type_info = new String[]{'deletable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] feedEnabled_type_info = new String[]{'feedEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] fields_type_info = new String[]{'fields','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] hasSubtypes_type_info = new String[]{'hasSubtypes','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] idEnabled_type_info = new String[]{'idEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] implementedBy_type_info = new String[]{'implementedBy','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] implementsInterfaces_type_info = new String[]{'implementsInterfaces','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] isInterface_type_info = new String[]{'isInterface','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isSubtype_type_info = new String[]{'isSubtype','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] keyPrefix_type_info = new String[]{'keyPrefix','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] labelPlural_type_info = new String[]{'labelPlural','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layoutable_type_info = new String[]{'layoutable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mergeable_type_info = new String[]{'mergeable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mruEnabled_type_info = new String[]{'mruEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] namedLayoutInfos_type_info = new String[]{'namedLayoutInfos','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] networkScopeFieldName_type_info = new String[]{'networkScopeFieldName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] queryable_type_info = new String[]{'queryable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeInfos_type_info = new String[]{'recordTypeInfos','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] replicateable_type_info = new String[]{'replicateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] retrieveable_type_info = new String[]{'retrieveable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchLayoutable_type_info = new String[]{'searchLayoutable','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] searchable_type_info = new String[]{'searchable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] supportedScopes_type_info = new String[]{'supportedScopes','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] triggerable_type_info = new String[]{'triggerable','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] undeletable_type_info = new String[]{'undeletable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] updateable_type_info = new String[]{'updateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] urlDetail_type_info = new String[]{'urlDetail','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] urlEdit_type_info = new String[]{'urlEdit','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] urlNew_type_info = new String[]{'urlNew','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actionOverrides','activateable','associateEntityType','associateParentEntity','childRelationships','compactLayoutable','createable','custom','customSetting','dataTranslationEnabled','deepCloneable','defaultImplementation','deletable','deprecatedAndHidden','feedEnabled','fields','hasSubtypes','idEnabled','implementedBy','implementsInterfaces','isInterface','isSubtype','keyPrefix','label','labelPlural','layoutable','mergeable','mruEnabled','name','namedLayoutInfos','networkScopeFieldName','queryable','recordTypeInfos','replicateable','retrieveable','searchLayoutable','searchable','supportedScopes','triggerable','undeletable','updateable','urlDetail','urlEdit','urlNew'};
    }
    public class deleteResponse_element {
        public partnerSoapSforceCom.DeleteResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class LeadConvertResult {
        public String accountId;
        public String contactId;
        public partnerSoapSforceCom.Error[] errors;
        public String leadId;
        public String opportunityId;
        public String relatedPersonAccountId;
        public Boolean success;
        private String[] accountId_type_info = new String[]{'accountId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] contactId_type_info = new String[]{'contactId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] leadId_type_info = new String[]{'leadId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] opportunityId_type_info = new String[]{'opportunityId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] relatedPersonAccountId_type_info = new String[]{'relatedPersonAccountId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accountId','contactId','errors','leadId','opportunityId','relatedPersonAccountId','success'};
    }
    public class KnowledgeSettings {
        public String defaultLanguage;
        public Boolean knowledgeEnabled;
        public partnerSoapSforceCom.KnowledgeLanguageItem[] languages;
        private String[] defaultLanguage_type_info = new String[]{'defaultLanguage','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] knowledgeEnabled_type_info = new String[]{'knowledgeEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] languages_type_info = new String[]{'languages','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'defaultLanguage','knowledgeEnabled','languages'};
    }
    public class LoginScopeHeader_element {
        public String organizationId;
        public String portalId;
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] portalId_type_info = new String[]{'portalId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'organizationId','portalId'};
    }
    public class update_element {
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjects'};
    }
    public class ChildRelationship {
        public Boolean cascadeDelete;
        public String childSObject;
        public Boolean deprecatedAndHidden;
        public String field;
        public String[] junctionIdListNames;
        public String[] junctionReferenceTo;
        public String relationshipName;
        public Boolean restrictedDelete;
        private String[] cascadeDelete_type_info = new String[]{'cascadeDelete','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] childSObject_type_info = new String[]{'childSObject','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] junctionIdListNames_type_info = new String[]{'junctionIdListNames','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] junctionReferenceTo_type_info = new String[]{'junctionReferenceTo','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedDelete_type_info = new String[]{'restrictedDelete','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'cascadeDelete','childSObject','deprecatedAndHidden','field','junctionIdListNames','junctionReferenceTo','relationshipName','restrictedDelete'};
    }
    public class RelatedList {
        public String accessLevelRequiredForCreate;
        public partnerSoapSforceCom.DescribeLayoutButton[] buttons;
        public partnerSoapSforceCom.RelatedListColumn[] columns;
        public Boolean custom;
        public String field;
        public String label;
        public Integer limitRows;
        public String name;
        public String sobject_x;
        public partnerSoapSforceCom.RelatedListSort[] sort_x;
        private String[] accessLevelRequiredForCreate_type_info = new String[]{'accessLevelRequiredForCreate','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] buttons_type_info = new String[]{'buttons','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] columns_type_info = new String[]{'columns','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] limitRows_type_info = new String[]{'limitRows','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobject_x_type_info = new String[]{'sobject','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sort_x_type_info = new String[]{'sort','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevelRequiredForCreate','buttons','columns','custom','field','label','limitRows','name','sobject_x','sort_x'};
    }
    public class ChangeEventHeader {
        public String entityName;
        public String[] recordIds;
        public Long commitTimestamp;
        public Long commitNumber;
        public String commitUser;
        public String[] diffFields;
        public String changeType;
        public String changeOrigin;
        public String transactionKey;
        public Integer sequenceNumber;
        public String[] nulledFields;
        public String[] changedFields;
        private String[] entityName_type_info = new String[]{'entityName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordIds_type_info = new String[]{'recordIds','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] commitTimestamp_type_info = new String[]{'commitTimestamp','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] commitNumber_type_info = new String[]{'commitNumber','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] commitUser_type_info = new String[]{'commitUser','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] diffFields_type_info = new String[]{'diffFields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] changeType_type_info = new String[]{'changeType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] changeOrigin_type_info = new String[]{'changeOrigin','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] transactionKey_type_info = new String[]{'transactionKey','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sequenceNumber_type_info = new String[]{'sequenceNumber','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] nulledFields_type_info = new String[]{'nulledFields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] changedFields_type_info = new String[]{'changedFields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityName','recordIds','commitTimestamp','commitNumber','commitUser','diffFields','changeType','changeOrigin','transactionKey','sequenceNumber','nulledFields','changedFields'};
    }
    public class describeNouns_element {
        public String[] nouns;
        public Boolean onlyRenamed;
        public Boolean includeFields;
        private String[] nouns_type_info = new String[]{'nouns','urn:partner.soap.sforce.com',null,'0','100','false'};
        private String[] onlyRenamed_type_info = new String[]{'onlyRenamed','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] includeFields_type_info = new String[]{'includeFields','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'nouns','onlyRenamed','includeFields'};
    }
    public class location {
        public Double latitude;
        public Double longitude;
        private String[] latitude_type_info = new String[]{'latitude','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] longitude_type_info = new String[]{'longitude','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'latitude','longitude'};
    }
    public class renderEmailTemplate_element {
        public partnerSoapSforceCom.RenderEmailTemplateRequest[] renderRequests;
        private String[] renderRequests_type_info = new String[]{'renderRequests','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'renderRequests'};
    }
    public class DuplicateRuleHeader_element {
        public Boolean allowSave;
        public Boolean includeRecordDetails;
        public Boolean runAsCurrentUser;
        private String[] allowSave_type_info = new String[]{'allowSave','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] includeRecordDetails_type_info = new String[]{'includeRecordDetails','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] runAsCurrentUser_type_info = new String[]{'runAsCurrentUser','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allowSave','includeRecordDetails','runAsCurrentUser'};
    }
    public class SearchSnippet {
        public String text;
        public partnerSoapSforceCom.NameValuePair[] wholeFields;
        private String[] text_type_info = new String[]{'text','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] wholeFields_type_info = new String[]{'wholeFields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'text','wholeFields'};
    }
    public class DataCategory {
        public partnerSoapSforceCom.DataCategory[] childCategories;
        public String label;
        public String name;
        private String[] childCategories_type_info = new String[]{'childCategories','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'childCategories','label','name'};
    }
    public class DescribeAppMenuItem {
        public partnerSoapSforceCom.DescribeColor[] colors;
        public String content;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String label;
        public String name;
        public String type_x;
        public String url;
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] content_type_info = new String[]{'content','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'colors','content','icons','label','name','type_x','url'};
    }
    public class ProcessSubmitRequest {
        public String objectId;
        public String submitterId;
        public String processDefinitionNameOrId;
        public Boolean skipEntryCriteria;
        private String[] objectId_type_info = new String[]{'objectId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] submitterId_type_info = new String[]{'submitterId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] processDefinitionNameOrId_type_info = new String[]{'processDefinitionNameOrId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] skipEntryCriteria_type_info = new String[]{'skipEntryCriteria','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'objectId','submitterId','processDefinitionNameOrId','skipEntryCriteria'};
    }
    public class describeNounsResponse_element {
        public partnerSoapSforceCom.DescribeNounResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DeleteByExampleResult {
        public partnerSoapSforceCom.sObject_x entity;
        public partnerSoapSforceCom.Error[] errors;
        public Long rowCount;
        public Boolean success;
        private String[] entity_type_info = new String[]{'entity','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] rowCount_type_info = new String[]{'rowCount','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entity','errors','rowCount','success'};
    }
    public class SoqlConditionGroup {
        public partnerSoapSforceCom.SoqlWhereCondition[] conditions;
        public String conjunction;
        private String[] conditions_type_info = new String[]{'conditions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] conjunction_type_info = new String[]{'conjunction','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'conditions','conjunction'};
    }
    public class describeSObjectListViews_element {
        public String sObjectType;
        public Boolean recentsOnly;
        public String isSoqlCompatible;
        public Integer limit_x;
        public Integer offset;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recentsOnly_type_info = new String[]{'recentsOnly','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isSoqlCompatible_type_info = new String[]{'isSoqlCompatible','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] limit_x_type_info = new String[]{'limit','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] offset_type_info = new String[]{'offset','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','recentsOnly','isSoqlCompatible','limit_x','offset'};
    }
    public class DescribeLayout {
        public partnerSoapSforceCom.DescribeLayoutButtonSection buttonLayoutSection;
        public partnerSoapSforceCom.DescribeLayoutSection[] detailLayoutSections;
        public partnerSoapSforceCom.DescribeLayoutSection[] editLayoutSections;
        public partnerSoapSforceCom.DescribeLayoutFeedView feedView;
        public partnerSoapSforceCom.DescribeLayoutSection highlightsPanelLayoutSection;
        public String id;
        public partnerSoapSforceCom.DescribeQuickActionListResult quickActionList;
        public partnerSoapSforceCom.RelatedContent relatedContent;
        public partnerSoapSforceCom.RelatedList[] relatedLists;
        public partnerSoapSforceCom.DescribeLayoutSaveOption[] saveOptions;
        private String[] buttonLayoutSection_type_info = new String[]{'buttonLayoutSection','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] detailLayoutSections_type_info = new String[]{'detailLayoutSections','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] editLayoutSections_type_info = new String[]{'editLayoutSections','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] feedView_type_info = new String[]{'feedView','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] highlightsPanelLayoutSection_type_info = new String[]{'highlightsPanelLayoutSection','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] quickActionList_type_info = new String[]{'quickActionList','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] relatedContent_type_info = new String[]{'relatedContent','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] relatedLists_type_info = new String[]{'relatedLists','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] saveOptions_type_info = new String[]{'saveOptions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'buttonLayoutSection','detailLayoutSections','editLayoutSections','feedView','highlightsPanelLayoutSection','id','quickActionList','relatedContent','relatedLists','saveOptions'};
    }
    public class ListViewOrderBy {
        public String fieldNameOrPath;
        public String nullsPosition;
        public String sortDirection;
        private String[] fieldNameOrPath_type_info = new String[]{'fieldNameOrPath','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] nullsPosition_type_info = new String[]{'nullsPosition','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sortDirection_type_info = new String[]{'sortDirection','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldNameOrPath','nullsPosition','sortDirection'};
    }
    public class SearchResultsMetadata {
        public partnerSoapSforceCom.LabelsSearchMetadata[] entityLabelMetadata;
        public partnerSoapSforceCom.EntitySearchMetadata[] entityMetadata;
        private String[] entityLabelMetadata_type_info = new String[]{'entityLabelMetadata','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] entityMetadata_type_info = new String[]{'entityMetadata','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityLabelMetadata','entityMetadata'};
    }
    public class resetPassword_element {
        public String userId;
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'userId'};
    }
    public class describeSObject_element {
        public String sObjectType;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType'};
    }
    public class getDeleted_element {
        public String sObjectType;
        public DateTime startDate;
        public DateTime endDate;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','startDate','endDate'};
    }
    public class RenderEmailTemplateResult {
        public partnerSoapSforceCom.RenderEmailTemplateBodyResult[] bodyResults;
        public partnerSoapSforceCom.Error[] errors;
        public Boolean success;
        private String[] bodyResults_type_info = new String[]{'bodyResults','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'bodyResults','errors','success'};
    }
    public class describeSoqlListViews_element {
        public partnerSoapSforceCom.DescribeSoqlListViewsRequest request;
        private String[] request_type_info = new String[]{'request','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class invalidateSessions_element {
        public String[] sessionIds;
        private String[] sessionIds_type_info = new String[]{'sessionIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionIds'};
    }
    public class describeVisualForce_element {
        public Boolean includeAllDetails;
        public String namespacePrefix;
        private String[] includeAllDetails_type_info = new String[]{'includeAllDetails','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'includeAllDetails','namespacePrefix'};
    }
    public class FieldDiff {
        public String difference;
        public String name;
        private String[] difference_type_info = new String[]{'difference','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'difference','name'};
    }
    public class DescribeSoqlListViewsRequest {
        public partnerSoapSforceCom.DescribeSoqlListViewParams[] listViewParams;
        private String[] listViewParams_type_info = new String[]{'listViewParams','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'listViewParams'};
    }
    public class describeAppMenu_element {
        public String appMenuType;
        public String networkId;
        private String[] appMenuType_type_info = new String[]{'appMenuType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] networkId_type_info = new String[]{'networkId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'appMenuType','networkId'};
    }
    public class describeQuickActionsForRecordType_element {
        public String[] quickActions;
        public String recordTypeId;
        private String[] quickActions_type_info = new String[]{'quickActions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActions','recordTypeId'};
    }
    public class describeDataCategoryGroupsResponse_element {
        public partnerSoapSforceCom.DescribeDataCategoryGroupResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','100','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class retrieveMassQuickActionTemplatesResponse_element {
        public partnerSoapSforceCom.QuickActionTemplateResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class ResetPasswordResult {
        public String password;
        private String[] password_type_info = new String[]{'password','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'password'};
    }
    public class DescribePathAssistantStep {
        public Boolean closed;
        public Boolean converted;
        public partnerSoapSforceCom.DescribePathAssistantField[] fields;
        public String info;
        public partnerSoapSforceCom.DescribeLayoutSection layoutSection;
        public String picklistLabel;
        public String picklistValue;
        public Boolean won;
        private String[] closed_type_info = new String[]{'closed','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] converted_type_info = new String[]{'converted','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] fields_type_info = new String[]{'fields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] info_type_info = new String[]{'info','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] layoutSection_type_info = new String[]{'layoutSection','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] picklistLabel_type_info = new String[]{'picklistLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistValue_type_info = new String[]{'picklistValue','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] won_type_info = new String[]{'won','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'closed','converted','fields','info','layoutSection','picklistLabel','picklistValue','won'};
    }
    public class setPassword_element {
        public String userId;
        public String password;
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'userId','password'};
    }
    public class DescribeQuickActionListResult {
        public partnerSoapSforceCom.DescribeQuickActionListItemResult[] quickActionListItems;
        private String[] quickActionListItems_type_info = new String[]{'quickActionListItems','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionListItems'};
    }
    public class GetUpdatedResult {
        public String[] ids;
        public DateTime latestDateCovered;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] latestDateCovered_type_info = new String[]{'latestDateCovered','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids','latestDateCovered'};
    }
    public class ExecuteListViewResult {
        public partnerSoapSforceCom.ListViewColumn[] columns;
        public String developerName;
        public Boolean done;
        public String id;
        public String label;
        public partnerSoapSforceCom.ListViewRecord[] records;
        public Integer size;
        private String[] columns_type_info = new String[]{'columns','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] developerName_type_info = new String[]{'developerName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] done_type_info = new String[]{'done','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] records_type_info = new String[]{'records','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] size_type_info = new String[]{'size','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'columns','developerName','done','id','label','records','size'};
    }
    public class merge_element {
        public partnerSoapSforceCom.MergeRequest[] request;
        private String[] request_type_info = new String[]{'request','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class RelatedListSort {
        public Boolean ascending;
        public String column;
        private String[] ascending_type_info = new String[]{'ascending','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] column_type_info = new String[]{'column','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ascending','column'};
    }
    public class search_element {
        public String searchString;
        private String[] searchString_type_info = new String[]{'searchString','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'searchString'};
    }
    public class DuplicateError {
        public partnerSoapSforceCom.DuplicateResult duplicateResult;
        private String[] duplicateResult_type_info = new String[]{'duplicateResult','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'duplicateResult'};
    }
    public class describeTabsResponse_element {
        public partnerSoapSforceCom.DescribeTabSetResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class SendEmailResult {
        public partnerSoapSforceCom.SendEmailError[] errors;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','success'};
    }
    public class MruHeader_element {
        public Boolean updateMru;
        private String[] updateMru_type_info = new String[]{'updateMru','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'updateMru'};
    }
    public class createResponse_element {
        public partnerSoapSforceCom.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeVisualForceResponse_element {
        public partnerSoapSforceCom.DescribeVisualForceResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class logout_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetServerTimestampResult {
        public DateTime timestamp;
        private String[] timestamp_type_info = new String[]{'timestamp','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'timestamp'};
    }
    public class retrieveQuickActionTemplatesResponse_element {
        public partnerSoapSforceCom.QuickActionTemplateResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class QueryResult {
        public Boolean done;
        public String queryLocator;
        public partnerSoapSforceCom.sObject_x[] records;
        public Integer size;
        private String[] done_type_info = new String[]{'done','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] queryLocator_type_info = new String[]{'queryLocator','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] records_type_info = new String[]{'records','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] size_type_info = new String[]{'size','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'done','queryLocator','records','size'};
    }
    public class delete_element {
        public String[] ids;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids'};
    }
    public class DescribeSoqlListViewResult {
        public partnerSoapSforceCom.DescribeSoqlListView[] describeSoqlListViews;
        private String[] describeSoqlListViews_type_info = new String[]{'describeSoqlListViews','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'describeSoqlListViews'};
    }
    public class GetDeletedResult {
        public partnerSoapSforceCom.DeletedRecord[] deletedRecords;
        public DateTime earliestDateAvailable;
        public DateTime latestDateCovered;
        private String[] deletedRecords_type_info = new String[]{'deletedRecords','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] earliestDateAvailable_type_info = new String[]{'earliestDateAvailable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] latestDateCovered_type_info = new String[]{'latestDateCovered','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'deletedRecords','earliestDateAvailable','latestDateCovered'};
    }
    public class DescribeNounResult {
        public partnerSoapSforceCom.NameCaseValue[] caseValues;
        public String developerName;
        public String gender;
        public String name;
        public String pluralAlias;
        public String startsWith;
        private String[] caseValues_type_info = new String[]{'caseValues','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] developerName_type_info = new String[]{'developerName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] gender_type_info = new String[]{'gender','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] pluralAlias_type_info = new String[]{'pluralAlias','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] startsWith_type_info = new String[]{'startsWith','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'caseValues','developerName','gender','name','pluralAlias','startsWith'};
    }
    public class EntitySpellCorrectionMetadata {
        public String correctedQuery;
        public Boolean hasNonCorrectedResults;
        private String[] correctedQuery_type_info = new String[]{'correctedQuery','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] hasNonCorrectedResults_type_info = new String[]{'hasNonCorrectedResults','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'correctedQuery','hasNonCorrectedResults'};
    }
    public class queryMore_element {
        public String queryLocator;
        private String[] queryLocator_type_info = new String[]{'queryLocator','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryLocator'};
    }
    public class SearchLayoutFieldsDisplayed {
        public Boolean applicable;
        public partnerSoapSforceCom.SearchLayoutField[] fields;
        private String[] applicable_type_info = new String[]{'applicable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] fields_type_info = new String[]{'fields','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'applicable','fields'};
    }
    public class emptyRecycleBinResponse_element {
        public partnerSoapSforceCom.EmptyRecycleBinResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class PicklistForRecordType {
        public String picklistName;
        public partnerSoapSforceCom.PicklistEntry[] picklistValues;
        private String[] picklistName_type_info = new String[]{'picklistName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'picklistName','picklistValues'};
    }
    public class DescribeLayoutFeedView {
        public partnerSoapSforceCom.DescribeLayoutFeedFilter[] feedFilters;
        private String[] feedFilters_type_info = new String[]{'feedFilters','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'feedFilters'};
    }
    public class describeCompactLayoutsResponse_element {
        public partnerSoapSforceCom.DescribeCompactLayoutsResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class StringList {
        public String[] values;
        private String[] values_type_info = new String[]{'values','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'values'};
    }
    public class RecordTypeMapping {
        public Boolean active;
        public Boolean available;
        public Boolean defaultRecordTypeMapping;
        public String developerName;
        public String layoutId;
        public Boolean master;
        public String name;
        public partnerSoapSforceCom.PicklistForRecordType[] picklistsForRecordType;
        public String recordTypeId;
        private String[] active_type_info = new String[]{'active','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] available_type_info = new String[]{'available','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] defaultRecordTypeMapping_type_info = new String[]{'defaultRecordTypeMapping','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layoutId_type_info = new String[]{'layoutId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] master_type_info = new String[]{'master','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistsForRecordType_type_info = new String[]{'picklistsForRecordType','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','available','defaultRecordTypeMapping','developerName','layoutId','master','name','picklistsForRecordType','recordTypeId'};
    }
    public class convertLead_element {
        public partnerSoapSforceCom.LeadConvert[] leadConverts;
        private String[] leadConverts_type_info = new String[]{'leadConverts','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'leadConverts'};
    }
    public class StreamingEnabledHeader_element {
        public Boolean streamingEnabled;
        private String[] streamingEnabled_type_info = new String[]{'streamingEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'streamingEnabled'};
    }
    public class AnalyticsCloudComponent {
        public String error;
        public String filter;
        public String height;
        public Boolean hideOnError;
        public Boolean showSharing;
        public Boolean showTitle;
        public String width;
        private String[] error_type_info = new String[]{'error','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] filter_type_info = new String[]{'filter','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] hideOnError_type_info = new String[]{'hideOnError','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showSharing_type_info = new String[]{'showSharing','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showTitle_type_info = new String[]{'showTitle','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] width_type_info = new String[]{'width','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'error','filter','height','hideOnError','showSharing','showTitle','width'};
    }
    public class RelatedContent {
        public partnerSoapSforceCom.DescribeRelatedContentItem[] relatedContentItems;
        private String[] relatedContentItems_type_info = new String[]{'relatedContentItems','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'relatedContentItems'};
    }
    public class SearchLayoutButton {
        public String apiName;
        public String label;
        private String[] apiName_type_info = new String[]{'apiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'apiName','label'};
    }
    public class PerformQuickActionRequest {
        public String contextId;
        public String quickActionName;
        public partnerSoapSforceCom.sObject_x[] records;
        private String[] contextId_type_info = new String[]{'contextId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] quickActionName_type_info = new String[]{'quickActionName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] records_type_info = new String[]{'records','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'contextId','quickActionName','records'};
    }
    public class DuplicateResult {
        public Boolean allowSave;
        public String duplicateRule;
        public String duplicateRuleEntityType;
        public String errorMessage;
        public partnerSoapSforceCom.MatchResult[] matchResults;
        private String[] allowSave_type_info = new String[]{'allowSave','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] duplicateRule_type_info = new String[]{'duplicateRule','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] duplicateRuleEntityType_type_info = new String[]{'duplicateRuleEntityType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] matchResults_type_info = new String[]{'matchResults','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allowSave','duplicateRule','duplicateRuleEntityType','errorMessage','matchResults'};
    }
    public class getUserInfo_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class DescribeTab {
        public partnerSoapSforceCom.DescribeColor[] colors;
        public Boolean custom;
        public String iconUrl;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String label;
        public String miniIconUrl;
        public String name;
        public String sobjectName;
        public String url;
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] iconUrl_type_info = new String[]{'iconUrl','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] miniIconUrl_type_info = new String[]{'miniIconUrl','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sobjectName_type_info = new String[]{'sobjectName','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'colors','custom','iconUrl','icons','label','miniIconUrl','name','sobjectName','url'};
    }
    public class LabelsSearchMetadata {
        public partnerSoapSforceCom.NameValuePair[] entityFieldLabels;
        public String entityName;
        private String[] entityFieldLabels_type_info = new String[]{'entityFieldLabels','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] entityName_type_info = new String[]{'entityName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityFieldLabels','entityName'};
    }
    public class describeQuickActionsForRecordTypeResponse_element {
        public partnerSoapSforceCom.DescribeQuickActionResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class EntitySearchPromotionMetadata {
        public Integer promotedResultCount;
        private String[] promotedResultCount_type_info = new String[]{'promotedResultCount','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'promotedResultCount'};
    }
    public class process_element {
        public partnerSoapSforceCom.ProcessRequest[] actions;
        private String[] actions_type_info = new String[]{'actions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actions'};
    }
    public class DescribeTabSetResult {
        public String description;
        public String label;
        public String logoUrl;
        public String namespace;
        public Boolean selected;
        public String tabSetId;
        public partnerSoapSforceCom.DescribeTab[] tabs;
        private String[] description_type_info = new String[]{'description','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] logoUrl_type_info = new String[]{'logoUrl','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] selected_type_info = new String[]{'selected','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] tabSetId_type_info = new String[]{'tabSetId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] tabs_type_info = new String[]{'tabs','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'description','label','logoUrl','namespace','selected','tabSetId','tabs'};
    }
    public class DescribeSearchableEntityResult {
        public String label;
        public String name;
        public String pluralLabel;
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] pluralLabel_type_info = new String[]{'pluralLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'label','name','pluralLabel'};
    }
    public class LoginResult {
        public String metadataServerUrl;
        public Boolean passwordExpired;
        public Boolean sandbox;
        public String serverUrl;
        public String sessionId;
        public String userId;
        public partnerSoapSforceCom.GetUserInfoResult userInfo;
        private String[] metadataServerUrl_type_info = new String[]{'metadataServerUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] passwordExpired_type_info = new String[]{'passwordExpired','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sandbox_type_info = new String[]{'sandbox','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] serverUrl_type_info = new String[]{'serverUrl','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sessionId_type_info = new String[]{'sessionId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] userInfo_type_info = new String[]{'userInfo','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'metadataServerUrl','passwordExpired','sandbox','serverUrl','sessionId','userId','userInfo'};
    }
    public class describeKnowledgeSettings_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class LimitInfo {
        public Integer current;
        public Integer limit_x;
        public String type_x;
        private String[] current_type_info = new String[]{'current','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] limit_x_type_info = new String[]{'limit','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'current','limit_x','type_x'};
    }
    public class EntityIntentQueryMetadata {
        public Boolean intentQuery;
        public String message;
        private String[] intentQuery_type_info = new String[]{'intentQuery','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'intentQuery','message'};
    }
    public class describeSoftphoneLayout_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class renderStoredEmailTemplate_element {
        public partnerSoapSforceCom.RenderStoredEmailTemplateRequest request;
        private String[] request_type_info = new String[]{'request','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class describeThemeResponse_element {
        public partnerSoapSforceCom.DescribeThemeResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class performQuickActionsResponse_element {
        public partnerSoapSforceCom.PerformQuickActionResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class QuickActionTemplateResult {
        public String contextId;
        public partnerSoapSforceCom.sObject_x defaultValueFormulas;
        public partnerSoapSforceCom.sObject_x defaultValues;
        public partnerSoapSforceCom.Error[] errors;
        public Boolean success;
        private String[] contextId_type_info = new String[]{'contextId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] defaultValueFormulas_type_info = new String[]{'defaultValueFormulas','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] defaultValues_type_info = new String[]{'defaultValues','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'contextId','defaultValueFormulas','defaultValues','errors','success'};
    }
    public class DescribeSoqlListView {
        public partnerSoapSforceCom.ListViewColumn[] columns;
        public String id;
        public partnerSoapSforceCom.ListViewOrderBy[] orderBy;
        public String query;
        public String relatedEntityId;
        public String scope;
        public String scopeEntityId;
        public String sobjectType;
        public partnerSoapSforceCom.SoqlWhereCondition whereCondition;
        private String[] columns_type_info = new String[]{'columns','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] orderBy_type_info = new String[]{'orderBy','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] query_type_info = new String[]{'query','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] relatedEntityId_type_info = new String[]{'relatedEntityId','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] scope_type_info = new String[]{'scope','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] scopeEntityId_type_info = new String[]{'scopeEntityId','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] sobjectType_type_info = new String[]{'sobjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] whereCondition_type_info = new String[]{'whereCondition','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'columns','id','orderBy','query','relatedEntityId','scope','scopeEntityId','sobjectType','whereCondition'};
    }
    public class upsertResponse_element {
        public partnerSoapSforceCom.UpsertResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeDataCategoryGroupStructuresResponse_element {
        public partnerSoapSforceCom.DescribeDataCategoryGroupStructureResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','100','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class retrieveResponse_element {
        public partnerSoapSforceCom.sObject_x[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class convertLeadResponse_element {
        public partnerSoapSforceCom.LeadConvertResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class getDeletedResponse_element {
        public partnerSoapSforceCom.GetDeletedResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeSearchableEntities_element {
        public Boolean includeOnlyEntitiesWithTabs;
        private String[] includeOnlyEntitiesWithTabs_type_info = new String[]{'includeOnlyEntitiesWithTabs','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'includeOnlyEntitiesWithTabs'};
    }
    public class RenderEmailTemplateRequest {
        public Boolean escapeHtmlInMergeFields;
        public String[] templateBodies;
        public String whatId;
        public String whoId;
        private String[] escapeHtmlInMergeFields_type_info = new String[]{'escapeHtmlInMergeFields','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] templateBodies_type_info = new String[]{'templateBodies','urn:partner.soap.sforce.com',null,'1','10','false'};
        private String[] whatId_type_info = new String[]{'whatId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] whoId_type_info = new String[]{'whoId','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'escapeHtmlInMergeFields','templateBodies','whatId','whoId'};
    }
    public class describeCompactLayouts_element {
        public String sObjectType;
        public String[] recordTypeIds;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeIds_type_info = new String[]{'recordTypeIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','recordTypeIds'};
    }
    public class getUserInfoResponse_element {
        public partnerSoapSforceCom.GetUserInfoResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeKnowledgeSettingsResponse_element {
        public partnerSoapSforceCom.KnowledgeSettings result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class findDuplicatesByIds_element {
        public String[] ids;
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ids'};
    }
    public class renderEmailTemplateResponse_element {
        public partnerSoapSforceCom.RenderEmailTemplateResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','10','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class queryAll_element {
        public String queryString;
        private String[] queryString_type_info = new String[]{'queryString','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryString'};
    }
    public class SearchRecordMetadata {
        public Boolean searchPromoted;
        public Boolean spellCorrected;
        private String[] searchPromoted_type_info = new String[]{'searchPromoted','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] spellCorrected_type_info = new String[]{'spellCorrected','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'searchPromoted','spellCorrected'};
    }
    public class executeListViewResponse_element {
        public partnerSoapSforceCom.ExecuteListViewResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class RecordTypesSupported {
        public partnerSoapSforceCom.RecordTypeInfo[] recordTypeInfos;
        private String[] recordTypeInfos_type_info = new String[]{'recordTypeInfos','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'recordTypeInfos'};
    }
    public class NamedLayoutInfo {
        public String name;
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'name'};
    }
    public class describeAllTabs_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class retrieveMassQuickActionTemplates_element {
        public String quickActionName;
        public String[] contextIds;
        private String[] quickActionName_type_info = new String[]{'quickActionName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] contextIds_type_info = new String[]{'contextIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionName','contextIds'};
    }
    public class PackageVersionHeader_element {
        public partnerSoapSforceCom.PackageVersion[] packageVersions;
        private String[] packageVersions_type_info = new String[]{'packageVersions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'packageVersions'};
    }
    public class DescribeSoftphoneLayoutSection {
        public String entityApiName;
        public partnerSoapSforceCom.DescribeSoftphoneLayoutItem[] items;
        private String[] entityApiName_type_info = new String[]{'entityApiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] items_type_info = new String[]{'items','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityApiName','items'};
    }
    public class performQuickActions_element {
        public partnerSoapSforceCom.PerformQuickActionRequest[] quickActions;
        private String[] quickActions_type_info = new String[]{'quickActions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActions'};
    }
    public class getUpdated_element {
        public String sObjectType;
        public DateTime startDate;
        public DateTime endDate;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','startDate','endDate'};
    }
    public class DisableFeedTrackingHeader_element {
        public Boolean disableFeedTracking;
        private String[] disableFeedTracking_type_info = new String[]{'disableFeedTracking','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'disableFeedTracking'};
    }
    public class DescribeLayoutFeedFilter {
        public String label;
        public String name;
        public String type_x;
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'label','name','type_x'};
    }
    public class describeSearchableEntitiesResponse_element {
        public partnerSoapSforceCom.DescribeSearchableEntityResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class EntitySearchMetadata {
        public String entityName;
        public partnerSoapSforceCom.EntityErrorMetadata errorMetadata;
        public partnerSoapSforceCom.FieldLevelSearchMetadata[] fieldMetadata;
        public partnerSoapSforceCom.EntityIntentQueryMetadata intentQueryMetadata;
        public partnerSoapSforceCom.EntitySearchPromotionMetadata searchPromotionMetadata;
        public partnerSoapSforceCom.EntitySpellCorrectionMetadata spellCorrectionMetadata;
        private String[] entityName_type_info = new String[]{'entityName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] errorMetadata_type_info = new String[]{'errorMetadata','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] fieldMetadata_type_info = new String[]{'fieldMetadata','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] intentQueryMetadata_type_info = new String[]{'intentQueryMetadata','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] searchPromotionMetadata_type_info = new String[]{'searchPromotionMetadata','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] spellCorrectionMetadata_type_info = new String[]{'spellCorrectionMetadata','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'entityName','errorMetadata','fieldMetadata','intentQueryMetadata','searchPromotionMetadata','spellCorrectionMetadata'};
    }
    public class DescribeLayoutButton {
        public String behavior;
        public partnerSoapSforceCom.DescribeColor[] colors;
        public String content;
        public String contentSource;
        public Boolean custom;
        public String encoding;
        public Integer height;
        public partnerSoapSforceCom.DescribeIcon[] icons;
        public String label;
        public Boolean menubar;
        public String name;
        public Boolean overridden;
        public Boolean resizeable;
        public Boolean scrollbars;
        public Boolean showsLocation;
        public Boolean showsStatus;
        public Boolean toolbar;
        public String url;
        public Integer width;
        public String windowPosition;
        private String[] behavior_type_info = new String[]{'behavior','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] colors_type_info = new String[]{'colors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] content_type_info = new String[]{'content','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] contentSource_type_info = new String[]{'contentSource','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] encoding_type_info = new String[]{'encoding','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] height_type_info = new String[]{'height','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] icons_type_info = new String[]{'icons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] menubar_type_info = new String[]{'menubar','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] overridden_type_info = new String[]{'overridden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] resizeable_type_info = new String[]{'resizeable','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] scrollbars_type_info = new String[]{'scrollbars','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] showsLocation_type_info = new String[]{'showsLocation','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] showsStatus_type_info = new String[]{'showsStatus','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] toolbar_type_info = new String[]{'toolbar','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] width_type_info = new String[]{'width','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] windowPosition_type_info = new String[]{'windowPosition','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'behavior','colors','content','contentSource','custom','encoding','height','icons','label','menubar','name','overridden','resizeable','scrollbars','showsLocation','showsStatus','toolbar','url','width','windowPosition'};
    }
    public class DescribeGlobalSObjectResult {
        public Boolean activateable;
        public String associateEntityType;
        public String associateParentEntity;
        public Boolean createable;
        public Boolean custom;
        public Boolean customSetting;
        public Boolean dataTranslationEnabled;
        public Boolean deepCloneable;
        public Boolean deletable;
        public Boolean deprecatedAndHidden;
        public Boolean feedEnabled;
        public Boolean hasSubtypes;
        public Boolean idEnabled;
        public Boolean isInterface;
        public Boolean isSubtype;
        public String keyPrefix;
        public String label;
        public String labelPlural;
        public Boolean layoutable;
        public Boolean mergeable;
        public Boolean mruEnabled;
        public String name;
        public Boolean queryable;
        public Boolean replicateable;
        public Boolean retrieveable;
        public Boolean searchable;
        public Boolean triggerable;
        public Boolean undeletable;
        public Boolean updateable;
        private String[] activateable_type_info = new String[]{'activateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] associateEntityType_type_info = new String[]{'associateEntityType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] associateParentEntity_type_info = new String[]{'associateParentEntity','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] createable_type_info = new String[]{'createable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] customSetting_type_info = new String[]{'customSetting','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] dataTranslationEnabled_type_info = new String[]{'dataTranslationEnabled','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] deepCloneable_type_info = new String[]{'deepCloneable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] deletable_type_info = new String[]{'deletable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] feedEnabled_type_info = new String[]{'feedEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] hasSubtypes_type_info = new String[]{'hasSubtypes','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] idEnabled_type_info = new String[]{'idEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isInterface_type_info = new String[]{'isInterface','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] isSubtype_type_info = new String[]{'isSubtype','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] keyPrefix_type_info = new String[]{'keyPrefix','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] labelPlural_type_info = new String[]{'labelPlural','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layoutable_type_info = new String[]{'layoutable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mergeable_type_info = new String[]{'mergeable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] mruEnabled_type_info = new String[]{'mruEnabled','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] queryable_type_info = new String[]{'queryable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] replicateable_type_info = new String[]{'replicateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] retrieveable_type_info = new String[]{'retrieveable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchable_type_info = new String[]{'searchable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] triggerable_type_info = new String[]{'triggerable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] undeletable_type_info = new String[]{'undeletable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] updateable_type_info = new String[]{'updateable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'activateable','associateEntityType','associateParentEntity','createable','custom','customSetting','dataTranslationEnabled','deepCloneable','deletable','deprecatedAndHidden','feedEnabled','hasSubtypes','idEnabled','isInterface','isSubtype','keyPrefix','label','labelPlural','layoutable','mergeable','mruEnabled','name','queryable','replicateable','retrieveable','searchable','triggerable','undeletable','updateable'};
    }
    public class DescribeSoftphoneLayoutItem {
        public String itemApiName;
        private String[] itemApiName_type_info = new String[]{'itemApiName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'itemApiName'};
    }
    public class ProcessRequest {
        public String comments;
        public String[] nextApproverIds;
        private String[] comments_type_info = new String[]{'comments','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] nextApproverIds_type_info = new String[]{'nextApproverIds','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'comments','nextApproverIds'};
    }
    public class NameObjectValuePair {
        public Boolean isVisible;
        public String name;
        public String[] value;
        private String[] isVisible_type_info = new String[]{'isVisible','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'isVisible','name','value'};
    }
    public class ListViewRecordColumn {
        public String fieldNameOrPath;
        public String value;
        private String[] fieldNameOrPath_type_info = new String[]{'fieldNameOrPath','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldNameOrPath','value'};
    }
    public class AssignmentRuleHeader_element {
        public String assignmentRuleId;
        public Boolean useDefaultRule;
        private String[] assignmentRuleId_type_info = new String[]{'assignmentRuleId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] useDefaultRule_type_info = new String[]{'useDefaultRule','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'assignmentRuleId','useDefaultRule'};
    }
    public class describeQuickActions_element {
        public String[] quickActions;
        private String[] quickActions_type_info = new String[]{'quickActions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'quickActions'};
    }
    public class DescribePathAssistantsResult {
        public partnerSoapSforceCom.DescribePathAssistant[] pathAssistants;
        private String[] pathAssistants_type_info = new String[]{'pathAssistants','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'pathAssistants'};
    }
    public class describeAvailableQuickActions_element {
        public String contextType;
        private String[] contextType_type_info = new String[]{'contextType','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'contextType'};
    }
    public class SoqlCondition {
        public String field;
        public String operator;
        public String[] values;
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] values_type_info = new String[]{'values','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'field','operator','values'};
    }
    public class DescribeApprovalLayout {
        public String id;
        public String label;
        public partnerSoapSforceCom.DescribeLayoutItem[] layoutItems;
        public String name;
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] layoutItems_type_info = new String[]{'layoutItems','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'id','label','layoutItems','name'};
    }
    public class describeTabs_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SearchLayoutButtonsDisplayed {
        public Boolean applicable;
        public partnerSoapSforceCom.SearchLayoutButton[] buttons;
        private String[] applicable_type_info = new String[]{'applicable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] buttons_type_info = new String[]{'buttons','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'applicable','buttons'};
    }
    public class SendEmailError {
        public String[] fields;
        public String message;
        public String statusCode;
        public String targetObjectId;
        private String[] fields_type_info = new String[]{'fields','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] message_type_info = new String[]{'message','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] targetObjectId_type_info = new String[]{'targetObjectId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fields','message','statusCode','targetObjectId'};
    }
    public class VisualforcePage {
        public Boolean showLabel;
        public Boolean showScrollbars;
        public String suggestedHeight;
        public String suggestedWidth;
        public String url;
        private String[] showLabel_type_info = new String[]{'showLabel','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] showScrollbars_type_info = new String[]{'showScrollbars','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] suggestedHeight_type_info = new String[]{'suggestedHeight','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] suggestedWidth_type_info = new String[]{'suggestedWidth','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'showLabel','showScrollbars','suggestedHeight','suggestedWidth','url'};
    }
    public class ProcessWorkitemRequest {
        public String action;
        public String workitemId;
        private String[] action_type_info = new String[]{'action','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] workitemId_type_info = new String[]{'workitemId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'action','workitemId'};
    }
    public class describeSearchScopeOrderResponse_element {
        public partnerSoapSforceCom.DescribeSearchScopeOrderResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeTheme_element {
        public String[] sobjectType;
        private String[] sobjectType_type_info = new String[]{'sobjectType','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sobjectType'};
    }
    public class RelationshipReferenceTo {
        public String[] referenceTo;
        private String[] referenceTo_type_info = new String[]{'referenceTo','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'referenceTo'};
    }
    public class NameValuePair {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public class describeSoqlListViewsResponse_element {
        public partnerSoapSforceCom.DescribeSoqlListViewResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class OwnerChangeOption {
        public String type_x;
        public Boolean execute;
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] execute_type_info = new String[]{'execute','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','execute'};
    }
    public class FieldComponent {
        public partnerSoapSforceCom.Field field;
        private String[] field_type_info = new String[]{'field','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public class DescribeThemeResult {
        public partnerSoapSforceCom.DescribeThemeItem[] themeItems;
        private String[] themeItems_type_info = new String[]{'themeItems','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'themeItems'};
    }
    public class DescribeLayoutRow {
        public partnerSoapSforceCom.DescribeLayoutItem[] layoutItems;
        public Integer numItems;
        private String[] layoutItems_type_info = new String[]{'layoutItems','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] numItems_type_info = new String[]{'numItems','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'layoutItems','numItems'};
    }
    public class DescribeSoftphoneLayoutCallType {
        public partnerSoapSforceCom.DescribeSoftphoneLayoutInfoField[] infoFields;
        public String name;
        public partnerSoapSforceCom.DescribeSoftphoneScreenPopOption[] screenPopOptions;
        public String screenPopsOpenWithin;
        public partnerSoapSforceCom.DescribeSoftphoneLayoutSection[] sections;
        private String[] infoFields_type_info = new String[]{'infoFields','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] screenPopOptions_type_info = new String[]{'screenPopOptions','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] screenPopsOpenWithin_type_info = new String[]{'screenPopsOpenWithin','urn:partner.soap.sforce.com',null,'0','1','false'};
        private String[] sections_type_info = new String[]{'sections','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'infoFields','name','screenPopOptions','screenPopsOpenWithin','sections'};
    }
    public class Error {
        public partnerSoapSforceCom.ExtendedErrorDetails[] extendedErrorDetails;
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] extendedErrorDetails_type_info = new String[]{'extendedErrorDetails','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] fields_type_info = new String[]{'fields','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] message_type_info = new String[]{'message','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorDetails','fields','message','statusCode'};
    }
    public class ScopeInfo {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public class RecordTypeCompactLayoutMapping {
        public Boolean available;
        public String compactLayoutId;
        public String compactLayoutName;
        public String recordTypeId;
        public String recordTypeName;
        private String[] available_type_info = new String[]{'available','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] compactLayoutId_type_info = new String[]{'compactLayoutId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] compactLayoutName_type_info = new String[]{'compactLayoutName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeName_type_info = new String[]{'recordTypeName','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'available','compactLayoutId','compactLayoutName','recordTypeId','recordTypeName'};
    }
    public class CustomLinkComponent {
        public partnerSoapSforceCom.DescribeLayoutButton customLink;
        private String[] customLink_type_info = new String[]{'customLink','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'customLink'};
    }
    public class DescribeGlobalTheme {
        public partnerSoapSforceCom.DescribeGlobalResult global_x;
        public partnerSoapSforceCom.DescribeThemeResult theme;
        private String[] global_x_type_info = new String[]{'global','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] theme_type_info = new String[]{'theme','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'global_x','theme'};
    }
    public class SoqlWhereCondition {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class PerformQuickActionResult {
        public String contextId;
        public Boolean created;
        public partnerSoapSforceCom.Error[] errors;
        public String[] feedItemIds;
        public String[] ids;
        public Boolean success;
        public String successMessage;
        private String[] contextId_type_info = new String[]{'contextId','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] created_type_info = new String[]{'created','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] feedItemIds_type_info = new String[]{'feedItemIds','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] ids_type_info = new String[]{'ids','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] successMessage_type_info = new String[]{'successMessage','urn:partner.soap.sforce.com',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'contextId','created','errors','feedItemIds','ids','success','successMessage'};
    }
    public class KnowledgeLanguageItem {
        public Boolean active;
        public String assigneeId;
        public String name;
        private String[] active_type_info = new String[]{'active','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] assigneeId_type_info = new String[]{'assigneeId','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','assigneeId','name'};
    }
    public class describePathAssistants_element {
        public String sObjectType;
        public String picklistValue;
        public String[] recordTypeIds;
        private String[] sObjectType_type_info = new String[]{'sObjectType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] picklistValue_type_info = new String[]{'picklistValue','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] recordTypeIds_type_info = new String[]{'recordTypeIds','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjectType','picklistValue','recordTypeIds'};
    }
    public class logoutResponse_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class getUpdatedResponse_element {
        public partnerSoapSforceCom.GetUpdatedResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class ListViewColumn {
        public String ascendingLabel;
        public String descendingLabel;
        public String fieldNameOrPath;
        public Boolean hidden;
        public String label;
        public Boolean searchable;
        public String selectListItem;
        public String sortDirection;
        public Integer sortIndex;
        public Boolean sortable;
        public String type_x;
        private String[] ascendingLabel_type_info = new String[]{'ascendingLabel','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] descendingLabel_type_info = new String[]{'descendingLabel','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] fieldNameOrPath_type_info = new String[]{'fieldNameOrPath','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] hidden_type_info = new String[]{'hidden','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] searchable_type_info = new String[]{'searchable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] selectListItem_type_info = new String[]{'selectListItem','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] sortDirection_type_info = new String[]{'sortDirection','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sortIndex_type_info = new String[]{'sortIndex','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] sortable_type_info = new String[]{'sortable','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ascendingLabel','descendingLabel','fieldNameOrPath','hidden','label','searchable','selectListItem','sortDirection','sortIndex','sortable','type_x'};
    }
    public class SoqlNotCondition {
        public partnerSoapSforceCom.SoqlWhereCondition condition;
        private String[] condition_type_info = new String[]{'condition','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'condition'};
    }
    public class UndeleteResult {
        public partnerSoapSforceCom.Error[] errors;
        public String id;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] success_type_info = new String[]{'success','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'errors','id','success'};
    }
    public class describeSObjectResponse_element {
        public partnerSoapSforceCom.DescribeSObjectResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DescribeLayoutComponent {
        public Integer displayLines;
        public Integer tabOrder;
        public String type_x;
        public String value;
        private String[] displayLines_type_info = new String[]{'displayLines','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] tabOrder_type_info = new String[]{'tabOrder','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:partner.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'displayLines','tabOrder','type_x','value'};
    }
    public class FieldLayoutComponent {
        public partnerSoapSforceCom.DescribeLayoutComponent[] components;
        public String fieldType;
        private String[] components_type_info = new String[]{'components','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] fieldType_type_info = new String[]{'fieldType','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'components','fieldType'};
    }
    public class ListViewRecord {
        public partnerSoapSforceCom.ListViewRecordColumn[] columns;
        private String[] columns_type_info = new String[]{'columns','urn:partner.soap.sforce.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'columns'};
    }
    public class queryAllResponse_element {
        public partnerSoapSforceCom.QueryResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class describeGlobalTheme_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Soap {
        public String endpoint_x = 'https://test.salesforce.com/services/Soap/u/55.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public partnerSoapSforceCom.QueryOptions_element QueryOptions;
        public partnerSoapSforceCom.AssignmentRuleHeader_element AssignmentRuleHeader;
        public partnerSoapSforceCom.DisableFeedTrackingHeader_element DisableFeedTrackingHeader;
        public partnerSoapSforceCom.EmailHeader_element EmailHeader;
        public partnerSoapSforceCom.LocaleOptions_element LocaleOptions;
        public partnerSoapSforceCom.DebuggingHeader_element DebuggingHeader;
        public partnerSoapSforceCom.OwnerChangeOptions_element OwnerChangeOptions;
        public partnerSoapSforceCom.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public partnerSoapSforceCom.LimitInfoHeader_element LimitInfoHeader;
        public partnerSoapSforceCom.DebuggingInfo_element DebuggingInfo;
        public partnerSoapSforceCom.PackageVersionHeader_element PackageVersionHeader;
        public partnerSoapSforceCom.AllOrNoneHeader_element AllOrNoneHeader;
        public partnerSoapSforceCom.MruHeader_element MruHeader;
        public partnerSoapSforceCom.SessionHeader_element SessionHeader;
        public partnerSoapSforceCom.CallOptions_element CallOptions;
        public partnerSoapSforceCom.StreamingEnabledHeader_element StreamingEnabledHeader;
        public partnerSoapSforceCom.LoginScopeHeader_element LoginScopeHeader;
        public partnerSoapSforceCom.UserTerritoryDeleteHeader_element UserTerritoryDeleteHeader;
        public partnerSoapSforceCom.DuplicateRuleHeader_element DuplicateRuleHeader;
        private String QueryOptions_hns = 'QueryOptions=urn:partner.soap.sforce.com';
        private String AssignmentRuleHeader_hns = 'AssignmentRuleHeader=urn:partner.soap.sforce.com';
        private String DisableFeedTrackingHeader_hns = 'DisableFeedTrackingHeader=urn:partner.soap.sforce.com';
        private String EmailHeader_hns = 'EmailHeader=urn:partner.soap.sforce.com';
        private String LocaleOptions_hns = 'LocaleOptions=urn:partner.soap.sforce.com';
        private String DebuggingHeader_hns = 'DebuggingHeader=urn:partner.soap.sforce.com';
        private String OwnerChangeOptions_hns = 'OwnerChangeOptions=urn:partner.soap.sforce.com';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=urn:partner.soap.sforce.com';
        private String LimitInfoHeader_hns = 'LimitInfoHeader=urn:partner.soap.sforce.com';
        private String DebuggingInfo_hns = 'DebuggingInfo=urn:partner.soap.sforce.com';
        private String PackageVersionHeader_hns = 'PackageVersionHeader=urn:partner.soap.sforce.com';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=urn:partner.soap.sforce.com';
        private String MruHeader_hns = 'MruHeader=urn:partner.soap.sforce.com';
        private String SessionHeader_hns = 'SessionHeader=urn:partner.soap.sforce.com';
        private String CallOptions_hns = 'CallOptions=urn:partner.soap.sforce.com';
        private String StreamingEnabledHeader_hns = 'StreamingEnabledHeader=urn:partner.soap.sforce.com';
        private String LoginScopeHeader_hns = 'LoginScopeHeader=urn:partner.soap.sforce.com';
        private String UserTerritoryDeleteHeader_hns = 'UserTerritoryDeleteHeader=urn:partner.soap.sforce.com';
        private String DuplicateRuleHeader_hns = 'DuplicateRuleHeader=urn:partner.soap.sforce.com';
        private String[] ns_map_type_info = new String[]{'urn:fault.partner.soap.sforce.com', 'faultPartnerSoapSforceCom', 'urn:sobject.partner.soap.sforce.com', 'partnerSoapSforceCom', 'urn:partner.soap.sforce.com', 'partnerSoapSforceCom'};
        public partnerSoapSforceCom.DescribeTab[] describeAllTabs() {
            partnerSoapSforceCom.describeAllTabs_element request_x = new partnerSoapSforceCom.describeAllTabs_element();
            partnerSoapSforceCom.describeAllTabsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeAllTabsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeAllTabsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeAllTabs',
              'urn:partner.soap.sforce.com',
              'describeAllTabsResponse',
              'partnerSoapSforceCom.describeAllTabsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeDataCategoryGroupStructureResult[] describeDataCategoryGroupStructures(partnerSoapSforceCom.DataCategoryGroupSobjectTypePair[] pairs,Boolean topCategoriesOnly) {
            partnerSoapSforceCom.describeDataCategoryGroupStructures_element request_x = new partnerSoapSforceCom.describeDataCategoryGroupStructures_element();
            request_x.pairs = pairs;
            request_x.topCategoriesOnly = topCategoriesOnly;
            partnerSoapSforceCom.describeDataCategoryGroupStructuresResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeDataCategoryGroupStructuresResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeDataCategoryGroupStructuresResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryGroupStructures',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryGroupStructuresResponse',
              'partnerSoapSforceCom.describeDataCategoryGroupStructuresResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeDataCategoryGroupResult[] describeDataCategoryGroups(String[] sObjectType) {
            partnerSoapSforceCom.describeDataCategoryGroups_element request_x = new partnerSoapSforceCom.describeDataCategoryGroups_element();
            request_x.sObjectType = sObjectType;
            partnerSoapSforceCom.describeDataCategoryGroupsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeDataCategoryGroupsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeDataCategoryGroupsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryGroups',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryGroupsResponse',
              'partnerSoapSforceCom.describeDataCategoryGroupsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.FindDuplicatesResult[] findDuplicates(partnerSoapSforceCom.sObject_x[] sObjects) {
            partnerSoapSforceCom.findDuplicates_element request_x = new partnerSoapSforceCom.findDuplicates_element();
            request_x.sObjects = sObjects;
            partnerSoapSforceCom.findDuplicatesResponse_element response_x;
            Map<String, partnerSoapSforceCom.findDuplicatesResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.findDuplicatesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'findDuplicates',
              'urn:partner.soap.sforce.com',
              'findDuplicatesResponse',
              'partnerSoapSforceCom.findDuplicatesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.ProcessResult[] process(partnerSoapSforceCom.ProcessRequest[] actions) {
            partnerSoapSforceCom.process_element request_x = new partnerSoapSforceCom.process_element();
            request_x.actions = actions;
            partnerSoapSforceCom.processResponse_element response_x;
            Map<String, partnerSoapSforceCom.processResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.processResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'process',
              'urn:partner.soap.sforce.com',
              'processResponse',
              'partnerSoapSforceCom.processResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeGlobalResult describeGlobal() {
            partnerSoapSforceCom.describeGlobal_element request_x = new partnerSoapSforceCom.describeGlobal_element();
            partnerSoapSforceCom.describeGlobalResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeGlobalResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeGlobalResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeGlobal',
              'urn:partner.soap.sforce.com',
              'describeGlobalResponse',
              'partnerSoapSforceCom.describeGlobalResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.GetUserInfoResult getUserInfo() {
            partnerSoapSforceCom.getUserInfo_element request_x = new partnerSoapSforceCom.getUserInfo_element();
            partnerSoapSforceCom.getUserInfoResponse_element response_x;
            Map<String, partnerSoapSforceCom.getUserInfoResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getUserInfoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'getUserInfo',
              'urn:partner.soap.sforce.com',
              'getUserInfoResponse',
              'partnerSoapSforceCom.getUserInfoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeGlobalTheme describeGlobalTheme() {
            partnerSoapSforceCom.describeGlobalTheme_element request_x = new partnerSoapSforceCom.describeGlobalTheme_element();
            partnerSoapSforceCom.describeGlobalThemeResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeGlobalThemeResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeGlobalThemeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeGlobalTheme',
              'urn:partner.soap.sforce.com',
              'describeGlobalThemeResponse',
              'partnerSoapSforceCom.describeGlobalThemeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeApprovalLayoutResult describeApprovalLayout(String sObjectType,String[] approvalProcessNames) {
            partnerSoapSforceCom.describeApprovalLayout_element request_x = new partnerSoapSforceCom.describeApprovalLayout_element();
            request_x.sObjectType = sObjectType;
            request_x.approvalProcessNames = approvalProcessNames;
            partnerSoapSforceCom.describeApprovalLayoutResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeApprovalLayoutResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeApprovalLayoutResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeApprovalLayout',
              'urn:partner.soap.sforce.com',
              'describeApprovalLayoutResponse',
              'partnerSoapSforceCom.describeApprovalLayoutResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeCompactLayout[] describePrimaryCompactLayouts(String[] sObjectTypes) {
            partnerSoapSforceCom.describePrimaryCompactLayouts_element request_x = new partnerSoapSforceCom.describePrimaryCompactLayouts_element();
            request_x.sObjectTypes = sObjectTypes;
            partnerSoapSforceCom.describePrimaryCompactLayoutsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describePrimaryCompactLayoutsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describePrimaryCompactLayoutsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describePrimaryCompactLayouts',
              'urn:partner.soap.sforce.com',
              'describePrimaryCompactLayoutsResponse',
              'partnerSoapSforceCom.describePrimaryCompactLayoutsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.QueryResult queryMore(String queryLocator) {
            partnerSoapSforceCom.queryMore_element request_x = new partnerSoapSforceCom.queryMore_element();
            request_x.queryLocator = queryLocator;
            partnerSoapSforceCom.queryMoreResponse_element response_x;
            Map<String, partnerSoapSforceCom.queryMoreResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.queryMoreResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'queryMore',
              'urn:partner.soap.sforce.com',
              'queryMoreResponse',
              'partnerSoapSforceCom.queryMoreResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSearchableEntityResult[] describeSearchableEntities(Boolean includeOnlyEntitiesWithTabs) {
            partnerSoapSforceCom.describeSearchableEntities_element request_x = new partnerSoapSforceCom.describeSearchableEntities_element();
            request_x.includeOnlyEntitiesWithTabs = includeOnlyEntitiesWithTabs;
            partnerSoapSforceCom.describeSearchableEntitiesResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSearchableEntitiesResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSearchableEntitiesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSearchableEntities',
              'urn:partner.soap.sforce.com',
              'describeSearchableEntitiesResponse',
              'partnerSoapSforceCom.describeSearchableEntitiesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeLayoutResult describeLayout(String sObjectType,String layoutName,String[] recordTypeIds) {
            partnerSoapSforceCom.describeLayout_element request_x = new partnerSoapSforceCom.describeLayout_element();
            request_x.sObjectType = sObjectType;
            request_x.layoutName = layoutName;
            request_x.recordTypeIds = recordTypeIds;
            partnerSoapSforceCom.describeLayoutResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeLayoutResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeLayoutResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeLayout',
              'urn:partner.soap.sforce.com',
              'describeLayoutResponse',
              'partnerSoapSforceCom.describeLayoutResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeAppMenuResult describeAppMenu(String appMenuType,String networkId) {
            partnerSoapSforceCom.describeAppMenu_element request_x = new partnerSoapSforceCom.describeAppMenu_element();
            request_x.appMenuType = appMenuType;
            request_x.networkId = networkId;
            partnerSoapSforceCom.describeAppMenuResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeAppMenuResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeAppMenuResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeAppMenu',
              'urn:partner.soap.sforce.com',
              'describeAppMenuResponse',
              'partnerSoapSforceCom.describeAppMenuResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.LeadConvertResult[] convertLead(partnerSoapSforceCom.LeadConvert[] leadConverts) {
            partnerSoapSforceCom.convertLead_element request_x = new partnerSoapSforceCom.convertLead_element();
            request_x.leadConverts = leadConverts;
            partnerSoapSforceCom.convertLeadResponse_element response_x;
            Map<String, partnerSoapSforceCom.convertLeadResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.convertLeadResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'convertLead',
              'urn:partner.soap.sforce.com',
              'convertLeadResponse',
              'partnerSoapSforceCom.convertLeadResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSoqlListViewResult describeSObjectListViews(String sObjectType,Boolean recentsOnly,String isSoqlCompatible,Integer limit_x,Integer offset) {
            partnerSoapSforceCom.describeSObjectListViews_element request_x = new partnerSoapSforceCom.describeSObjectListViews_element();
            request_x.sObjectType = sObjectType;
            request_x.recentsOnly = recentsOnly;
            request_x.isSoqlCompatible = isSoqlCompatible;
            request_x.limit_x = limit_x;
            request_x.offset = offset;
            partnerSoapSforceCom.describeSObjectListViewsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSObjectListViewsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSObjectListViewsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSObjectListViews',
              'urn:partner.soap.sforce.com',
              'describeSObjectListViewsResponse',
              'partnerSoapSforceCom.describeSObjectListViewsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DeleteResult[] delete_x(String[] ids) {
            partnerSoapSforceCom.delete_element request_x = new partnerSoapSforceCom.delete_element();
            request_x.ids = ids;
            partnerSoapSforceCom.deleteResponse_element response_x;
            Map<String, partnerSoapSforceCom.deleteResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.deleteResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'delete',
              'urn:partner.soap.sforce.com',
              'deleteResponse',
              'partnerSoapSforceCom.deleteResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.LoginResult login(String username,String password) {
            partnerSoapSforceCom.login_element request_x = new partnerSoapSforceCom.login_element();
            request_x.username = username;
            request_x.password = password;
            partnerSoapSforceCom.loginResponse_element response_x;
            Map<String, partnerSoapSforceCom.loginResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.loginResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'login',
              'urn:partner.soap.sforce.com',
              'loginResponse',
              'partnerSoapSforceCom.loginResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.QueryResult queryAll(String queryString) {
            partnerSoapSforceCom.queryAll_element request_x = new partnerSoapSforceCom.queryAll_element();
            request_x.queryString = queryString;
            partnerSoapSforceCom.queryAllResponse_element response_x;
            Map<String, partnerSoapSforceCom.queryAllResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.queryAllResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'queryAll',
              'urn:partner.soap.sforce.com',
              'queryAllResponse',
              'partnerSoapSforceCom.queryAllResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SaveResult[] update_x(partnerSoapSforceCom.sObject_x[] sObjects) {
            partnerSoapSforceCom.update_element request_x = new partnerSoapSforceCom.update_element();
            request_x.sObjects = sObjects;
            partnerSoapSforceCom.updateResponse_element response_x;
            Map<String, partnerSoapSforceCom.updateResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.updateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'update',
              'urn:partner.soap.sforce.com',
              'updateResponse',
              'partnerSoapSforceCom.updateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.EmptyRecycleBinResult[] emptyRecycleBin(String[] ids) {
            partnerSoapSforceCom.emptyRecycleBin_element request_x = new partnerSoapSforceCom.emptyRecycleBin_element();
            request_x.ids = ids;
            partnerSoapSforceCom.emptyRecycleBinResponse_element response_x;
            Map<String, partnerSoapSforceCom.emptyRecycleBinResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.emptyRecycleBinResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'emptyRecycleBin',
              'urn:partner.soap.sforce.com',
              'emptyRecycleBinResponse',
              'partnerSoapSforceCom.emptyRecycleBinResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeCompactLayoutsResult describeCompactLayouts(String sObjectType,String[] recordTypeIds) {
            partnerSoapSforceCom.describeCompactLayouts_element request_x = new partnerSoapSforceCom.describeCompactLayouts_element();
            request_x.sObjectType = sObjectType;
            request_x.recordTypeIds = recordTypeIds;
            partnerSoapSforceCom.describeCompactLayoutsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeCompactLayoutsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeCompactLayoutsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeCompactLayouts',
              'urn:partner.soap.sforce.com',
              'describeCompactLayoutsResponse',
              'partnerSoapSforceCom.describeCompactLayoutsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.ChangeOwnPasswordResult changeOwnPassword(String oldPassword,String newPassword) {
            partnerSoapSforceCom.changeOwnPassword_element request_x = new partnerSoapSforceCom.changeOwnPassword_element();
            request_x.oldPassword = oldPassword;
            request_x.newPassword = newPassword;
            partnerSoapSforceCom.changeOwnPasswordResponse_element response_x;
            Map<String, partnerSoapSforceCom.changeOwnPasswordResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.changeOwnPasswordResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'changeOwnPassword',
              'urn:partner.soap.sforce.com',
              'changeOwnPasswordResponse',
              'partnerSoapSforceCom.changeOwnPasswordResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSoqlListViewResult describeSoqlListViews(partnerSoapSforceCom.DescribeSoqlListViewsRequest request) {
            partnerSoapSforceCom.describeSoqlListViews_element request_x = new partnerSoapSforceCom.describeSoqlListViews_element();
            request_x.request = request;
            partnerSoapSforceCom.describeSoqlListViewsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSoqlListViewsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSoqlListViewsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSoqlListViews',
              'urn:partner.soap.sforce.com',
              'describeSoqlListViewsResponse',
              'partnerSoapSforceCom.describeSoqlListViewsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribePathAssistantsResult describePathAssistants(String sObjectType,String picklistValue,String[] recordTypeIds) {
            partnerSoapSforceCom.describePathAssistants_element request_x = new partnerSoapSforceCom.describePathAssistants_element();
            request_x.sObjectType = sObjectType;
            request_x.picklistValue = picklistValue;
            request_x.recordTypeIds = recordTypeIds;
            partnerSoapSforceCom.describePathAssistantsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describePathAssistantsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describePathAssistantsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describePathAssistants',
              'urn:partner.soap.sforce.com',
              'describePathAssistantsResponse',
              'partnerSoapSforceCom.describePathAssistantsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeAvailableQuickActionResult[] describeAvailableQuickActions(String contextType) {
            partnerSoapSforceCom.describeAvailableQuickActions_element request_x = new partnerSoapSforceCom.describeAvailableQuickActions_element();
            request_x.contextType = contextType;
            partnerSoapSforceCom.describeAvailableQuickActionsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeAvailableQuickActionsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeAvailableQuickActionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeAvailableQuickActions',
              'urn:partner.soap.sforce.com',
              'describeAvailableQuickActionsResponse',
              'partnerSoapSforceCom.describeAvailableQuickActionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.GetDeletedResult getDeleted(String sObjectType,DateTime startDate,DateTime endDate) {
            partnerSoapSforceCom.getDeleted_element request_x = new partnerSoapSforceCom.getDeleted_element();
            request_x.sObjectType = sObjectType;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            partnerSoapSforceCom.getDeletedResponse_element response_x;
            Map<String, partnerSoapSforceCom.getDeletedResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getDeletedResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'getDeleted',
              'urn:partner.soap.sforce.com',
              'getDeletedResponse',
              'partnerSoapSforceCom.getDeletedResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeTabSetResult[] describeTabs() {
            partnerSoapSforceCom.describeTabs_element request_x = new partnerSoapSforceCom.describeTabs_element();
            partnerSoapSforceCom.describeTabsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeTabsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeTabsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeTabs',
              'urn:partner.soap.sforce.com',
              'describeTabsResponse',
              'partnerSoapSforceCom.describeTabsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.QuickActionTemplateResult[] retrieveMassQuickActionTemplates(String quickActionName,String[] contextIds) {
            partnerSoapSforceCom.retrieveMassQuickActionTemplates_element request_x = new partnerSoapSforceCom.retrieveMassQuickActionTemplates_element();
            request_x.quickActionName = quickActionName;
            request_x.contextIds = contextIds;
            partnerSoapSforceCom.retrieveMassQuickActionTemplatesResponse_element response_x;
            Map<String, partnerSoapSforceCom.retrieveMassQuickActionTemplatesResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.retrieveMassQuickActionTemplatesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'retrieveMassQuickActionTemplates',
              'urn:partner.soap.sforce.com',
              'retrieveMassQuickActionTemplatesResponse',
              'partnerSoapSforceCom.retrieveMassQuickActionTemplatesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SearchResult search_x(String searchString) {
            partnerSoapSforceCom.search_element request_x = new partnerSoapSforceCom.search_element();
            request_x.searchString = searchString;
            partnerSoapSforceCom.searchResponse_element response_x;
            Map<String, partnerSoapSforceCom.searchResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.searchResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'search',
              'urn:partner.soap.sforce.com',
              'searchResponse',
              'partnerSoapSforceCom.searchResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SendEmailResult[] sendEmail(partnerSoapSforceCom.Email[] messages) {
            partnerSoapSforceCom.sendEmail_element request_x = new partnerSoapSforceCom.sendEmail_element();
            request_x.messages = messages;
            partnerSoapSforceCom.sendEmailResponse_element response_x;
            Map<String, partnerSoapSforceCom.sendEmailResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.sendEmailResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'sendEmail',
              'urn:partner.soap.sforce.com',
              'sendEmailResponse',
              'partnerSoapSforceCom.sendEmailResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.GetUpdatedResult getUpdated(String sObjectType,DateTime startDate,DateTime endDate) {
            partnerSoapSforceCom.getUpdated_element request_x = new partnerSoapSforceCom.getUpdated_element();
            request_x.sObjectType = sObjectType;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            partnerSoapSforceCom.getUpdatedResponse_element response_x;
            Map<String, partnerSoapSforceCom.getUpdatedResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getUpdatedResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'getUpdated',
              'urn:partner.soap.sforce.com',
              'getUpdatedResponse',
              'partnerSoapSforceCom.getUpdatedResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SendEmailResult[] sendEmailMessage(String[] ids) {
            partnerSoapSforceCom.sendEmailMessage_element request_x = new partnerSoapSforceCom.sendEmailMessage_element();
            request_x.ids = ids;
            partnerSoapSforceCom.sendEmailMessageResponse_element response_x;
            Map<String, partnerSoapSforceCom.sendEmailMessageResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.sendEmailMessageResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'sendEmailMessage',
              'urn:partner.soap.sforce.com',
              'sendEmailMessageResponse',
              'partnerSoapSforceCom.sendEmailMessageResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeQuickActionResult[] describeQuickActionsForRecordType(String[] quickActions,String recordTypeId) {
            partnerSoapSforceCom.describeQuickActionsForRecordType_element request_x = new partnerSoapSforceCom.describeQuickActionsForRecordType_element();
            request_x.quickActions = quickActions;
            request_x.recordTypeId = recordTypeId;
            partnerSoapSforceCom.describeQuickActionsForRecordTypeResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeQuickActionsForRecordTypeResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeQuickActionsForRecordTypeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeQuickActionsForRecordType',
              'urn:partner.soap.sforce.com',
              'describeQuickActionsForRecordTypeResponse',
              'partnerSoapSforceCom.describeQuickActionsForRecordTypeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.RenderEmailTemplateResult[] renderEmailTemplate(partnerSoapSforceCom.RenderEmailTemplateRequest[] renderRequests) {
            partnerSoapSforceCom.renderEmailTemplate_element request_x = new partnerSoapSforceCom.renderEmailTemplate_element();
            request_x.renderRequests = renderRequests;
            partnerSoapSforceCom.renderEmailTemplateResponse_element response_x;
            Map<String, partnerSoapSforceCom.renderEmailTemplateResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.renderEmailTemplateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'renderEmailTemplate',
              'urn:partner.soap.sforce.com',
              'renderEmailTemplateResponse',
              'partnerSoapSforceCom.renderEmailTemplateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.UpsertResult[] upsert_x(String externalIDFieldName,partnerSoapSforceCom.sObject_x[] sObjects) {
            partnerSoapSforceCom.upsert_element request_x = new partnerSoapSforceCom.upsert_element();
            request_x.externalIDFieldName = externalIDFieldName;
            request_x.sObjects = sObjects;
            partnerSoapSforceCom.upsertResponse_element response_x;
            Map<String, partnerSoapSforceCom.upsertResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.upsertResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'upsert',
              'urn:partner.soap.sforce.com',
              'upsertResponse',
              'partnerSoapSforceCom.upsertResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.QueryResult query(String queryString) {
            partnerSoapSforceCom.query_element request_x = new partnerSoapSforceCom.query_element();
            request_x.queryString = queryString;
            partnerSoapSforceCom.queryResponse_element response_x;
            Map<String, partnerSoapSforceCom.queryResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.queryResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'query',
              'urn:partner.soap.sforce.com',
              'queryResponse',
              'partnerSoapSforceCom.queryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeQuickActionResult[] describeQuickActions(String[] quickActions) {
            partnerSoapSforceCom.describeQuickActions_element request_x = new partnerSoapSforceCom.describeQuickActions_element();
            request_x.quickActions = quickActions;
            partnerSoapSforceCom.describeQuickActionsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeQuickActionsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeQuickActionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeQuickActions',
              'urn:partner.soap.sforce.com',
              'describeQuickActionsResponse',
              'partnerSoapSforceCom.describeQuickActionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.PerformQuickActionResult[] performQuickActions(partnerSoapSforceCom.PerformQuickActionRequest[] quickActions) {
            partnerSoapSforceCom.performQuickActions_element request_x = new partnerSoapSforceCom.performQuickActions_element();
            request_x.quickActions = quickActions;
            partnerSoapSforceCom.performQuickActionsResponse_element response_x;
            Map<String, partnerSoapSforceCom.performQuickActionsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.performQuickActionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'performQuickActions',
              'urn:partner.soap.sforce.com',
              'performQuickActionsResponse',
              'partnerSoapSforceCom.performQuickActionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSObjectResult[] describeSObjects(String[] sObjectType) {
            partnerSoapSforceCom.describeSObjects_element request_x = new partnerSoapSforceCom.describeSObjects_element();
            request_x.sObjectType = sObjectType;
            partnerSoapSforceCom.describeSObjectsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSObjectsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSObjectsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSObjects',
              'urn:partner.soap.sforce.com',
              'describeSObjectsResponse',
              'partnerSoapSforceCom.describeSObjectsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.KnowledgeSettings describeKnowledgeSettings() {
            partnerSoapSforceCom.describeKnowledgeSettings_element request_x = new partnerSoapSforceCom.describeKnowledgeSettings_element();
            partnerSoapSforceCom.describeKnowledgeSettingsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeKnowledgeSettingsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeKnowledgeSettingsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeKnowledgeSettings',
              'urn:partner.soap.sforce.com',
              'describeKnowledgeSettingsResponse',
              'partnerSoapSforceCom.describeKnowledgeSettingsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.UndeleteResult[] undelete_x(String[] ids) {
            partnerSoapSforceCom.undelete_element request_x = new partnerSoapSforceCom.undelete_element();
            request_x.ids = ids;
            partnerSoapSforceCom.undeleteResponse_element response_x;
            Map<String, partnerSoapSforceCom.undeleteResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.undeleteResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'undelete',
              'urn:partner.soap.sforce.com',
              'undeleteResponse',
              'partnerSoapSforceCom.undeleteResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.sObject_x[] retrieve_x(String fieldList,String sObjectType,String[] ids) {
            partnerSoapSforceCom.retrieve_element request_x = new partnerSoapSforceCom.retrieve_element();
            request_x.fieldList = fieldList;
            request_x.sObjectType = sObjectType;
            request_x.ids = ids;
            partnerSoapSforceCom.retrieveResponse_element response_x;
            Map<String, partnerSoapSforceCom.retrieveResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.retrieveResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'retrieve',
              'urn:partner.soap.sforce.com',
              'retrieveResponse',
              'partnerSoapSforceCom.retrieveResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeThemeResult describeTheme(String[] sobjectType) {
            partnerSoapSforceCom.describeTheme_element request_x = new partnerSoapSforceCom.describeTheme_element();
            request_x.sobjectType = sobjectType;
            partnerSoapSforceCom.describeThemeResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeThemeResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeThemeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeTheme',
              'urn:partner.soap.sforce.com',
              'describeThemeResponse',
              'partnerSoapSforceCom.describeThemeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DeleteByExampleResult[] deleteByExample(partnerSoapSforceCom.sObject_x[] sObjects) {
            partnerSoapSforceCom.deleteByExample_element request_x = new partnerSoapSforceCom.deleteByExample_element();
            request_x.sObjects = sObjects;
            partnerSoapSforceCom.deleteByExampleResponse_element response_x;
            Map<String, partnerSoapSforceCom.deleteByExampleResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.deleteByExampleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'deleteByExample',
              'urn:partner.soap.sforce.com',
              'deleteByExampleResponse',
              'partnerSoapSforceCom.deleteByExampleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeNounResult[] describeNouns(String[] nouns,Boolean onlyRenamed,Boolean includeFields) {
            partnerSoapSforceCom.describeNouns_element request_x = new partnerSoapSforceCom.describeNouns_element();
            request_x.nouns = nouns;
            request_x.onlyRenamed = onlyRenamed;
            request_x.includeFields = includeFields;
            partnerSoapSforceCom.describeNounsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeNounsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeNounsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeNouns',
              'urn:partner.soap.sforce.com',
              'describeNounsResponse',
              'partnerSoapSforceCom.describeNounsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.FindDuplicatesResult[] findDuplicatesByIds(String[] ids) {
            partnerSoapSforceCom.findDuplicatesByIds_element request_x = new partnerSoapSforceCom.findDuplicatesByIds_element();
            request_x.ids = ids;
            partnerSoapSforceCom.findDuplicatesByIdsResponse_element response_x;
            Map<String, partnerSoapSforceCom.findDuplicatesByIdsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.findDuplicatesByIdsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'findDuplicatesByIds',
              'urn:partner.soap.sforce.com',
              'findDuplicatesByIdsResponse',
              'partnerSoapSforceCom.findDuplicatesByIdsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.ExecuteListViewResult executeListView(partnerSoapSforceCom.ExecuteListViewRequest request) {
            partnerSoapSforceCom.executeListView_element request_x = new partnerSoapSforceCom.executeListView_element();
            request_x.request = request;
            partnerSoapSforceCom.executeListViewResponse_element response_x;
            Map<String, partnerSoapSforceCom.executeListViewResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.executeListViewResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'executeListView',
              'urn:partner.soap.sforce.com',
              'executeListViewResponse',
              'partnerSoapSforceCom.executeListViewResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.RenderStoredEmailTemplateResult renderStoredEmailTemplate(partnerSoapSforceCom.RenderStoredEmailTemplateRequest request) {
            partnerSoapSforceCom.renderStoredEmailTemplate_element request_x = new partnerSoapSforceCom.renderStoredEmailTemplate_element();
            request_x.request = request;
            partnerSoapSforceCom.renderStoredEmailTemplateResponse_element response_x;
            Map<String, partnerSoapSforceCom.renderStoredEmailTemplateResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.renderStoredEmailTemplateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'renderStoredEmailTemplate',
              'urn:partner.soap.sforce.com',
              'renderStoredEmailTemplateResponse',
              'partnerSoapSforceCom.renderStoredEmailTemplateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeVisualForceResult describeVisualForce(Boolean includeAllDetails,String namespacePrefix) {
            partnerSoapSforceCom.describeVisualForce_element request_x = new partnerSoapSforceCom.describeVisualForce_element();
            request_x.includeAllDetails = includeAllDetails;
            request_x.namespacePrefix = namespacePrefix;
            partnerSoapSforceCom.describeVisualForceResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeVisualForceResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeVisualForceResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeVisualForce',
              'urn:partner.soap.sforce.com',
              'describeVisualForceResponse',
              'partnerSoapSforceCom.describeVisualForceResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSObjectResult describeSObject(String sObjectType) {
            partnerSoapSforceCom.describeSObject_element request_x = new partnerSoapSforceCom.describeSObject_element();
            request_x.sObjectType = sObjectType;
            partnerSoapSforceCom.describeSObjectResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSObjectResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSObject',
              'urn:partner.soap.sforce.com',
              'describeSObjectResponse',
              'partnerSoapSforceCom.describeSObjectResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.GetServerTimestampResult getServerTimestamp() {
            partnerSoapSforceCom.getServerTimestamp_element request_x = new partnerSoapSforceCom.getServerTimestamp_element();
            partnerSoapSforceCom.getServerTimestampResponse_element response_x;
            Map<String, partnerSoapSforceCom.getServerTimestampResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getServerTimestampResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'getServerTimestamp',
              'urn:partner.soap.sforce.com',
              'getServerTimestampResponse',
              'partnerSoapSforceCom.getServerTimestampResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.QuickActionTemplateResult[] retrieveQuickActionTemplates(String[] quickActionNames,String contextId) {
            partnerSoapSforceCom.retrieveQuickActionTemplates_element request_x = new partnerSoapSforceCom.retrieveQuickActionTemplates_element();
            request_x.quickActionNames = quickActionNames;
            request_x.contextId = contextId;
            partnerSoapSforceCom.retrieveQuickActionTemplatesResponse_element response_x;
            Map<String, partnerSoapSforceCom.retrieveQuickActionTemplatesResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.retrieveQuickActionTemplatesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'retrieveQuickActionTemplates',
              'urn:partner.soap.sforce.com',
              'retrieveQuickActionTemplatesResponse',
              'partnerSoapSforceCom.retrieveQuickActionTemplatesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SetPasswordResult setPassword(String userId,String password) {
            partnerSoapSforceCom.setPassword_element request_x = new partnerSoapSforceCom.setPassword_element();
            request_x.userId = userId;
            request_x.password = password;
            partnerSoapSforceCom.setPasswordResponse_element response_x;
            Map<String, partnerSoapSforceCom.setPasswordResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.setPasswordResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'setPassword',
              'urn:partner.soap.sforce.com',
              'setPasswordResponse',
              'partnerSoapSforceCom.setPasswordResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.ResetPasswordResult resetPassword(String userId) {
            partnerSoapSforceCom.resetPassword_element request_x = new partnerSoapSforceCom.resetPassword_element();
            request_x.userId = userId;
            partnerSoapSforceCom.resetPasswordResponse_element response_x;
            Map<String, partnerSoapSforceCom.resetPasswordResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.resetPasswordResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'resetPassword',
              'urn:partner.soap.sforce.com',
              'resetPasswordResponse',
              'partnerSoapSforceCom.resetPasswordResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSoftphoneLayoutResult describeSoftphoneLayout() {
            partnerSoapSforceCom.describeSoftphoneLayout_element request_x = new partnerSoapSforceCom.describeSoftphoneLayout_element();
            partnerSoapSforceCom.describeSoftphoneLayoutResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSoftphoneLayoutResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSoftphoneLayoutResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSoftphoneLayout',
              'urn:partner.soap.sforce.com',
              'describeSoftphoneLayoutResponse',
              'partnerSoapSforceCom.describeSoftphoneLayoutResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.SaveResult[] create(partnerSoapSforceCom.sObject_x[] sObjects) {
            partnerSoapSforceCom.create_element request_x = new partnerSoapSforceCom.create_element();
            request_x.sObjects = sObjects;
            partnerSoapSforceCom.createResponse_element response_x;
            Map<String, partnerSoapSforceCom.createResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.createResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'create',
              'urn:partner.soap.sforce.com',
              'createResponse',
              'partnerSoapSforceCom.createResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeSearchLayoutResult[] describeSearchLayouts(String[] sObjectType) {
            partnerSoapSforceCom.describeSearchLayouts_element request_x = new partnerSoapSforceCom.describeSearchLayouts_element();
            request_x.sObjectType = sObjectType;
            partnerSoapSforceCom.describeSearchLayoutsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSearchLayoutsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSearchLayoutsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSearchLayouts',
              'urn:partner.soap.sforce.com',
              'describeSearchLayoutsResponse',
              'partnerSoapSforceCom.describeSearchLayoutsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.MergeResult[] merge_x(partnerSoapSforceCom.MergeRequest[] request) {
            partnerSoapSforceCom.merge_element request_x = new partnerSoapSforceCom.merge_element();
            request_x.request = request;
            partnerSoapSforceCom.mergeResponse_element response_x;
            Map<String, partnerSoapSforceCom.mergeResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.mergeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'merge',
              'urn:partner.soap.sforce.com',
              'mergeResponse',
              'partnerSoapSforceCom.mergeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.InvalidateSessionsResult[] invalidateSessions(String[] sessionIds) {
            partnerSoapSforceCom.invalidateSessions_element request_x = new partnerSoapSforceCom.invalidateSessions_element();
            request_x.sessionIds = sessionIds;
            partnerSoapSforceCom.invalidateSessionsResponse_element response_x;
            Map<String, partnerSoapSforceCom.invalidateSessionsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.invalidateSessionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'invalidateSessions',
              'urn:partner.soap.sforce.com',
              'invalidateSessionsResponse',
              'partnerSoapSforceCom.invalidateSessionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public partnerSoapSforceCom.DescribeDataCategoryMappingResult[] describeDataCategoryMappings() {
            partnerSoapSforceCom.describeDataCategoryMappings_element request_x = new partnerSoapSforceCom.describeDataCategoryMappings_element();
            partnerSoapSforceCom.describeDataCategoryMappingsResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeDataCategoryMappingsResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeDataCategoryMappingsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryMappings',
              'urn:partner.soap.sforce.com',
              'describeDataCategoryMappingsResponse',
              'partnerSoapSforceCom.describeDataCategoryMappingsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public void logout() {
            partnerSoapSforceCom.logout_element request_x = new partnerSoapSforceCom.logout_element();
            partnerSoapSforceCom.logoutResponse_element response_x;
            Map<String, partnerSoapSforceCom.logoutResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.logoutResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'logout',
              'urn:partner.soap.sforce.com',
              'logoutResponse',
              'partnerSoapSforceCom.logoutResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public partnerSoapSforceCom.DescribeSearchScopeOrderResult[] describeSearchScopeOrder(Boolean includeRealTimeEntities) {
            partnerSoapSforceCom.describeSearchScopeOrder_element request_x = new partnerSoapSforceCom.describeSearchScopeOrder_element();
            request_x.includeRealTimeEntities = includeRealTimeEntities;
            partnerSoapSforceCom.describeSearchScopeOrderResponse_element response_x;
            Map<String, partnerSoapSforceCom.describeSearchScopeOrderResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.describeSearchScopeOrderResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'describeSearchScopeOrder',
              'urn:partner.soap.sforce.com',
              'describeSearchScopeOrderResponse',
              'partnerSoapSforceCom.describeSearchScopeOrderResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}