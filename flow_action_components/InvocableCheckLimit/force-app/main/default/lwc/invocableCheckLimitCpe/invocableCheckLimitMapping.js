// Define the labels, values, and descriptions for limit options
export function fieldMapping() {
    return [
        { label: 'Aggregate Queries', value: 'aggregatequeries', description: 'Returns the number of aggregate queries that have been processed with any SOQL query statement.' },
        { label: 'Async Calls', value: 'asynccalls', description: 'Reserved for future use.' },
        { label: 'Callouts', value: 'callouts', description: 'Returns the number of Web service statements that have been processed.' },
        { label: 'CPU Time', value: 'cputime', description: 'Returns the CPU time (in milliseconds) that has been used in the current transaction.' },
        { label: 'DML Rows', value: 'dmlrows', description: 'Returns the number of records that have been processed with any statement that counts against DML limits, such as DML statements, the Database.emptyRecycleBin method and other methods.' },
        { label: 'DML Statements', value: 'dmlstatements', description: 'Returns the number of DML statements (such as insert/create, update, delete or the database.EmptyRecycleBin method) that have been called.' },
        { label: 'Email Invocations', value: 'emailinvocations', description: 'Returns the number of email invocations (such as sendEmail) that have been called.' },
        { label: 'Future Calls', value: 'futurecalls', description: 'Returns the number of methods with the future annotation that have been executed (not necessarily completed).' },
        { label: 'Heap Size', value: 'heapsize', description: 'Returns the approximate amount of memory (in bytes) that has been used for the heap.' },
        { label: 'Mobile Push Apex Calls', value: 'mobilepushapexcalls', description: 'Returns the number of Apex calls that have been used by mobile push notifications during the current metering interval.' },
        { label: 'Publish Immediate DML', value: 'publishimmediatedml', description: 'Returns the number of EventBus.publish calls that have been made for platform events configured to publish immediately.' },
        { label: 'Query Locator Rows', value: 'querylocatorrows', description: 'Returns the number of records that have been returned by the Database.getQueryLocator method.' },
        { label: 'Query Rows', value: 'queryrows', description: 'Returns the number of records that have been returned by issuing SOQL queries.' },
        { label: 'Queueable Jobs', value: 'queueablejobs', description: 'Returns the number of queueable jobs that have been added to the queue per transaction. A queueable job corresponds to a class that implements the Queueable interface.' },
        { label: 'SOQL Queries', value: 'queries', description: 'Returns the number of SOQL queries or number of GET that have been issued.' },
        { label: 'SOSL Queries', value: 'soslqueries', description: 'Returns the number of SOSL queries that have been issued.' }
    ];
}