public with sharing class WeatherResultSet {
	
	
        @AuraEnabled
		public String columns {get;set;} 
        @AuraEnabled
		public Integer remainingCost {get;set;} 
        @AuraEnabled
		public Integer queryCost {get;set;} 
        @AuraEnabled
		public String messages {get;set;} 
        @AuraEnabled
		public String locations {get;set;} 

	

}
