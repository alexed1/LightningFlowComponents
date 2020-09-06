@isTest
global with sharing class StringsUniqueTests {
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

  @isTest
  private static void testUniqueCaseIgnoreCase() {
    StringsUnique.StringUniqueParam p = new StringsUnique.StringUniqueParam();
    p.arr = new List<String>{ 'a', 'A', 'B', 'B', 'c' };
    p.ignoreCase = true;
    List<String[]> result = StringsUnique.unique(
      new List<StringsUnique.StringUniqueParam>{ p }
    );
    System.assertEquals(1, result.size());
    System.assertEquals(3, result[0].size());
  }
}
