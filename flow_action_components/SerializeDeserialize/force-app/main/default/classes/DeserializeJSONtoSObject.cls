global with sharing class DeserializeJSONtoSObject {
  @InvocableMethod
  global static List <Results> parse (List<Requests> requestList) {

      //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
      List<Results> responseWrapper= new List<Results>();

      for (Requests curRequest : requestList) {
          String serializedSObjectString = curRequest.serializedSObjectString.replace('null', '""');
          String curType = curRequest.objectTypeName;
          Type systemType = Type.forName(curType);
          //Create a Results object to hold the return values
          Results response = new Results();
          //make the magic happen
          List<SObject> curSObjectList = (List<SObject>)JSON.deserialize(serializedSObjectString, List<Sobject>.class);

          if (curSObjectList.size() > 1) {
            //add the return values to the Results object
            response.outputSObjectList = curSObjectList;
          }
          else if (curSObjectList.size() == 1) {
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
    global String serializedSObjectString;
    @InvocableVariable(required=true)
    global String objectTypeName;
  }
}