

public class PartnerSoapSforceCom {

    public class sObject_x {
        public String type_x;
        public String[] fieldsToNull;
        public String Id;
        public String OwnerId;

        private String[] type_x_type_info = new String[]{'type','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] OwnerId_type_info = new String[]{'OwnerId','urn:partner.soap.sforce.com','OWNERID','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:sobject.partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fieldsToNull','Id', 'OwnerId'};
    }

    public class updateResponse_element {
        public partnerSoapSforceCom.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }

    public class OwnerChangeOptions_element {
        public partnerSoapSforceCom.OwnerChangeOption[] options;
        private String[] options_type_info = new String[]{'options','urn:partner.soap.sforce.com',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'options'};
    }
 
    public class update_element {
        public partnerSoapSforceCom.sObject_x[] sObjects;
        private String[] sObjects_type_info = new String[]{'sObjects','urn:partner.soap.sforce.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sObjects'};
    }

    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }

    public class OwnerChangeOption {
        public String type_x;
        public Boolean execute;
        private String[] type_x_type_info = new String[]{'type','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] execute_type_info = new String[]{'execute','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','execute'};
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
    public class ExtendedErrorDetails {
        public String extendedErrorCode;
        private String[] extendedErrorCode_type_info = new String[]{'extendedErrorCode','urn:partner.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorCode'};
    }

    public class Soap {
        public String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/55.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public partnerSoapSforceCom.OwnerChangeOptions_element OwnerChangeOptions;
        public partnerSoapSforceCom.SessionHeader_element SessionHeader;
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
    }
}