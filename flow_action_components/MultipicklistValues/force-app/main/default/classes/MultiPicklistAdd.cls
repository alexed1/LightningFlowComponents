global class MultiPicklistAdd {
  @InvocableMethod(
    label='Add Multi-Picklist Val(s)'
    description='Given A multi-picklist value (as string), will add the target the value(s) from it and return a new picklist value (as string)'
    category='Picklist'
  )
  global static List<String> addPicklistVal(
    List<MultiPicklistAddParams> params
  ) {
    List<String> results = new List<String>();
    for (MultiPicklistAddParams p : params) {
      String pickVals = p.picklistValues;
      String[] currentVals = pickVals.split(';');
      for (String target : p.target.split(';')) {
        target = target.trim();
        //check if the current value is already in the picklist (case-insensitive).  If not, add it
        Boolean found = false;
        for (String s : currentVals) {
          if (s.toLowerCase() == target.toLowerCase()) {
            found = true;
            break;
          }
        }

        if (!found) {
          pickVals += ';' + target;
        }
      }
      results.add(pickVals);
    }
    return results;
  }

  global class MultiPicklistAddParams {
    @InvocableVariable(
      label='Target Value'
      description='The Value(s) to Add. Supports multi, ";" separated values'
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
