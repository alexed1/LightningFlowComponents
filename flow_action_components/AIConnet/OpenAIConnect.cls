public class OpenAIConnect {
    @invocableMethod 
        public static List <openAiOutputs> connect(List<openAiInputs> inputs){
        //defines the output list
        List<openAiOutputs> outputs = new List<openAiOutputs>();
            for	(openAiInputs curInput : inputs){
                String userInput = curInput.openaiInput;
                String instruction = curInput.openaiInstruction;
                String prompt = curInput.openaiPrompt;
                String model = curInput.settingsModel;
                Integer tokens = curInput.settingsTokens;
                Double temperature = curInput.settingsTemperature;
                String endpoint = curInput.settingsEndpoint;
                openAiOutputs output = new openAiOutputs();
                String openAiTextOutput = '';
                String openAiMessage = '';
                String finishReason = '';
                String replyID ='';
                Integer tokensUsed = 0;
                
            //set default values for prompt, model, tokens and maximum temperature if not provided by Flow
            if (prompt == '' || prompt == null){
                prompt = userInput + ' ' + instruction;
            }
               if (model == null || model == ''){
                    model = 'text-davinci-003';
                    system.debug('Modell: ' +model);
            }
            if (tokens < 0 || tokens > 4096 || tokens == null){
                    tokens = 1000;
                    system.debug('Tokens: ' +tokens);
            }
            if (temperature < 0 || temperature > 1 || temperature == null){
                    temperature = 0.1;
                    system.debug('Temperature: ' +temperature);
            }
                HttpRequest req = new HttpRequest();
                //set the endpoint to the endpoint defined in named credentials of Salesforce
                req.setEndpoint('callout:'+endpoint+'');
                //set the timeout to 2 minutes
                req.setTimeout(120000);
                //define POST for method endpoint
                req.setMethod('POST');
                //set the body of the request
                req.setBody(
                    '{"model": "'+model+'", "prompt": "'+prompt+'", "max_tokens": '+tokens+', "temperature": '+temperature+', "top_p": 0.2, "n": 1}');
                //create a new HTTP object
                Http http = new Http();
                //send the request
                HttpResponse res = http.send(req);
                
                //create a new JSON parser
                JSONParser parser = JSON.createParser(res.getBody());
                    //create variables to store the reason for finishing and the reply ID
                       
                    
                    //loop through the response
                    while (parser.nextToken() != null) {
                        //if the current token is a field name and the text is 'text'
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'text')) {
                            // Get the value.
                            parser.nextToken();
                            // Add the text to the output variable
                            output.openAiTextOutput = parser.getText();
                        }
                        //if the current token is a field name and the text is 'id'
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'id')) {
                            // Get the value.
                            parser.nextToken();
                            // Add the text to the output variable
                            output.replyID = parser.getText();
                        }
                        //if the current token is a field name and the text is 'finish_reason'
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'finish_reason')) {
                            // Get the value.
                            parser.nextToken();
                            // Add the text to the output variable
                            output.finishReason = parser.getText();
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'total_tokens')) {
                            // Get the value.
                            parser.nextToken();
                            // Add the integer to the output variable
                            output.tokensUsed = parser.getIntegerValue();
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'message')) {
                            // Get the value.
                            parser.nextToken();
                            // Add the integer to the output variable
                            openAiTextOutput = parser.getText();
                        }
                    } 
                // Check the status code of the response
                if (res.getStatusCode() == 200){
                    System.debug('Response Body: ' + res.getBody());
                    System.debug('ReplyID: ' + replyID);
                    System.debug('finishReason: '+ finishReason);
                    System.debug('tokensUsed: '+ tokensUsed);
                }
                else{
                    output.openAiTextOutput = openAiMessage;
                    System.debug('Error connecting to OpenAI: ' + res.getStatusCode() + '' + res.getStatus()+ '' + res.getBody());
                }
                //add the output to the output list
                outputs.add(output);
            }
        //return the output list
        return outputs; 
    }
        
        public class openAiInputs{
            @InvocableVariable(required=false label='Open AI Instruction' description='Is what the AI should do with the input')
                public String openaiInstruction;
            @InvocableVariable(required=false label='Open AI Input' description='Is the input into the AI model')
                public String openaiInput;
            @InvocableVariable(required=false label='Open AI Prompt' description='Is a composition of Input and Instruction. Leave empty if Input and Instruction are provided')
                public String openaiPrompt;
            @InvocableVariable(required=false label='Open AI Model' description='Defines the model used of the AI.')
                public String settingsModel;
            @InvocableVariable(required=false label='Tokens' description='Maximum Tokens to be used.')
                public Integer settingsTokens;
            @InvocableVariable(required=false label='Temperature' description='Temperature of the model to be used.')
                public Double settingsTemperature;
            @InvocableVariable(required=false label='Open AI Endpoint Name' description='Endpoint to which you want to call.')
                public String settingsEndpoint;
        }
        public class openAiOutputs{
            @InvocableVariable(required=false label='Open AI Text Output' description='Provides the text response from OpenAI model as a String.')
            public String openAiTextOutput;
            @InvocableVariable(required=false label='ReplyId' description='ReplyID of the Ai response')
            public String replyID;
            @InvocableVariable(required=false label='Finish Reason' description='Reason the AI stopped responding')
            public String finishReason;
            @InvocableVariable(required=false label='Tokens Used' description='Amount of tokens used.')
            public Integer tokensUsed;
        }
        
    }
