public virtual class LookupSearchResult implements Comparable {
    protected String id;
    protected String sObjectType;
    protected String icon;
    protected String title;
    protected String subtitle;
    protected String customValue;
    List<String> listOfFileds = new List<String>();

    protected LookupSearchResult() {
    }

    public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle) {
        this.id = id;
        this.sObjectType = sObjectType;
        this.icon = icon;
        this.title = title;
        this.subtitle = subtitle;
    }

    public LookupSearchResult(String id, String sObjectType, String icon, String title, List<String> inputListOfFileds) {
        this.id = id;
        this.icon = icon;
        this.title = title;
        this.sObjectType = sObjectType;
        this.listOfFileds = inputListOfFileds;
    }

    public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle, String customValue) {
        this.id = id;
        this.sObjectType = sObjectType;
        this.icon = icon;
        this.title = title;
        this.subtitle = subtitle;
        this.customValue = customValue;
    }

    public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle, String customValue, List<String> inputListOfFileds) {
        this.id = id;
        this.sObjectType = sObjectType;
        this.icon = icon;
        this.title = title;
        this.subtitle = subtitle;
        this.customValue = customValue;
        this.listOfFileds = inputListOfFileds;
    }

    @AuraEnabled
    public String getId() {
        return id;
    }

    @AuraEnabled
    public String getSObjectType() {
        return sObjectType;
    }

    @AuraEnabled
    public String getIcon() {
        return icon;
    }

    @AuraEnabled
    public String getTitle() {
        return title;
    }

    @AuraEnabled
    public String getSubtitle() {
        return subtitle;
    }

    @AuraEnabled
    public String getCustomValue() {
        return customValue;
    }

    @AuraEnabled
    public List<String> getListOfFileds() {
        return listOfFileds;
    }

    public Integer compareTo(Object compareTo) {
        LookupSearchResult other = (LookupSearchResult) compareTo;
        if (this.getTitle() == null) {
            return (other.getTitle() == null) ? 0 : 1;
        }
        if (other.getTitle() == null) {
            return -1;
        }
        return this.getTitle().compareTo(other.getTitle());
    }
}