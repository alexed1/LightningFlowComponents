public with sharing class FlowDefinition {
    public FlowDefinition() {
        attributes = new FlowDefinitionAttributeSet();
    }

    public string Id;
    public string Label;
    public string DeveloperName;
    public string Description;
    public string FullName;
    public FlowDefinitionAttributeSet attributes;

    public with sharing class FlowDefinitionAttributeSet {
        public string type;
        public string url;
        
    }
    
}