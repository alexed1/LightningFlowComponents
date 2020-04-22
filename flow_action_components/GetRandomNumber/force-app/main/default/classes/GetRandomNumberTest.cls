@isTest
global with sharing class GetRandomNumberTest {
    
	@isTest
    public static void numberReturnedIsInRange() {
    	Integer startNum = 0;
    	Integer endNum =1;
        
        GetRandomNumber.Requests curRequest = new GetRandomNumber.Requests();
        curRequest.startNumber= startNum;
        curRequest.endNumber = endNum;
        
        List<GetRandomNumber.Requests> curRequestList = new List<GetRandomNumber.Requests>();
        curRequestList.add(curRequest);
        
		Test.startTest();
		List<GetRandomNumber.Results> resultsList = new List<GetRandomNumber.Results>();      
        resultsList = GetRandomNumber.getRandomNumberFromRange(curRequestList);
        Test.stopTest();

        Double resultNum = resultsList[0].randomNumber;
		System.assertEquals(true, resultNum>startNum);
        System.assertEquals(true, resultNum<endNum);
    }
    
    @isTest
    public static void numberZeroToOneGeneratedIsInRange() {
    	Integer startNum = 0;
    	Integer endNum =1;
           
		Test.startTest();
        Double resultNum = GetRandomNumber.generateRandomFromRange(startNum, endNum);
        Test.stopTest();
  
		System.assertEquals(true, resultNum>startNum);
        System.assertEquals(true, resultNum<endNum);
    }
    
    @isTest
    public static void numberAboveOneGeneratedIsInRange() {
    	Integer startNum = 5;
    	Integer endNum =7;
           
		Test.startTest();
        Double resultNum = GetRandomNumber.generateRandomFromRange(startNum, endNum);
        Test.stopTest();
  
		System.assertEquals(true, resultNum>startNum);
        System.assertEquals(true, resultNum<endNum);
    }
    
    
}