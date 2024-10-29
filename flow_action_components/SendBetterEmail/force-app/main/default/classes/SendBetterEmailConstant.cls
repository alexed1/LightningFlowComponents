/**
 * @description  Constants for SendBetterEmail
 * @author   Mohith
 * @group            SendBetterEmail
 * @author  Jack D. Pond
 * Modifications Log
 * Ver   Date         Author         Modification
 * @since 1.0   02-06-2021   Jack D. Pond   Added DEFAULT_TREAT_TARGET_OBJECT_AS_RECIPIENT
 **/
@SuppressWarnings('PMD')
public without sharing class SendBetterEmailConstant {
    /**
     * @description Query the Organization for the LanguageLocaleKey
     *
     * @return      The organization's LanguageLocaleKey
     */
    public static String getOrganization() {
        return [SELECT LanguageLocaleKey FROM Organization LIMIT 1].LanguageLocaleKey;
    }

    public static final String MASSEMAIL = 'massEmail';

    public static final String LANGUAGE_EQUAL = 'Language="';

    public static final String DOUBLE_QUOTE = '"';

    public static final Boolean DEFAULT_TREAT_TARGET_OBJECT_AS_RECIPIENT = true;
}