public with sharing class StoreDataInCache {

    @InvocableMethod
    public static List<Results> store (List<Request> requestList) {
        System.debug('entering StoreDataInCache');
        List<Results> responseWrapper = new List<Results>();
        for (Request curRequest : requestList) {
            Results response = new Results();
            List<SObject> inputCollection = curRequest.inputCollection != null ? curRequest.inputCollection : new List<SObject>();
            SObject inputRecord = curRequest.inputRecord;
            String inputString = curRequest.inputString;
            DateTime inputDateTime = curRequest.inputDateTime;
            Date inputDate = curRequest.inputDate;


            if (curRequest.inputString != null) {
                System.debug('inputString not null');
                putCache(curRequest.inputStringKey, curRequest.inputString, curRequest.cacheType);
            }

           
            if (curRequest.inputDate != null && curRequest.inputDateKey != null) {
                System.debug('storing inputDate');
                putCache(curRequest.inputDateKey, curRequest.inputDate, curRequest.cacheType);
            }
            
            if (curRequest.inputDateTime != null && curRequest.inputDateTimeKey != null) {
                System.debug('storing inputDateTime');
                putCache(curRequest.inputDateTimeKey, curRequest.inputDateTime, curRequest.cacheType);
            }

            if (curRequest.inputRecord != null && curRequest.inputRecordKey != null) {
                System.debug('storing inputRecord');
                putCache(curRequest.inputRecordKey, curRequest.inputRecord, curRequest.cacheType);
            }

            if (curRequest.inputCollection != null && curRequest.inputCollectionKey != null) {
                System.debug('storing inputRecord');
                putCache(curRequest.inputCollectionKey, curRequest.inputCollection, curRequest.cacheType);
            }
            
                //Create a Results object to hold the return values
           

            responseWrapper.add(response);
        }     
     
        return responseWrapper;
    
    }

    private static void putCache(String key, Object data, String cacheType) {
        if (cacheType == 'Session') {
            Cache.Session.put(key, data);
        } else {
            Cache.Org.put(key, data);
        }

    }

    public class Request {
      @InvocableVariable
      public List<SObject> inputCollection;

      @InvocableVariable
      public String inputCollectionKey;

      @InvocableVariable
      public SObject inputRecord;

      @InvocableVariable
      public String inputRecordKey;

      @InvocableVariable
      public String inputString;

      @InvocableVariable
      public String inputStringKey;

      @InvocableVariable
      public DateTime inputDateTime;

      @InvocableVariable
      public String inputDateTimeKey;

      @InvocableVariable
      public Date inputDate;

      @InvocableVariable
      public String inputDateKey;

      @InvocableVariable
      public String cacheType = 'Session';
        
    }
    
    public class Results {
        @InvocableVariable
        public String errors;


    }

    public class InvocableActionException extends Exception {}
}