public inherited sharing class Constant {
    
    public static String getOrganization() {
        return [SELECT LanguageLocaleKey FROM Organization LIMIT 1].LanguageLocaleKey;
    }
}
