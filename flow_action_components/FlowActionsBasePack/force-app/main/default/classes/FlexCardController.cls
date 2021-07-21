public class FlexCardController {
	
    @AuraEnabled(Cacheable = true)
    public static Map<String, String> getFlowLabel(List<String> flowApiNames) {
        Map<String, String> flowMap = new Map<String, String>();
        for(FlowDefinitionView flow : [SELECT Label, ApiName FROM FlowDefinitionView WHERE ApiName IN :flowApiNames AND IsActive = true]) {
            flowMap.put(flow.apiName, flow.Label);
        }
        return flowMap;
    }
}