/* @author: Munawir
 * @authorEmail: munawirrahman@gmail.com
 * @Description: Parse Anything with Expected Text Template in Flow
 * @Inputs:
     * ExpectedTextTemplate ==> Contract for parsing text
     * ActualText ==> Actual text to parse
 * @Outputs:
    * Value01 to Value20
 * @Created Date: 14/02/2021. Initial commit
 * @Change Logs: - 
 */

public class ParseAnything {
    public class Request {
        @InvocableVariable(label='Expected Text Template' required=True)
        public String ExpectedTextTemplate;
        @InvocableVariable(label='Actual Text' required=True)
        public String ActualText;
    }
    public class Response {
        @InvocableVariable(label='Value01')
        public String Value01;
        @InvocableVariable(label='Value02')
        public String Value02;
        @InvocableVariable(label='Value03')
        public String Value03;
        @InvocableVariable(label='Value04')
        public String Value04;
        @InvocableVariable(label='Value05')
        public String Value05;
        @InvocableVariable(label='Value06')
        public String Value06;
        @InvocableVariable(label='Value07')
        public String Value07;
        @InvocableVariable(label='Value08')
        public String Value08;
        @InvocableVariable(label='Value09')
        public String Value09;
        @InvocableVariable(label='Value10')
        public String Value10;
        @InvocableVariable(label='Value11')
        public String Value11;
        @InvocableVariable(label='Value12')
        public String Value12;
        @InvocableVariable(label='Value13')
        public String Value13;
        @InvocableVariable(label='Value14')
        public String Value14;
        @InvocableVariable(label='Value15')
        public String Value15;
        @InvocableVariable(label='Value16')
        public String Value16;
        @InvocableVariable(label='Value17')
        public String Value17;
        @InvocableVariable(label='Value18')
        public String Value18;
        @InvocableVariable(label='Value19')
        public String Value19;
        @InvocableVariable(label='Value20')
        public String Value20;
    }
    
    @InvocableMethod(label='Parse Anything' description='Parse any Text with Expected Text')
    public static List<Response> Invoke (List<Request> requests) {
        List<Response> responseList = new List<Response>();
        for (Request curRequest : requests) {
            Response response = new Response();
            response.Value01 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_1}');
            if(!String.isBlank(response.Value01)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_1}', response.Value01);}
            
            response.Value02 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_2}');
            if(!String.isBlank(response.Value02)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_2}', response.Value02);}
            
            response.Value03 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_3}');
            if(!String.isBlank(response.Value03)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_3}', response.Value03);}
            
            response.Value04 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_4}');
            if(!String.isBlank(response.Value04)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_4}', response.Value04);}
            
            response.Value05 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_5}');
            if(!String.isBlank(response.Value05)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_5}', response.Value05);}
            
            response.Value06 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_6}');
            if(!String.isBlank(response.Value06)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_6}', response.Value06);}
            
            response.Value07 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_7}');
            if(!String.isBlank(response.Value07)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_7}', response.Value07);}
            
            response.Value08 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_8}');
            if(!String.isBlank(response.Value08)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_8}', response.Value08);}
            
            response.Value09 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_9}');
            if(!String.isBlank(response.Value09)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_9}', response.Value09);}
            
            response.Value10 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_10}');
            if(!String.isBlank(response.Value10)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_10}', response.Value10);}
            
            response.Value11 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_11}');
            if(!String.isBlank(response.Value11)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_11}', response.Value11);}
            
            response.Value12 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_12}');
            if(!String.isBlank(response.Value12)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_12}', response.Value12);}
            
            response.Value13 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_13}');
            if(!String.isBlank(response.Value13)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_13}', response.Value13);}
            
            response.Value14 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_14}');
            if(!String.isBlank(response.Value14)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_14}', response.Value14);}
            
            response.Value15 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_15}');
            if(!String.isBlank(response.Value15)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_15}', response.Value15);}
            
            response.Value16 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_16}');
            if(!String.isBlank(response.Value16)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_16}', response.Value16);}
            
            response.Value17 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_17}');
            if(!String.isBlank(response.Value17)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_17}', response.Value17);}
            
            response.Value18 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_18}');
            if(!String.isBlank(response.Value18)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_18}', response.Value18);}
            
            response.Value19 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_19}');
            if(!String.isBlank(response.Value19)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_19}', response.Value19);}
            
            response.Value20 = TextParser(curRequest.ExpectedTextTemplate, curRequest.ActualText,'{?Field_20}');
            if(!String.isBlank(response.Value20)){curRequest.ExpectedTextTemplate = curRequest.ExpectedTextTemplate.replace('{?Field_20}', response.Value20);}
            
            responseList.add(response);
        }
        return responseList;
    }
    
    private static String TextParser(String ExpectedTextTemplate, String ActualText, String CurrentField){
        String ActualSubstring;
        if(ExpectedTextTemplate.contains(CurrentField)){
            String NextField = '{?Field_'+(Integer.valueOf(CurrentField.substringBetween('{?Field_','}'))+1)+'}';
            String LeftOfCurrentField = ExpectedTextTemplate.substringBefore(CurrentField);
            String RightOfCurrentField = ExpectedTextTemplate.substringAfter(CurrentField);
            String DistanceBetweenFields = ExpectedTextTemplate.substringBetween(CurrentField,NextField);
            Boolean isNextFieldFound = ExpectedTextTemplate.contains(NextField);
            
            //only 1 field left
            if(!isNextFieldFound){
                //Substring in the start of text
                if(String.IsBlank(LeftOfCurrentField)){
                    ActualSubstring = ActualText.SubstringBefore(RightOfCurrentField);
                }
                //Substring in the end of text
                else if(String.IsBlank(RightOfCurrentField)){
                    ActualSubstring = ActualText.SubstringAfter(LeftOfCurrentField);
                }
                //Substring in the middle of text
                else{
                    ActualSubstring = ActualText.SubstringBetween(LeftOfCurrentField,RightOfCurrentField);
                }
            }
            // more than 1 field left
            else{
                ActualSubstring = Actualtext.substringBetween(LeftOfCurrentField, DistanceBetweenFields);
            } 
        }
        else{
            ActualSubstring = null;
        }
        system.debug('ActualSubstring of '+ CurrentField +' is '+ActualSubstring);
        return ActualSubstring;
    }
}
