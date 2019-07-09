global with sharing class FilterCollection {
    public FilterCollection() {

    }

    public class FlowActionException extends Exception {}

    @InvocableMethod
    public static List<Results> filter(List<Requests> request)
       {
           //find the input value and verify there's only one (else throw)
           //case the input to Sobject[]
           //process it
           //cast the output to the appropriate return type and set the appropriate response variable
           // Boolean valueFound = false;
            //String[] supportedStringNames = new String[]{'Account', 'Contact'};
            String fieldName = request[0].filterField;
            SObject[] sourceCollection;
            SObject[] filteredCollection;
            Boolean valueFound = false;
            Sobject[] curInputCollection;
            String objectType;

            curInputCollection = request[0].sourceAccountCollection;
            if (hasValue(curInputCollection, valueFound)) {
                 sourceCollection = curInputCollection;
                 valueFound = true;
                 objectType='Account';
            }
           
            curInputCollection = request[0].sourceContactCollection;
            if (hasValue(curInputCollection, valueFound)) {
                 sourceCollection = curInputCollection;
                 valueFound = true;
                 objectType='Contact';
            }

            curInputCollection = request[0].sourceCaseCollection;
            if (hasValue(curInputCollection, valueFound)) {
                 sourceCollection = curInputCollection;
                 valueFound = true;
                 objectType='Case';
            }

            curInputCollection = request[0].sourceOpportunityCollection;
            if (hasValue(curInputCollection, valueFound)) {
                 sourceCollection = curInputCollection;
                 valueFound = true;
                 objectType='Opportunity';
            }

            curInputCollection = request[0].sourceLeadCollection;
            if (hasValue(curInputCollection, valueFound)) {
                 sourceCollection = curInputCollection;
                 valueFound = true;
                 objectType='Lead';
            }

            String[] targetValues = getTargetValues(request[0].targetValuesCSVString, request[0].targetValuesStringCollection);
            System.debug('targetValues is: ' + targetValues);
            filteredCollection = getFilteredSet(sourceCollection, fieldName, targetValues);
           
            Results curResult = new Results();
            switch on objectType {
                when 'Account' {
                    curResult.filteredAccountCollection = (Account[])filteredCollection;
                }
                when 'Case' {
                    curResult.filteredCaseCollection = (Case[])filteredCollection;
                }
                when 'Opportunity' {
                    curResult.filteredOpportunityCollection = (Opportunity[])filteredCollection;
                }
                when 'Lead' {
                    curResult.filteredLeadCollection = (Lead[])filteredCollection;
                }
                 when 'Contact' {
                    curResult.filteredContactCollection = (Contact[])filteredCollection;
                }
            }
            System.debug('curResult is: ' + curResult);
            List<Results> resultsList = new List<results>();
            resultsList.add(curResult);
            return resultsList;
       }

    //check to make sure only one set of target values is passed in
    //if the passed in targetvalues are csv string, normalize them to string collection
    public static String[] getTargetValues(String targetValuesCSVString, String[] targetValuesStringCollection) {
        System.debug('entering getTargetValues');
        if(String.isNotEmpty(targetValuesCSVString)  && targetValuesStringCollection!= null && !targetValuesStringCollection.isEmpty()) {
            throw new FlowActionException('Only 1 set of target values can be provided');
        }
        System.debug('finished test for 2 sets');
        if(String.isEmpty(targetValuesCSVString) && (targetValuesStringCollection == null || targetValuesStringCollection.isEmpty())) {
            throw new FlowActionException('You need to provide a set of target values');
        }
        System.debug('finished test for 0 sets');
        if (String.isNotEmpty(targetValuesCSVString)) {
            targetValuesStringCollection = targetValuesCSVString.split(',');
        }
        System.debug('finished conversion of string');
        return targetValuesStringCollection;

    }

    public static SObject[] getFilteredSet (SObject[] sourceCollection, String fieldName, String[] targetValues ) {
        SObject[] filteredResults = new SObject[]{};
        System.debug('entering getFilteredSet');

        if(String.isEmpty(fieldName)) {
            throw new FlowActionException('You need to provide a fieldName to search on');
        }
        System.debug('done checking fieldname');
        for(SObject curSObject : sourceCollection) {
            System.debug('entering loop for sobject: ' + curSObject);
            for (String curTargetString : targetValues) {
                if (curSObject.get(fieldName) == curTargetString) {
                    filteredResults.add(curSObject);
                    System.debug('adding curSobject to filteredResults');
                    break;
                }
                else {
                    System.debug('skipping to next target string');
                }
 

            }
            
        }
        System.debug('final filtered results are: ' + filteredResults);

        return filteredResults;

    }   

    public static Boolean hasValue( Sobject[] testCollection, Boolean valueFound) {
        System.debug('entering hasValue');
        System.debug('valueFound is: ' + valueFound);
        System.debug('testCollection is:' + testCollection);
        if (!testCollection.isEmpty()) {
            if (valueFound)
                throw new FlowActionException('More than one input to Filter has a value.');
            else {
                return true;
            }
        }   
        else return false;
    }
    
    
    global class Requests {
        
        public Requests() {
            sourceAccountCollection = new List<Account>();
            sourceCaseCollection = new List<Case>();
            sourceLeadCollection = new List<Lead>();
            sourceOpportunityCollection = new List<Opportunity>(); 
            sourceContactCollection = new List<Contact>();
            
        }
       
        @InvocableVariable
    	global String filterField;
        
        @InvocableVariable
    	global String targetValuesCSVString;

        @InvocableVariable
    	global String[] targetValuesStringCollection;


        @InvocableVariable
    	global Account[] sourceAccountCollection;

        @InvocableVariable
    	global Contact[] sourceContactCollection;

        @InvocableVariable
    	global Opportunity[] sourceOpportunityCollection;

        @InvocableVariable
    	global Lead[] sourceLeadCollection;

        @InvocableVariable
    	global Case[] sourceCaseCollection;

    }
    
    global class Results {
        
        @InvocableVariable
    	global Account[] filteredAccountCollection;

        @InvocableVariable
    	global Contact[] filteredContactCollection;

        @InvocableVariable
    	global Opportunity[] filteredOpportunityCollection;

        @InvocableVariable
    	global Lead[] filteredLeadCollection;

        @InvocableVariable
    	global Case[] filteredCaseCollection;





    }
}