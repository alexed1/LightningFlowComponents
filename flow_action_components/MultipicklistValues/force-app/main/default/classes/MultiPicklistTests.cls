@isTest
public class MultiPicklistTests {
  @isTest
  private static void testAdd() {
    MultiPicklistAdd.MultiPicklistAddParams p = new MultiPicklistAdd.MultiPicklistAddParams();
    p.picklistValues = 'one;two';
    p.target = 'one;four';
    List<String> results = MultiPicklistAdd.addPicklistVal(
      new List<MultiPicklistAdd.MultiPicklistAddParams>{ p }
    );
    System.assertEquals(1, results.size());
    System.assertEquals('one;two;four', results[0]);
  }

  @isTest
  private static void testRemove() {
    MultiPicklistRemove.MultiPicklistRemoveParams p = new MultiPicklistRemove.MultiPicklistRemoveParams();
    p.picklistValues = 'one;two';
    p.target = 'one;four';
    List<String> results = MultiPicklistRemove.removePicklistVal(
      new List<MultiPicklistRemove.MultiPicklistRemoveParams>{ p }
    );
    System.assertEquals(1, results.size());
    System.assertEquals('two', results[0]);
  }
}
