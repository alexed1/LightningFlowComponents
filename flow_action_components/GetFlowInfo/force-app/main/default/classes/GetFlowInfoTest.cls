@isTest
public with sharing class GetFlowInfoTest {
  
  @isTest
  public static void FlowInfoReturnedProperly() {
    String flowApiName = 'Test_Flow_for_GetFlowInfo';

    List<GetFlowInfo.Request> requests = new  List<GetFlowInfo.Request>();
    GetFlowInfo.Request request = new GetFlowInfo.Request();
    request.FlowApiName = flowApiName;
    requests.add(request);

    GetFlowInfo.executeGetFlowInfo(requests);

    List<GetFlowInfo.Response> responses = new List<GetFlowInfo.Response>();
    GetFlowInfo.Response response = new GetFlowInfo.Response();

    responses = GetFlowInfo.executeGetFlowInfo(requests);
    response = responses[0];
    System.assertEquals(response.FlowApiName, flowApiName);
    System.assertEquals('Flow', response.FlowType);
    System.assertEquals('This is the Description.',response.Description);
  }

  @isTest
  public static void ErrorIfNothingPassed() {
    //String flowApiName = 'Test_Flow_for_GetFlowInfo';

    List<GetFlowInfo.Request> requests = new  List<GetFlowInfo.Request>();
    GetFlowInfo.Request request = new GetFlowInfo.Request();
    //request.FlowApiName = flowApiName;
    requests.add(request);

    GetFlowInfo.FlowActionException  unexpectedException;

    try
    {
        GetFlowInfo.executeGetFlowInfo(requests);
    }
    catch (GetFlowInfo.FlowActionException e)
    {
        unexpectedException = e;
    }

    system.assertEquals('When calling the GetFlowInfo Flow Action, at least one of ApiName or DefinitionId must be provided. Currently both are coming through null.', unexpectedException.getMessage());
    
  }

  @isTest
  public static void EmptyIfBothArePassedIn() {
    String flowApiName = 'Test_Flow_for_GetFlowInfo';
    String flowDefinitionId = '400210000008ksz'; //bogus value

    List<GetFlowInfo.Request> requests = new  List<GetFlowInfo.Request>();
    GetFlowInfo.Request request = new GetFlowInfo.Request();
    request.FlowApiName = flowApiName;
    request.FlowDefinitionId = flowDefinitionId;
    requests.add(request);

    System.QueryException  unexpectedException;

    try
    {
        GetFlowInfo.executeGetFlowInfo(requests);
    }
    catch (System.QueryException e)
    {
        unexpectedException = e;
    }

    system.assertEquals('List has no rows for assignment to SObject', unexpectedException.getMessage());
    

    
  }

}
