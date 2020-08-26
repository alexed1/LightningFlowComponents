public inherited sharing class Constant {
    
    public static String getOrganization() {
        return [SELECT LanguageLocaleKey FROM Organization LIMIT 1].LanguageLocaleKey;
    }

    public static final String MASSEMAIL = 'massEmail';

    public static final String LANGUAGE_EQUAL = 'Language="';

    public static final String DOUBLE_QUOTE = '"';
}
