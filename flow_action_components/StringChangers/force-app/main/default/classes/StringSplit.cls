global class StringSplit {
  @InvocableMethod(
    label='Splits a string in an array of strings'
    description='Given a string and a delimiter, will split the string into a collection of strings'
    category='String Helpers'
  )
  global static List<List<String>> stringSplit(List<StringSplitParams> params) {
    List<String[]> results = new List<String[]>();
    for (StringSplitParams p : params) {
      if (p.str == null) {
        results.add(new List<String>{});
        continue;
      }
      if (p.delim == null) {
        results.add(new List<String>{ p.str });
        continue;
      }

      results.add(p.str.split(p.delim));
    }
    return results;
  }

  global class StringSplitParams {
    @InvocableVariable(
      label='String'
      description='The string to split'
      required=false
    )
    global String str;

    @InvocableVariable(
      label='Delimiter'
      description='The delimiter to split on'
      required=false
    )
    global String delim;
  }
}
