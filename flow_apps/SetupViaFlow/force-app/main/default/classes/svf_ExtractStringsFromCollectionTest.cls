@isTest
public with sharing class svf_ExtractStringsFromCollectionTest {
    @isTest
    static void extractTest() {
        List<Case> csList = new List<Case>();
        for(Integer i = 0; i < 5; i++) {
            csList.add(new Case(Subject = 'Test ' + i));
        }
        insert csList;

        svf_ExtractStringsFromCollection.Request request = new svf_ExtractStringsFromCollection.Request();
        request.fieldAPIName = 'Subject';
        request.inputRecordCollection = csList; 
        List<svf_ExtractStringsFromCollection.Result> resultList =  svf_ExtractStringsFromCollection.extract(new List<svf_ExtractStringsFromCollection.Request> {request});
        System.assert(resultList[0].fieldValueCollection.size() == 5);

        request.dedupeValues = false;
        resultList =  svf_ExtractStringsFromCollection.extract(new List<svf_ExtractStringsFromCollection.Request> {request});
        System.assert(resultList[0].fieldValueCollection.size() == 5);
        try{
            request.fieldAPIName = null;
            request.inputRecordCollection = csList; 
            resultList = svf_ExtractStringsFromCollection.extract(new List<svf_ExtractStringsFromCollection.Request> {request});
            System.assert(false);
        }catch(Exception e) {
            System.assert(true);
        }

        try{
            request.fieldAPIName = 'Subject';
            request.inputRecordCollection = null; 
            resultList = svf_ExtractStringsFromCollection.extract(new List<svf_ExtractStringsFromCollection.Request> {request});
            System.assert(false);
        }catch(Exception e) {
            System.assert(true);
        }
    }
}
