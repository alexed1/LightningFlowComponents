public interface RoleManagerProvider {
    String execute(String buttonName, String paramsString);
    List<RoleManagerController.MemberInfo> getExisting(String recordId);
    List<RoleManagerController.ButtonSetting> getSupportedButtons(String recordId);
}