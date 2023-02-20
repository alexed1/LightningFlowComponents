public with sharing class mc_ValidateAddress_Results {
    @AuraEnabled
	public mc_ValidateAddress_Result result {get;set;}
    @AuraEnabled
	public String responseId{get;set;}
	// public class verdict{
	// 	public String geocodeGranularity{get;set;}
	// 	public Boolean addressComplete{get;set;}
	// 	public String validationGranularity{get;set;}
	// 	public Boolean hasUnconfirmedComponents{get;set;}
	// 	public String inputGranularity{get;set;}
	// }
	// public class postalAddress{
	// 	public String administrativeArea{get;set;}
	// 	public String postalCode{get;set;}
	// 	public String locality{get;set;}
	// 	public String languageCode{get;set;}
	// 	public list<String> addressLines{get;set;}
	// 	public String regionCode{get;set;}
	// }

	// public class componentName{
	// 	public String languageCode{get;set;}
	// 	public String text{get;set;}
	// }
	// public class addressComponents{
	// 	public String confirmationLevel{get;set;}
	// 	public String componentType{get;set;}
	// 	public componentName componentName{get;set;}
	// }
	// public class address{
	// 	public list<String> unconfirmedComponentTypes{get;set;}
	// 	public postalAddress postalAddress{get;set;}
	// 	public list<addressComponents> addressComponents{get;set;}
	// 	public String formattedAddress{get;set;}
	// }

}