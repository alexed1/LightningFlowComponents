global with sharing class StringsUnique {
  @InvocableMethod(
    label='Unique Strings'
    description='Given a collection of strings, returns a new collection without any duplicate values.'
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
      description='The list of strings to make unique'
      required=false
    )
    global String[] arr;

    @InvocableVariable(
      label='Ignore Case'
      description='Ignore string casing (case in-sensitive).  Casing of first occurrence will be returned.'
      required=false
    )
    global Boolean ignoreCase;
  }
}
