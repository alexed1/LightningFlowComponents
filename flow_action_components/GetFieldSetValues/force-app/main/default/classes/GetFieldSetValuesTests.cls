AND(
CONTAINS([Task].Subject, "4+ CEU Credits"), 
  LEFT([Task].WhoId, 3) = '003',
CONTAINS([Task].Description, "Pete"),
NOT(CONTAINS([Task].Subject, "Extra CEU")
)
)


B. ApexPages.StandardController controller = new ApexPages.StandardController(Database.getQueryLocator('select Id from Account Limit 1');

D.ApexPages.StandardSetController controller = new ApexPages.StandardSetController(Database.getQueryLocator('select Id from Account Limit 1');