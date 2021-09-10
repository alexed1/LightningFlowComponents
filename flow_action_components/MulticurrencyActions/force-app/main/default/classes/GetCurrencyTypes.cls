global with sharing class GetCurrencyTypes {
 

        @InvocableMethod(label='Get Currency Types' description='Get Currency Types' callout=false)
        global static List<Response> execute(List<Request> requests) {
            
    
            List<Response> responses = new List<Response>();
    
            for (Request curRequest: requests ){
                
                Response curResponse = new Response();
                List <CurrencyType> currencyTypes = new List<CurrencyType>();
                try {
                    currencyTypes= Database.Query('SELECT IsoCode, ConversionRate, DecimalPlaces,IsActive,IsCorporate FROM CurrencyType');
                   
                } catch (Exception e) {
                    System.debug(LoggingLevel.INFO,'get Currency Types error: ' + e);
                    throw new InvocableActionException('Unable to retrieve Currency Types. This probably means that this org does not have multicurrency support enabled. Additional Information: ' + e.getMessage());
                }
                //curResponse.currencyTypes = currencyTypes;
                responses.add(curResponse);
                 
            }
            return responses;
    
        }
    
        global class Response {
    
            @invocableVariable
            global List<String> XcurrencyTypes;
      
        }

        global class InvocableActionException extends Exception{}
    
        global class Request {
    
              @invocableVariable
              global string dummy; //doesn't do anything. but you have to have at least one input param!
             
        }
    
    }
    