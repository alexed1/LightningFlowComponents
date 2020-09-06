@isTest
public with sharing class StringSplitTests {
  @isTest
  private static void testSplit() {
    StringSplit.StringSplitParams p = new StringSplit.StringSplitParams();
    p.str = '1;2;3';
    p.delim = ';';
    List<String[]> result = StringSplit.stringSplit(
      new List<StringSplit.StringSplitParams>{ p }
    );
    System.assertEquals(1, result.size());
    System.assertEquals(3, result[0].size());
    System.assertEquals('1', result[0][0]);
  }
}
