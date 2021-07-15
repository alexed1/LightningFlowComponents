global with sharing class DeserializeJSONtoSObjectList {
    @InvocableMethod
    global static List <Results> parse (List<Requests> requestList) {
        System.debug('entering object json parse');

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();

        for (Requests curRequest : requestList) {
            String serializedSObjectListString = curRequest.serializedSObjectListString.replace('null', '""');
            System.debug(serializedSObjectListString);
            String curType = curRequest.objectTypeName;
            Type systemType = Type.forName(curType);
            System.debug(systemType);
            //Create a Results object to hold the return values
            Results response = new Results();
            //make the magic happen
            List<SObject> curSObjectList = (List<SObject>)JSON.deserialize(serializedSObjectListString, List<Sobject>.class);

            //add the return values to the Results object
            response.outputSObjectList = curSObjectList;
            
            responseWrapper.add(response);
        }
       
        return responseWrapper;
    
    }

    global class Requests {
      @InvocableVariable(required=true)
      global String serializedSObjectListString;

      @InvocableVariable(required=true)
      global String objectTypeName;

    
    }
    
    global class Results {

      
      @InvocableVariable
      global List<SObject> outputSObjectList;

    }
}
