public with sharing class WeatherReport {

    public WeatherReport() {

    }


	@auraEnabled
    public Double wdir {get;set;}
    @auraEnabled
	public Double uvindex {get;set;} 
	@auraEnabled
    public String datetimeStr {get;set;} 
	@auraEnabled
    public String preciptype {get;set;} 
	@auraEnabled
    public Double cin {get;set;} 
	@auraEnabled 
    public Double cloudcover {get;set;} 
	@auraEnabled
    public Double pop {get;set;} 
	@auraEnabled 
    public Double mint {get;set;} 
	@auraEnabled 	
    public Long datetime_Z {get;set;} // in json: datetime
	@auraEnabled 
    public Double precip {get;set;} 
	@auraEnabled 
    public Double solarradiation {get;set;} 
	@auraEnabled
    public Double dew {get;set;} 
	@auraEnabled
    public Double humidity {get;set;} 
	@auraEnabled
    public Double temp {get;set;} 
	@auraEnabled
    public Double maxt {get;set;} 
	@auraEnabled
    public Double visibility {get;set;} 
	@auraEnabled
    public Double wspd {get;set;} 
	@auraEnabled
    public Double severerisk {get;set;} 
	@auraEnabled
    public Double solarenergy {get;set;} 
	@auraEnabled
    public Object heatindex {get;set;} 
	@auraEnabled
    public Double snowdepth {get;set;} 
	@auraEnabled
    public Double sealevelpressure {get;set;} 
	@auraEnabled
    public Double snow {get;set;} 
	@auraEnabled
    public Double wgust {get;set;} 
	@auraEnabled
    public String conditions {get;set;} 
	@auraEnabled
    public Object windchill {get;set;} 
	@auraEnabled
    public Double cape {get;set;} 
}
