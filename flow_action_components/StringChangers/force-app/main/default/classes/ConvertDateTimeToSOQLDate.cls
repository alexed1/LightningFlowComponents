public with sharing class ConvertDateTimeToSOQLDate {

    @invocableMethod(label='Convert DateTime to SOQL' description='Converts a typical Flow DateTime to the string format that Execute SOQL and other SOQL inputs expect')
    public static List<Response> convert(List<Request> requestList) {
       List<Response> responseList = new List<Response>();
       
       return responseList;
   }


    public class Request {

       @invocableVariable
       public String foobar;



   }

   public class Response {
       @invocableVariable
       public String soqlDateTimeString;

   }
}
