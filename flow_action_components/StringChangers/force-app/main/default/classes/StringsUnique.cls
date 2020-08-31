global class StringsUnique {
  @InvocableMethod(
    label='Unique Strings'
    description='Returns only unique Strings'
    category='String Helper'
  )
  global static List<String[]> unique(List<StringUniqueParam> parm) {
    List<String[]> results = new List<String[]>();
    for (StringUniqueParam p : parm) {
      Set<String> pValues = new Set<String>();
      List<String> res = new List<String>();

      for (String s : p.arr) {
        String comp = p.ignoreCase != null && p.ignoreCase
          ? s.toLowerCase()
          : s;
        if (!pValues.contains(comp)) {
          res.add((s));
        }
        pValues.add(comp);
      }
      results.add(res);
    }
    return results;
  }

  global class StringUniqueParam {
    @InvocableVariable(
      label='String Collection'
      description='The list of strings to join'
      required=false
    )
    global String[] arr;

    // TODO
    @InvocableVariable(
      label='Ignore Case'
      description='Ignore string casing (case in-sensitive).'
      required=false
    )
    global Boolean ignoreCase;
  }
}
