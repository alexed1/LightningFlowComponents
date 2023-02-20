public with sharing class mc_ValidateAddress_Result {
        @AuraEnabled
		public mc_ValidateAddress_Geocode geocode{get;set;}
		// public address address{get;set;}
        @AuraEnabled
		public mc_ValidateAddress_UspsData uspsData{get;set;}
		// public verdict verdict{get;set;}
}