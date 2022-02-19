/**
 * @description       : Exposes the Datacloud FindDuplicates method in extendable fashion so tests can be mocked.
 * @group             : UnofficialSF
 * @last modified on  : 01-28-2022
 * Modifications Log
 * Ver   Date         Modification
 * 1.0   01-28-2022   Initial Version
**/
public with sharing virtual class FindDuplicates {
    
    /**
    * @description Mimics the shape of the Datacloud FindDuplicates method, and instantiates custom classes so that the results can be more easily processed.
    * @param List<SObject> records 
    * @return List<FindDuplicatesResult>
    **/
    public virtual List<FindDuplicatesResult> findDuplicates(List<SObject> records){
        try {
            List<Datacloud.FindDuplicatesResult> findDuplicateResults = Datacloud.FindDuplicates.findDuplicates(records);
            
            List<FindDuplicatesResult> results = new List<FindDuplicatesResult>();
            for(Datacloud.FindDuplicatesResult find : findDuplicateResults) {
                List<DuplicateResult> duplicateResults = new List<DuplicateResult>();
                for(Datacloud.DuplicateResult result : find.getDuplicateResults()) {
                    List<MatchResult> matchResults = new List<MatchResult>();
                    for(Datacloud.MatchResult match : result.getMatchResults()) {
                        List<MatchRecord> matchRecords = new List<MatchRecord>();
                        for(Datacloud.MatchRecord record : match.getMatchRecords()) {
                            matchRecords.add(new MatchRecord(record.getRecord().Id,record.getMatchConfidence()));
                        }
                        matchResults.add(new MatchResult(matchRecords));
                    }
                    duplicateResults.add(new DuplicateResult(matchResults));
                }
                results.add(new FindDuplicatesResult(duplicateResults));
            }
            return results;
        } catch (Exception ex) {
            throw new FindDuplicatesException(ex.getMessage());
        }
    }

    /**
    * @description Wrapper class for FindDuplicatesResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_FindDuplicatesResult.htm
    **/
    public class FindDuplicatesResult{
        public List<DuplicateResult> getDuplicateResults;

        public FindDuplicatesResult(List<DuplicateResult> results) {
            this.getDuplicateResults = results;
        }
    }

    /**
    * @description Wrapper class for DuplicateResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_DuplicateResult.htm
    **/
    public class DuplicateResult{
        public List<MatchResult> getMatchResults;

        public DuplicateResult(List<MatchResult> matches){
            this.getMatchResults = matches;
        }
    }

    /**
    * @description Wrapper class for MatchResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_MatchResult.htm
    **/
    public class MatchResult{
        public List<MatchRecord> getMatchRecords;

        public MatchResult(List<MatchRecord> records){
            this.getMatchRecords = records;
        }
    }

    /**
    * @description Wrapper class for MatchResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_MatchRecord.htm
    **/
    public class MatchRecord{
        public Id getRecordId;
        public Double getMatchConfidence;

        public MatchRecord(Id recordId, Double matchConfidence){
            this.getRecordId = recordId;
            this.getMatchConfidence = matchConfidence;
        }
    }

    /**
    * @description So we can throw exceptions
    **/
    public class FindDuplicatesException extends Exception{}
}
