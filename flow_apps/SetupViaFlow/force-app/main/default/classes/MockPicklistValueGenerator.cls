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
            if(request instanceof usf.MetadataService.readMetadata_element) {
                usf.MetadataService.CustomField customField = (usf.MetadataService.CustomField)JSON.deserializeStrict(sr.Body.toString(), usf.MetadataService.CustomField.class);
                usf.MetadataService.readCustomFieldResponse_element mtdResponse = new usf.MetadataService.readCustomFieldResponse_element();
                mtdResponse.result = new usf.MetadataService.ReadCustomFieldResult();
                mtdResponse.result.records = new List<usf.MetadataService.CustomField> {customField};

                response.put(RESPONSE_X_LABEL, mtdResponse);
            } else if(request instanceof usf.MetadataService.updateMetadata_element) {
                usf.MetadataService.updateMetadataResponse_element mtdRespose = new usf.MetadataService.updateMetadataResponse_element();
                usf.MetadataService.SaveResult result = new usf.MetadataService.SaveResult();
                result.success  = isSuccessDeploy;
                mtdRespose.result = new List<usf.MetadataService.SaveResult> {result};

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
