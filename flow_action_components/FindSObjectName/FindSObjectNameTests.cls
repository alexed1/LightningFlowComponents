@istest
public class FindSObjectNameTests {
    @istest
    public static void MainTest() {
		List<FindSObjectName.Request> requestList;
        
        requestList = new List<FindSObjectName.Request>();
		
        Contact c = new Contact(FirstName='John', LastName='Smith');
        System.debug('Creating a Contact: ' + c.id);
           // Insert Contact
        insert c;
        
		FindSObjectName.Request request = new FindSObjectName.Request();
		request.recId = c.id;
        requestList.add(request);
        
        List<FindSObjectName.Response> response = FindSObjectName.execute(requestList);
        System.assertEquals(response[0].outputValue, 'Contact' );

        }
}