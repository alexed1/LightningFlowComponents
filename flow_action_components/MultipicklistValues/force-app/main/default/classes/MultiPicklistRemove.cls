global class MultiPicklistRemove {
  @InvocableMethod(
    label='Remove Multi-Picklist Val'
    description='Given A multi-picklist value (as string), will remove the target the value from it and return a new picklist value (as string)'
    category='Picklist'
  )
  global static List<String> removePicklistVal(
    List<MultiPicklistRemoveParams> params
  ) {
    list<String> results = new List<String>();
    for (MultiPicklistRemoveParams p : params) {
      String pickVals = p.picklistValues;
      Set<String> targetSet = new Set<String>();
      for (String target : p.target.split(';')) {
        targetSet.add(target.trim());
      }
      Set<String> newList = new Set<String>();

      for (String s : pickVals.split(';')) {
        if (!targetSet.contains(s.trim().toLowerCase())) {
          newList.add(s);
        }
      }

      String res = String.join((Iterable<String>) newList, ';');
      results.add(res);
    }
    return results;
  }

  global class MultiPicklistRemoveParams {
    @InvocableVariable(
      label='Target Value'
      description='The Value(s) to Remove. ";" separated'
      required=true
    )
    global String target;

    @InvocableVariable(
      label='Picklist Values'
      description='The current value of the multi-picklist'
      required=false
    )
    global String picklistValues;
  }
}
