/**
 * @description       : Contains the Invocable Method that runs the duplicate rules on a particular record(s) to see if a duplicate record(s) exists.
 * @group             : UnofficialSF
 * @last modified on  : 01-27-2022
 * Modifications Log
 * Ver   Date         Modification
 * 1.0   06-16-2021   Initial Version
 * 2.0   11-27-2021   Code Optimization
 * 3.0   01-27-2022   Implementing Dependency Injection
**/

public with sharing class DuplicateRecordCheck_Invocable{
    /**
    * @description Contains the Invocable Method that runs the duplicate rules on a particular record(s) to see if a duplicate record(s) exists.
    * @param List<Input> inputs 
    * @return List<Duplicate> 
    **/
    @InvocableMethod(
        label='Check for Duplicate Records'
        description='Runs the duplicate rules on a particular record (or records) to see if a duplicate record (or records) exists.'
        category='Duplicate Record Check'
    )
    public static List<Output> findDuplicates(List<Input> inputs){

        List<sObject> listsObjectsToCheck = new List<sObject>();
        for(Input input : inputs){
            if(input.record != null) listsObjectsToCheck.add(input.record);
            if(input.records != null) listsObjectsToCheck.addAll(input.records);
        }

        List<Duplicate> duplicates = DuplicateRecordCheck_Util.findDuplicates(listsObjectsToCheck);

        List<Output> outputs = new List<Output>();
        for(Input input : inputs){
            Output output = new Output();
            if(input.record != null){
                output.duplicate = duplicates.remove(0);
            }

            if(input.records != null){
                output.duplicates = new List<Duplicate>();
                for(sObject record : input.records){
                    output.duplicates.add(duplicates.remove(0));
                }
            }

            outputs.add(output);
        }

        return outputs;
    }

    /**
    * @description Wrapper class for invocable inputs
    **/
    public class Input{
        @InvocableVariable(label='Single Record to Check for Duplicates')
        public sObject record;

        @InvocableVariable(label='Collection of Records to Check for Duplicates')
        public List<sObject> records;
    }

    /**
    * @description Wrapper class for invocable outputs
    **/
    public class Output{
        @InvocableVariable(label='Duplicate Result from Single Record')
        public Duplicate duplicate;

        @InvocableVariable(label='Duplicate Results from Collection of Records')
        public List<Duplicate> duplicates;
    }
}