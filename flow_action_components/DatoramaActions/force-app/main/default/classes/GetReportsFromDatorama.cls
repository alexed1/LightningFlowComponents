global with sharing class GetReportsFromDatorama {
    
 
        @InvocableMethod
        public static List<Results> execute (List<Requests> requests)
           {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                String endpoint = requests[0].endpoint;
                String workspaceId = requests[0].workspaceId;
                String fullURL = endpoint + workspaceId + '/reports';
                System.debug('url is: ' + fullURL);
                request.setEndpoint(fullURL);
                request.setMethod('GET');
 
           
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Accept', 'application/json');
                request.setHeader('Authorization', requests[0].token);

                HttpResponse response = http.send(request);
               
                Results curResult = new Results();
                String responseJSON = response.getBody();
                System.debug('return JSON: ' + responseJSON);
               
               
                List<DatoramaReport> reportList = DatoramaReports.parse(responseJSON);        
                curResult.reports = reportList;
                System.debug ('parsed reports = ' + curResult.reports);
               
                List<Results> resultsList = new List<Results>();
                resultsList.add(curResult);
                return resultsList;
           }
        
        global class Requests {
            @InvocableVariable
            global String workspaceId;
            
            @InvocableVariable
            global String endpoint;    
            
            @InvocableVariable
            global String token;
        }
        
        global class Results {
            @InvocableVariable
            global List<DatoramaReport> reports;
        }
    
    }