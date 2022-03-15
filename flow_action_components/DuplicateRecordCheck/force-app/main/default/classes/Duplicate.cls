/**
 * @description       : Duplicate
 * @group             : UnofficialSF
 * @last modified on  : 02-18-2022
 * Modifications Log
 * Ver   Date         Modification
 * 1.0   02-18-2022   Initial Version
**/
public with sharing class Duplicate implements Comparable{
    @AuraEnabled
    public Boolean isDuplicate;

    @AuraEnabled
    public Id duplicateRecordId;

    @AuraEnabled
    public String duplicatesObjectType;

    @TestVisible
    private Double matchConfidence;

    public Duplicate(Boolean isDuplicate, Id duplicateRecordId, String duplicatesObjectType, Double matchConfidence){
        this.isDuplicate = isDuplicate;
        this.duplicateRecordId = duplicateRecordId;
        this.duplicatesObjectType = duplicatesObjectType;
        this.matchConfidence = matchConfidence;
    }

    /**
    * @description Comparable method that sorts the objects in decsending order based on matchConfidence (nulls last)
    * @param Object compareTo 
    * @return Integer 
    **/
    public Integer compareTo(Object compareTo){
        Duplicate that = (Duplicate)compareTo;
        if(this.matchConfidence == that.matchConfidence) return 0;
        if(this.matchConfidence == null) return 1;
        if(that.matchConfidence == null) return -1;
        return (this.matchConfidence < that.matchConfidence) ? 1 : -1;
    }
}
