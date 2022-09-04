public with sharing class WeatherLocation {
    public WeatherLocation() {

    }

    @auraEnabled
    public String id {get;set;} 
    @auraEnabled
    public String address {get;set;} 
    @auraEnabled
    public String name {get;set;} 
    @auraEnabled
    public Integer index {get;set;} 
    @auraEnabled
    public Double latitude {get;set;} 
    @auraEnabled
    public Double longitude {get;set;}
    @auraEnabled 
    public Double distance {get;set;} 
    @auraEnabled
    public Double time_Z {get;set;} // in json: time
    @auraEnabled
    public String tz {get;set;} 
    @auraEnabled
    public WeatherConditionsSet currentConditions {get;set;} 
    

}
