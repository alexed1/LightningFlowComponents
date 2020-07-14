public with sharing class GetCreditScore {
    
        @InvocableMethod
        public static List<Results> get(List<Requests> requests)
           {
               //temporary shim
                if (String.isBlank(requests[0].custId))
                   requests[0].custId = '5000';

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                   //Make sure you add the below endpoint as a remote site setting
                request.setEndpoint('https://repair-service.herokuapp.com/api/creditScore?customerId='+ requests[0].custId);
                request.setMethod('GET');
                HttpResponse response = http.send(request);
                 Results curResult = new Results();
                curResult.creditScore = Integer.valueOf(response.getBody());
               
                List<Results> resultsList = new List<results>();
                resultsList.add(curResult);
                return resultsList;
           }
        
        public class Requests {
            @InvocableVariable
            public String custId;
            
        }
        
        public class Results {
            @InvocableVariable
            public Integer creditScore;
        }
    }