@isTest
public class FolderResponseTest {
    
    @isTest
    public static void parse_parsesMap() {
        Map<String, Object> rawJson = (Map<String, Object>)JSON.deserializeUntyped('{ "folder": { "title": "title", "id": "id" }, "children": [ { "thread_id" : "thread_id" }, { "folder_id" : "folder_id" }]}');
        FolderResponse response = FolderResponse.parse(rawJson);
        System.assertEquals('title', response.folder.title);
        System.assertEquals('id', response.folder.id);
        System.assertEquals(2, response.children.size());
    }
}
