@isTest
public class StringsTests {
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

  @isTest
  private static void testUnique() {
    StringsUnique.StringUniqueParam p = new StringsUnique.StringUniqueParam();
    p.arr = new List<String>{ '1', '1', '2', '3', '2' };
    List<String[]> result = StringsUnique.unique(
      new List<StringsUnique.StringUniqueParam>{ p }
    );
    System.assertEquals(1, result.size());
    System.assertEquals(3, result[0].size());
  }
}
