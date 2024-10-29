@isTest
public with sharing class GetFlowMetadataTest {
    @isTest
    static void testExecute() {
        GetFlowMetadata.Request request = new GetFlowMetadata.Request();
        request.flowName = 'testflowName';

        GetFlowMetadata.Result result = GetFlowMetadata.execute(new List<GetFlowMetadata.Request> {request})[0];

        System.assert(String.isEmpty(result.errors));

    }
}
