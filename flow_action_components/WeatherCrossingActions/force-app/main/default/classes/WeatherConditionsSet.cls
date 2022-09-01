public with sharing class WeatherConditionsSet {
    public WeatherConditionsSet() {

    }

    @AuraEnabled
    public Double wdir {get;set;} 
    @AuraEnabled
    public Double temp {get;set;} 
    @AuraEnabled
    public String sunrise {get;set;} 
    @AuraEnabled
    public Double visibility {get;set;}
    @AuraEnabled 
    public Double wspd {get;set;} 
    @AuraEnabled
    public String icon {get;set;} 
    @AuraEnabled
    public String stations {get;set;} 
/*     @AuraEnabled
    public Object heatindex {get;set;}  */
    @AuraEnabled
    public Double cloudcover {get;set;} 
    @AuraEnabled
    public String datetime_Z {get;set;} // in json: datetime
    @AuraEnabled
    public Double precip {get;set;} 
    @AuraEnabled
    public Double moonphase {get;set;} 
/*     @AuraEnabled
    public Object snowdepth {get;set;}  */
    @AuraEnabled
    public Double sealevelpressure {get;set;} 
    @AuraEnabled
    public Double dew {get;set;} 
    @AuraEnabled
    public String sunset {get;set;} 
    @AuraEnabled
    public Double humidity {get;set;} 
   /*  @AuraEnabled
    public Object wgust {get;set;}  */
/*     @AuraEnabled
    public Object windchill {get;set;}  */
}
