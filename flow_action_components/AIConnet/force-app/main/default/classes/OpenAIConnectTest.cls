@isTest
public class OpenAIConnectTest {
    @isTest
    static void testConnect() {
        // Create test input
        List<OpenAIConnect.openAiInputs> inputs = new List<OpenAIConnect.openAiInputs>();
        OpenAIConnect.openAiInputs input = new OpenAIConnect.openAiInputs();
        input.openaiInput = 'What is the weather like today?';
        input.openaiInstruction = 'Please provide a weather forecast for today.';
        input.settingsModel = null;
        input.settingsTokens = null;
        input.settingsTemperature = null;
        input.settingsEndpoint = 'OpenAICompletions';
        inputs.add(input);

        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        
        res.setBody('{"text": "The weather forecast for today is sunny and warm with a high of 80 degrees Fahrenheit.", "id": "abc123", "finish_reason": "finish", "total_tokens": 2000, "message" : "Error Message"}');
        // Set up the mock callout
        Test.setMock(HttpCalloutMock.class, new OpenAIConnectMock(res));
        
        // Call the connect method and verify the output
        List<OpenAIConnect.openAiOutputs> outputs = OpenAIConnect.connect(inputs);
        OpenAIConnect.openAiOutputs output = outputs[0];
        
        if(res.getStatusCode() == 200){
            System.assertEquals('The weather forecast for today is sunny and warm with a high of 80 degrees Fahrenheit.', output.openAiTextOutput);
            System.assertEquals('abc123', output.replyID);
            System.assertEquals('finish', output.finishReason);
        }  
    }

    // Create a mock implementation of the HttpCalloutMock interface
    public class OpenAIConnectMock implements HttpCalloutMock {
        HttpResponse res;
        OpenAIConnectMock(HttpResponse res) {
            this.res = res;
        }
    
        public HttpResponse respond(HttpRequest req) {
            return res;
        }
    }
}
