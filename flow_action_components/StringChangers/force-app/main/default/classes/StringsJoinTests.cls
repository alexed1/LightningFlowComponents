@isTest
public with sharing class StringsJoinTests {
  @isTest
  private static void testJoin() {
    StringsJoin.StringJoinParams p = new StringsJoin.StringJoinParams();
    p.arr = new List<String>{ '1', '2', '3' };
    p.delim = ',';
    String[] result = StringsJoin.join(
      new List<StringsJoin.StringJoinParams>{ p }
    );
    System.assertEquals(1, result.size());
    System.assertEquals('1,2,3', result[0]);
  }
}
