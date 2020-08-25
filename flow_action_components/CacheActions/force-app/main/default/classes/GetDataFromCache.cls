public with sharing class GetDataFromCache {
    @InvocableMethod
    public static List<Results> retrieve (List<Request> requestList) {
        System.debug('entering GetDataFromCache');
        List<Results> responseWrapper = new List<Results>();
        for (Request curRequest : requestList) {
            Results curResult = new Results();
            String key = curRequest.key;
            Object cachedData;

            if (curRequest.cacheType == 'Session') {
                if (Cache.Session.contains(key)) {
                     cachedData = Cache.Session.get(key);
                } else {
                    if (Cache.Org.contains(key)) 
                         cachedData = Cache.Org.get(key);
                }
             }


            

            if(cachedData instanceof List<SObject>) 
                curResult.outputCollection = (List<SObject>)cachedData;

            if(cachedData instanceof SObject) 
                curResult.outputRecord = (SObject)cachedData;

            if(cachedData instanceof String) 
                curResult.outputString = (String)cachedData;

            if(cachedData instanceof Datetime) 
                curResult.outputDateTime = (Datetime)cachedData;

            if(cachedData instanceof Date) 
                curResult.outputDate = (Date)cachedData;

            

            responseWrapper.add(curResult);
        }     
     
        return responseWrapper;
    
    }

 

    public class Request {
      

      @InvocableVariable
      public String cacheType = 'Session';

      @InvocableVariable
      public String key;
        
    }
    
    public class Results {
        @InvocableVariable
        public String errors;

        @InvocableVariable
        public List<SObject> outputCollection;

        @InvocableVariable
        public SObject outputRecord;

        @InvocableVariable
        public String outputString;

        @InvocableVariable
        public DateTime outputDateTime;

        @InvocableVariable
        public Date outputDate;



    }

    public class InvocableActionException extends Exception {}
}
