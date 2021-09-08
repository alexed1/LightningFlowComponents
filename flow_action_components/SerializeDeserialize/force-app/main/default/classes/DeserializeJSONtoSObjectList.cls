global with sharing class DeserializeJSONtoSObjectList {
    @InvocableMethod
    global static List <Results> parse (List<Requests> requestList) {

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();

        for (Requests curRequest : requestList) {
            String serializedSObjectListString = curRequest.serializedSObjectListString.replace('null', '""');
            String curType = curRequest.objectTypeName;
            Type systemType = Type.forName(curType);
            //Create a Results object to hold the return values
            Results response = new Results();
            //make the magic happen
            List<SObject> curSObjectList = (List<SObject>)JSON.deserialize(serializedSObjectListString, List<Sobject>.class);

            if (curSObjectList.size() > 1) {
              //add the return values to the Results object
              response.outputSObjectList = curSObjectList;
            }
            else {
              response.outputSObject = curSObjectList[0];
            }
            
            responseWrapper.add(response);
        }
       
        return responseWrapper;
    }

    global class Results {
      @InvocableVariable
      global SObject outputSObject;
      @InvocableVariable
      global List<SObject> outputSObjectList;
    }

    global class Requests {
      @InvocableVariable(required=true)
      global String serializedSObjectListString;
      @InvocableVariable(required=true)
      global String objectTypeName;
    }
}
