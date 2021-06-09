/**
 * @description       : 
 * @author            : Tom Snyder <tom@3ddd.com>
 * @group             : 
 * @last modified on  : 2021-05-06
 * @last modified by  : Tom Snyder <tom@3ddd.com>
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   2021-04-28   Tom Snyder <tom@3ddd.com>   Initial Version
**/
//Unit Test in AccountLogHandler_UT
trigger LogServiceEventTrigger on LogServiceEvent__e (after insert) {

    LIST<LogService__c> logsToInsert = new LIST<LogService__c>();
    LogService log = new LogService('LogServiceEventTrigger',  'LogServiceEventTrigger fired.');
    for(LogServiceEvent__e evt: Trigger.new) {
       try {
            if (evt.Type__c=='AddLog') {
                LIST<LogService__c> logs = (LIST<LogService__c>) JSON.deserialize(evt.Body__c,LIST<LogService__c>.class);  
                logsToInsert.addAll(logs);
            }
        else {
                throw new LogService.LogException('INVALID_TYPE:'+evt.Type__c);
            }
        }
        catch(Exception ex) {
            log.append(ex);
        }
    } //next evt
    
    //process events	
    try {
        if (logsToInsert.size()>0) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.allowFieldTruncation = true;
            Database.insert(logsToInsert, dmo);
        }
   }
   catch(Exception ex) {
       /*
        if (ex.getTypeName()=='System.DmlException' && ex.getDmlType(0)==System.StatusCode.DUPLICATE_VALUE && EventBus.TriggerContext.currentContext().retries < 10) {
            //this can sometimes conflict with the trigger update in the after, try again
            throw new EventBus.RetryableException('DUPLICATE_VALUE in upsert, try again');
        }
        else
        */
        log.append(ex);
    }
    finally {
        if (log.hasErrors) {
            LogService.addLog(log);
            LogService.save();
        }
           
    }
}