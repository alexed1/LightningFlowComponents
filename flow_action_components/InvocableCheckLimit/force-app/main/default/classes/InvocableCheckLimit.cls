public class InvocableCheckLimit {
    public class Request {
        @InvocableVariable(label='Limit Name' required=true)
        public String limitName;
    }

    public class Response {
        @InvocableVariable(label='Total Limit')
        public Integer totalLimit;
        @InvocableVariable(label='Total Limit Issued')
        public Integer totalIssued;
        @InvocableVariable(label='Ratio Issued to Limit')
        public Decimal ratioIssuedToLimit;
    }

    @InvocableMethod(
        label='Invocable Check Limit'
        description='Returns the total limit, total issued, and ratio of issued to limit for a specified limit type'
        iconName='slds:standard:capacity_plan'
        configurationEditor='c-invocable-check-limit-cpe')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> responses = new List<Response>();

        for (Request request : requests) {
            Response response = new Response();

            // Use the name of the limit to determine which limit to check
            if(request.limitName != null) {
                switch on request.limitName.toLowerCase() {
                    when 'aggregatequeries' {
                        response.totalLimit = Limits.getLimitAggregateQueries();
                        response.totalIssued = Limits.getAggregateQueries();
                    }
                    when 'asynccalls' {
                        // Reserved for future use, actual implementation needed when available
                        response.totalLimit = Limits.getLimitAsyncCalls(); // Replace with actual limit retrieval when available
                        response.totalIssued = Limits.getAsyncCalls(); // Replace with actual issued count retrieval when available
                    }
                    when 'callouts' {
                        response.totalLimit = Limits.getLimitCallouts();
                        response.totalIssued = Limits.getCallouts();
                    }
                    when 'cputime' {
                        response.totalLimit = Limits.getLimitCpuTime();
                        response.totalIssued = Limits.getCpuTime();
                    }
                    when 'dmlrows' {
                        response.totalLimit = Limits.getLimitDMLRows();
                        response.totalIssued = Limits.getDMLRows();
                    }
                    when 'dmlstatements' {
                        response.totalLimit = Limits.getLimitDMLStatements();
                        response.totalIssued = Limits.getDMLStatements();
                    }
                    when 'emailinvocations' {
                        response.totalLimit = Limits.getLimitEmailInvocations();
                        response.totalIssued = Limits.getEmailInvocations();
                    }
                    when 'futurecalls' {
                        response.totalLimit = Limits.getLimitFutureCalls();
                        response.totalIssued = Limits.getFutureCalls();
                    }
                    when 'heapsize' {
                        response.totalLimit = Limits.getLimitHeapSize();
                        response.totalIssued = Limits.getHeapSize();
                    }
                    when 'mobilepushapexcalls' {
                        response.totalLimit = Limits.getLimitMobilePushApexCalls();
                        response.totalIssued = Limits.getMobilePushApexCalls();
                    }
                    when 'publishimmediatedml' {
                        response.totalLimit = Limits.getLimitPublishImmediateDML();
                        response.totalIssued = Limits.getPublishImmediateDML();
                    }
                    when 'queries' {
                        response.totalLimit = Limits.getLimitQueries();
                        response.totalIssued = Limits.getQueries();
                    }
                    when 'queryrows' {
                        response.totalLimit = Limits.getLimitQueryRows();
                        response.totalIssued = Limits.getQueryRows();
                    }
                    when 'queueablejobs' {
                        response.totalLimit = Limits.getLimitQueueableJobs();
                        response.totalIssued = Limits.getQueueableJobs();
                    }
                    when 'soslqueries' {
                        response.totalLimit = Limits.getLimitSoslQueries();
                        response.totalIssued = Limits.getSoslQueries();
                    }
                    when 'querylocatorrows' {
                        response.totalLimit = Limits.getLimitQueryLocatorRows();
                        response.totalIssued = Limits.getQueryLocatorRows();
                    }
                    // Add more 'when' cases for other limit types as necessary
                }
            }

            // Calculate the ratio of issued to limit, being careful to avoid division by zero
            response.ratioIssuedToLimit = (response.totalLimit != null && response.totalIssued != null && response.totalLimit > 0) ? (Decimal.valueOf(response.totalIssued) / Decimal.valueOf(response.totalLimit)) : null;

            responses.add(response);
        }

        return responses;
    }
}