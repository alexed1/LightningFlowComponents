@isTest
public with sharing class MockPicklistValueGenerator implements WebServiceMock{
    final static String RESPONSE_X_LABEL = 'response_x';
    Boolean isSuccessDeploy = true;
    public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'CustomFieldMetadataAPIResponse' LIMIT 1];
            if(request instanceof usf3.MetadataService.readMetadata_element) {
                usf3.MetadataService.CustomField customField = (usf3.MetadataService.CustomField)JSON.deserializeStrict(sr.Body.toString(), usf3.MetadataService.CustomField.class);
                usf3.MetadataService.readCustomFieldResponse_element mtdResponse = new usf3.MetadataService.readCustomFieldResponse_element();
                mtdResponse.result = new usf3.MetadataService.ReadCustomFieldResult();
                mtdResponse.result.records = new List<usf3.MetadataService.CustomField> {customField};

                response.put(RESPONSE_X_LABEL, mtdResponse);
            } else if(request instanceof usf3.MetadataService.updateMetadata_element) {
                usf3.MetadataService.updateMetadataResponse_element mtdRespose = new usf3.MetadataService.updateMetadataResponse_element();
                usf3.MetadataService.SaveResult result = new usf3.MetadataService.SaveResult();
                result.success  = isSuccessDeploy;
                mtdRespose.result = new List<usf3.MetadataService.SaveResult> {result};

                response.put(RESPONSE_X_LABEL, mtdRespose);
            }
			return;
		}
    
    public MockPicklistValueGenerator() {

    }

    public MockPicklistValueGenerator(Boolean isSuccessDeploy) {
        this.isSuccessDeploy = isSuccessDeploy;
    }
}
