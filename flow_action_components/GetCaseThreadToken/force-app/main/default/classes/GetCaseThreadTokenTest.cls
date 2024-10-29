@IsTest
private class GetCaseThreadTokenTest {

    @IsTest
    static void getTokenFromCaseIdTest() {

        // Set up a test request list
        List<GetCaseThreadToken.Inputs> myRequestedCaseIds = new List<GetCaseThreadToken.Inputs>();
   
        //make cases, test for bulkification
        List<Case> casesToInsert = new List<Case>();
        for(Integer i=0;i<201;i++){           
            casesToInsert.add( new case(subject='Case '+ i, Description='Case '+ i) );
        }
        Insert(casesToInsert);
        system.debug(casesToInsert);

        //now cast the Id's back in as requests.
        for(Case c : casesToInsert){
            GetCaseThreadToken.Inputs myReq = new GetCaseThreadToken.Inputs();
            myReq.caseId = c.Id;
            myRequestedCaseIds.add(myReq);
        }
     
        //then call the method; pass the list       
        List<GetCaseThreadToken.Outputs> myCaseThreadTokens = GetCaseThreadToken.getTokenFromCaseId(myRequestedCaseIds);
       
        //examine the list
        system.debug( 'myCaseThreadTokens.size()' );
        system.debug( myCaseThreadTokens.size() );

        //then run assertions to see if we got back the same number of Thread Tokens
        Assert.areEqual(casesToInsert.size(), myCaseThreadTokens.size());
    }
}
