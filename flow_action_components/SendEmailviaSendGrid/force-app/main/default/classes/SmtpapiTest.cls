@isTest
private class SmtpapiTest {
  
  @isTest static void testHasAJsonStringMethod() {
    Smtpapi.Header header = new Smtpapi.Header();

    system.assertEquals('{}', header.jsonString());
  }

  @isTest static void testAddTo() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addTo('addTo@mailinator.com');
    system.assertEquals('{\"to\":[\"addTo@mailinator.com\"]}', header.jsonString());
  }

  @isTest static void testSetTos() {
    Smtpapi.Header header = new Smtpapi.Header();

    List<String> tos = new List<String> { 'setTos@mailinator.com' };
    header.setTos(tos);
    system.assertEquals('{\"to\":[\"setTos@mailinator.com\"]}', header.jsonString());
  }

  @isTest static void testAddSubstitution() {
    Smtpapi.Header header = new Smtpapi.Header();

    List<String> vals = new List<String> { 'val' };
    header.addSubstitution('sub', vals);
    system.assertEquals('{\"sub\":{\"sub\":[\"val\"]}}', header.jsonString());
  }

  @isTest static void testSetSubstitutions() {
    Smtpapi.Header header = new Smtpapi.Header();

    List<String> vals = new List<String> { 'val' };
    Map<String, Object> substitutions = new Map<String, Object>{ 'sub' => vals };
    header.setSubstitutions(substitutions);

    system.assertEquals('{\"sub\":{\"sub\":[\"val\"]}}', header.jsonString());
  }

  @isTest static void testAddUniqueArg() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addUniqueArg('add_unique_argument_key', 'add_unique_argument_value');
    header.addUniqueArg('add_unique_argument_key_2', 'add_unique_argument_value_2');
    system.assertEquals('{\"unique_args\":{\"add_unique_argument_key_2\":\"add_unique_argument_value_2\",\"add_unique_argument_key\":\"add_unique_argument_value\"}}', header.jsonString());
  }

  @isTest static void setAddUniqueArgs() {
    Smtpapi.Header header = new Smtpapi.Header();

    Map<String, String> args = new Map<String, String> { 'set_unique_argument_key' => 'set_unique_argument_value' };
    header.setUniqueArgs(args);
    system.assertEquals('{\"unique_args\":{\"set_unique_argument_key\":\"set_unique_argument_value\"}}', header.jsonString());
  }

  @isTest static void testAddCategory() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addCategory('addCategory');
    header.addCategory('addCategory2');
    system.assertEquals('{\"category\":[\"addCategory\",\"addCategory2\"]}', header.jsonString());
  }

  @isTest static void setCategories() {
    Smtpapi.Header header = new Smtpapi.Header();

    List<String> categories = new List<String> { 'setCategories' };
    header.setCategories(categories);
    system.assertEquals('{\"category\":[\"setCategories\"]}', header.jsonString());
  }

  @isTest static void testAddSection() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addSection('set_section_key', 'set_section_value');
    header.addSection('set_section_key_2', 'set_section_value_2');
    system.assertEquals('{\"section\":{\"set_section_key\":\"set_section_value\",\"set_section_key_2\":\"set_section_value_2\"}}', header.jsonString());
  }

  @isTest static void setSetSections() {
    Smtpapi.Header header = new Smtpapi.Header();

    Map<String, String> sections = new Map<String, String> { 'set_section_key' => 'set_section_value' };
    header.setSections(sections);
    system.assertEquals('{\"section\":{\"set_section_key\":\"set_section_value\"}}', header.jsonString());
  }

  @isTest static void testAddFilter() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addFilter('footer', 'text/html', '<strong>boo</strong>');
    system.assertEquals('{\"filters\":{\"footer\":{\"settings\":{\"text/html\":\"<strong>boo</strong>\"}}}}', header.jsonString());
  }

  @isTest static void testAddFilterMultiple() {
    Smtpapi.Header header = new Smtpapi.Header();

    header.addFilter('footer', 'enable', '1');
    header.addFilter('footer', 'text/html', '<strong>boo</strong>');
    system.assertEquals('{\"filters\":{\"footer\":{\"settings\":{\"text/html\":\"<strong>boo</strong>\",\"enable\":\"1\"}}}}', header.jsonString());
  }

  @isTest static void setSetFilters() {
    Smtpapi.Header header = new Smtpapi.Header();

    Map<String, Map<String, Map<String,String>>> filters = new Map<String, Map<String, Map<String,String>>>();
    filters.put('footer', new Map<String, Map<String,String>>());
    filters.get('footer').put('settings', new Map<String,String>());
    filters.get('footer').get('settings').put('enable', '1');
    filters.get('footer').get('settings').put('text/plain', 'You can haz footers!');

    header.setFilters(filters);
    system.assertEquals('{\"filters\":{\"footer\":{\"settings\":{\"enable\":\"1\",\"text/plain\":\"You can haz footers!\"}}}}', header.jsonString());
  }
}