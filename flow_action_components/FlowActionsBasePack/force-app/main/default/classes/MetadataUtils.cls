global with sharing class MetadataUtils {
    global static MetadataService.Flow getFlowMetadata(String flowName) {
        
        MetadataService.MetadataPort service = MetadataService.createService();

        List<MetadataService.Flow > flowList =  (List<MetadataService.Flow >) service.readMetadata(
                'Flow', 
                new List<String> {flowName}
        ).getRecords();
        System.debug('getFlowMetadata');
        System.debug(JSON.serialize(flowList[0]).replace(',', ',\n'));
        System.debug(flowList[0].startElementReference);
        return flowList[0];
    }

    global static void createFlowMetadata(MetadataService.Flow flow) {
        
            MetadataService.MetadataPort service = MetadataService.createService();

            MetadataService.SaveResult[] saveResultList = service.createMetadata(
                new List<MetadataService.Flow> {flow}
            );

            System.debug('createFlowMetadata');
            System.debug(JSON.serialize(saveResultList).replace(',', ',\n'));
            for(MetadataService.SaveResult saveResult : saveResultList) {
                MetadataService.handleSaveResults(saveResult);
            }
            
            return;

    }

    global static String upsertFlowMetadata(MetadataService.Flow flow) {

            MetadataService.MetadataPort service = MetadataService.createService();

            MetadataService.UpsertResult[]  upsertResultList = service.upsertMetadata(
                new List<MetadataService.Flow> {flow}
            );
            System.debug('upsertFlowMetadata');
            System.debug(JSON.serialize(upsertResultList).replace(',', ',\n'));
            for(MetadataService.UpsertResult upsertResult : upsertResultList) {
                handleUpsertResults(upsertResult);
            }
            
            return flow.fullName;

    }

    global static void handleUpsertResults(MetadataService.UpsertResult upsertResult){
			// Nothing to see?
			if(upsertResult==null || upsertResult.success) {
				System.debug('Metadata Upsert completed successfully');
				return;
			}
		 
			// Construct error message and throw an exception
			if(upsertResult.errors!=null)
			{
				List<String> messages = new List<String>();
				messages.add(
					(upsertResult.errors.size()==1 ? 'Error ' : 'Errors ') +
						'occured processing component ' + upsertResult.fullName + '.');
				for(MetadataService.Error error : upsertResult.errors)
					messages.add(
						error.message + ' (' + error.statusCode + ').' +
						( error.fields!=null && error.fields.size()>0 ?
							' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
				if(messages.size()>0)
					throw new MetadataService.MetadataServiceExamplesException(String.join(messages, ' '));
			}
			if(!upsertResult.success)
				throw new MetadataService.MetadataServiceExamplesException('Request failed with no specified error.');
		}
}