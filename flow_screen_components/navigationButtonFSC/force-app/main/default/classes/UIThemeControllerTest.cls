/* Class:       UIThemeControllerTest
 * Created On:  11/23/18
 * Created by:  Eric Smith
 * Description: Test Class for Contoller to return current theme to a Lightning Component
 */

 @isTest
public class UIThemeControllerTest {
    
    static testMethod void getCurrentTheme() {
        UIThemeController theme = new UIThemeController();
        integer cnt = 0;
        string myTheme = UIThemeController.getUIThemeDescription();
        if (myTheme == 'Salesforce Classic') {
        	cnt = cnt+1;
        }
        if (myTheme == 'Lightning Experience') {
        	cnt = cnt+1;
        }
        if (myTheme == 'Salesforce1 Mobile') {
        	cnt = cnt+1;
        }
		system.assertEquals(1, cnt);     
    }

}
