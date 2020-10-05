@isTest
public with sharing class UpdatePermissionSetTest {
    
    @isTest
    public static void CanConvertDMCPermissionSetToMetadataPermissionSet() {

        flowDMC_PermissionSet testPermSetM1 = Fixture_TestPermissionSet_ApexType.testPermSet1();
        fbc_MetadataService.PermissionSet convertedPermissionSet  = UpdatePermissionSet.ConvertApexTypeToMetadataService_PermissionSet(testPermSetM1);

        System.debug('serialized metadataservice permset is:' + JSON.serialize(convertedPermissionSet));
        String expectedSerializedMetadataType = '{"fullName":null,"userPermissions_type_info":["userPermissions","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"userPermissions":null,"type_att_info":["xsi:type"],"type":"PermissionSet","tabSettings_type_info":["tabSettings","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"tabSettings":null,"recordTypeVisibilities_type_info":["recordTypeVisibilities","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"recordTypeVisibilities":[{"visible_type_info":["visible","http://soap.sforce.com/2006/04/metadata",null,"1","1","false"],"visible":true,"recordType_type_info":["recordType","http://soap.sforce.com/2006/04/metadata",null,"1","1","false"],"recordType":"Account.AccountRT1","field_order_type_info":["recordType","visible"],"apex_schema_type_info":["http://soap.sforce.com/2006/04/metadata","true","false"]},{"visible_type_info":["visible","http://soap.sforce.com/2006/04/metadata",null,"1","1","false"],"visible":true,"recordType_type_info":["recordType","http://soap.sforce.com/2006/04/metadata",null,"1","1","false"],"recordType":"Account.AccountRT3","field_order_type_info":["recordType","visible"],"apex_schema_type_info":["http://soap.sforce.com/2006/04/metadata","true","false"]}],"pageAccesses_type_info":["pageAccesses","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"pageAccesses":null,"objectPermissions_type_info":["objectPermissions","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"objectPermissions":null,"license_type_info":["license","http://soap.sforce.com/2006/04/metadata",null,"0","1","false"],"license":null,"label_type_info":["label","http://soap.sforce.com/2006/04/metadata",null,"1","1","false"],"label":null,"hasActivationRequired_type_info":["hasActivationRequired","http://soap.sforce.com/2006/04/metadata",null,"0","1","false"],"hasActivationRequired":null,"fullName_type_info":["fullName","http://soap.sforce.com/2006/04/metadata",null,"0","1","false"],"fullName":null,"fieldPermissions_type_info":["fieldPermissions","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"fieldPermissions":null,"field_order_type_info":["fullName","applicationVisibilities","classAccesses","customPermissions","description","externalDataSourceAccesses","fieldPermissions","hasActivationRequired","label","license","objectPermissions","pageAccesses","recordTypeVisibilities","tabSettings","userPermissions"],"externalDataSourceAccesses_type_info":["externalDataSourceAccesses","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"externalDataSourceAccesses":null,"description_type_info":["description","http://soap.sforce.com/2006/04/metadata",null,"0","1","false"],"description":null,"customPermissions_type_info":["customPermissions","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"customPermissions":null,"classAccesses_type_info":["classAccesses","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"classAccesses":null,"applicationVisibilities_type_info":["applicationVisibilities","http://soap.sforce.com/2006/04/metadata",null,"0","-1","false"],"applicationVisibilities":null,"apex_schema_type_info":["http://soap.sforce.com/2006/04/metadata","true","false"]}';


        System.assertEquals(expectedSerializedMetadataType, JSON.serialize(convertedPermissionSet)); 

        

    }

}
