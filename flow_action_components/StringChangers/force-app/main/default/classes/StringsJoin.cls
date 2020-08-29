global class StringsJoin {
  @InvocableMethod(
    label='Join Strings'
    description='Joins a list of strings with optional delimiter'
    category='String Helper'
  )
  global static List<String> join(List<StringJoinParams> parm) {
    List<String> results = new List<String>();
    for (StringJoinParams p : parm) {
      results.add(String.join(p.arr, p.delim));
    }
    return results;
  }

  global class StringJoinParams {
    @InvocableVariable(
      label='String Collection'
      description='The list of strings to join'
      required=false
    )
    global String[] arr;

    @InvocableVariable(
      label='Delimiter'
      description='The delimiter to join with'
      required=false
    )
    global String delim;
  }
}
