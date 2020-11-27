# MassTransactor

This Invocable allows Flow (or Proces Builder) to perform large DML operations by leveraging Batch Apex.

See [this article](https://unofficialsf.com/create-delete-or-update-tens-of-thousands-of-records-at-a-time-in-flow-with-the-new-mass-transactor-action/) for more information.

This is the first release of this component and it does have a few limitations. We do plan to do more releases to address some of these.
- This is currently not well bulkified for use in autolaunched Flow or PB where batches of records may be present. There are some complexities in making this work, but we do plan to release an improved version with basic bulkification shortly.
- Due to Salesforce limitations around the number of running and queued batches in an org, this might not scale to all use-cases. Proper testing is recommended!
- Right now we have only implemented one OnFinish action, a simple "email on complete" action. We may implement more, however you can use the MassTransactorBatchHelper.OnFinishAction interface to roll your own!

Enjoy!

