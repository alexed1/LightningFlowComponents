/**
 * @description       : Batchable for doing large batch DML from Flow
 * @author            : Matt Comer, CapTech Consulting
 * @group             : 
 * @last modified on  : 
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author                                Modification
 * 1.0   08-19-2020   Matt Comer                            Initial Version
**/
public with sharing class MassTransactorBatchHelper implements Database.Batchable<SObject>, Database.Stateful {
    
    public enum OperationType {DO_INSERT, DO_UPDATE, DO_UPSERT, DO_DELETE}
    private List<SObject> records;
    private OperationType action;
	private OnFinishAction finishAction;
    
    public class ListIterator implements Iterator<SObject> {
        private List<SObject> records;
        Integer cursor;
        public ListIterator(List<SObject> records) {
            this.records = records;
            cursor = -1;
        }
        public boolean hasNext() {
            return (cursor < (records.size() -1));
        }
        public SObject next() {
            if (cursor == records.size() - 1) {return null;}
            cursor++;
            return records[cursor];
        }
    }

    public class ListIterable implements Iterable<SObject> {
        private List<SObject> records;
        public ListIterable(List<SObject> records) {
            this.records = records;
        }
        public Iterator<SObject> Iterator(){
            return new ListIterator(records);
        }
    }    
    
    public MassTransactorBatchHelper(List<SObject> records, OperationType action) {
        
        this.records = records;
        this.action = action;        
    }

    public MassTransactorBatchHelper(List<SObject> records, String actionIn) {
        
        this(records, actionIn, null);
    }

    public MassTransactorBatchHelper(List<SObject> records, String actionIn, onFinishAction fa) {
        this.records = records;
        String a = actionIn.toUpperCase();
        this.finishAction = fa;

        if (a == 'CREATE') {
            this.action = OperationType.DO_INSERT;
        } else if (a == 'UPDATE') {
            this.action = OperationType.DO_UPDATE;
        } else if (a == 'UPSERT') {
            this.action = OperationType.DO_UPSERT;
        } else if (a == 'DELETE') {
            this.action = OperationType.DO_DELETE;
        }
    }

    public System.Iterable<SObject> start(Database.BatchableContext ctx) {      
      return new ListIterable(records);
    }
    
    public void execute(Database.BatchableContext ctx, List<SObject> records) {
        // fix problem with picklist field values which can occur in async context (seems to be due to serialization / storage of state)
        if (action != OperationType.DO_DELETE) {
            Map<String, Schema.SObjectField> sObjectFieldsMap = Schema.describeSObjects(new List<String> { records[0].getSObjectType().getDescribe().getName() })[0].fields.getMap();
            for (SObject o: records) {
                for (String fieldName : o.getPopulatedFieldsAsMap().keySet()) {
                    Schema.DisplayType dt = sObjectFieldsMap.get(fieldName).getDescribe().getType();
                    if ((dt == Schema.DisplayType.PICKLIST || dt == Schema.DisplayType.MULTIPICKLIST) && 
                    	String.valueOf(o.get(fieldName)) != null ) {
                        o.put(fieldName, String.valueOf(o.get(fieldName)).replace('[', '').replace(']', ''));
                    }
                }
            }
        }
        
        switch on action {
            when DO_INSERT {
                Database.insert(records, false);
            }
            when DO_UPDATE {
                Database.update(records, false);
            }
            when DO_UPSERT {
                Database.upsert(records, false);
            }
            when DO_DELETE {
                Database.delete(records, false);
            }
        }
    }

    public void finish(Database.BatchableContext ctx) {
        if (finishAction != null) {
            finishAction.onFinish(ctx.getJobId());
        }
    }

    public interface OnFinishAction {
        void onFinish(Id finishedJobId);
    }

 }