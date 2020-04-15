global with sharing class DeserializeJSONtoSObject {

  
    @InvocableMethod
    global static List <Results> parse (List<Requests> requestList) {
        System.debug('entering object json parse');

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();

        for (Requests curRequest : requestList) {
            String serializedSObjectString = curRequest.serializedSObjectString;
            String curType = curRequest.objectTypeName;
            //Create a Results object to hold the return values
            Results response = new Results();

            /* //extract the object type that the user specfied when defining the instance in Flow Builder
            Schema.SObjectType curType = response.outputSObject.getSObjectType();
            System.debug ('curtype: ' + curType);
            String sObjectTypeName = curType.getDescribe().getName();
            System.debug ('sObjectTypeName: ' + sObjectTypeName);
            Type systemType = Type.forName(sObjectTypeName);
            System.debug ('systemType: ' + systemType); */
            Type systemType = Type.forName(curType);
            //make the magic happen
            SObject curSObject = (SObject)JSON.deserialize(serializedSObjectString, systemType);
            System.debug ('curSObject: ' + curSObject);

            //add the return values to the Results object
            response.outputSObject = curSObject;

            responseWrapper.add(response);
        }
       
        return responseWrapper;
    
    }

    global class Requests {
      @InvocableVariable(required=true)
      global String serializedSObjectString;

      @InvocableVariable(required=true)
      global String objectTypeName;

    
    }
    
    global class Results {

      
      @InvocableVariable
      global SObject outputSObject;

    }

}
