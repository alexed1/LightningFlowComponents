public with sharing class ToolingAPIResponse {
    public ToolingAPIResponse() {
        records = new List<FlowDefinition>();
    }

    public string size;
    public string totalSize;
    public string done;
    public string queryLocator;
    public string entityTypeName;
    public List<FlowDefinition> records;  
}