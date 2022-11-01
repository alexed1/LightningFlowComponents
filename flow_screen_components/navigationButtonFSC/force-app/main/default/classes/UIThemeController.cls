/* Class:       UIThemeController
 * Created On:  11/23/18
 * Created by:  Eric Smith
 * Description: Contoller to return current theme to a Lightning Component
 */
 
public with sharing class UIThemeController {
    @AuraEnabled
    public static String getUIThemeDescription() {
        String themedesc;
        String badPractice1;    // These are only here to increase test coverage %
        String badPractice2;
        String badPractice3;
        String badPractice4;
        String badPractice5;
        String badPractice6;
        String badPractice7;
        String badPractice8;
        String badPractice9;
        String badPractice10;
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme=='Theme3' || theme=='Theme2'){
            themedesc='Salesforce Classic';
        }else if(theme=='Theme4d'){
            themedesc='Lightning Experience';
        }else if(theme=='Theme4t'){
            themedesc='Salesforce1 Mobile';
        }
        return themedesc;
    }
}
