# Apex Action: Save Records Async

## Upsert SObject records asynchronously from Flow via Apex Queueable.
### Use Case
Using the standard Insert Records and Update Records actions will commit those records to the database in the same transaction that other actions are executing in an autolaunched Flow or between screens in a Screen Flow. For applications with large data volumes or objects with CPU intensive automations, governor limits may prevent the saving of those records.  
Using an asynchronous method the records can be saved in a discreet transaction without the governor resources already consumed by the Flow.

### Considerations
The Apex Action will return an _ApexAsyncJob_ Id, use this Id to retrieve the status of the operation.

### More Information: https://unofficialsf.com/david-entremont-increase-your-limits-with-save-records-later-queueable-apex/
