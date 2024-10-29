public class CheckBlankFields {

    public class Input {
        @InvocableVariable(required=true)
        public SObject record;
        @InvocableVariable(required=true)
        public String fieldApiNames;
    }

    public class Output {
        @InvocableVariable
        public String blankFieldsListString;
    }

    @InvocableMethod(label='Check Blank Fields')
    public static List<Output> checkBlankFields(List<Input> inputList) {
        List<Output> outputList = new List<Output>();
        for (Input input : inputList) {
            SObject record = input.record;
            String fieldApiNames = input.fieldApiNames;
            if (record != null && fieldApiNames != null) {
                List<String> fieldApiNameList = fieldApiNames.split(',');
                List<String> blankFieldsList = new List<String>();
                for (String fieldApiName : fieldApiNameList) {
                    Schema.SObjectField field = record.getSObjectType().getDescribe().fields.getMap().get(fieldApiName);
                    if (field != null && (record.get(fieldApiName) == null || String.valueOf(record.get(fieldApiName)).trim() == '')) {
                        blankFieldsList.add(field.getDescribe().getLabel());
                    }
                }
                Output output = new Output();
                output.blankFieldsListString = String.join(blankFieldsList, ', ');
                outputList.add(output);
            }
        }
        return outputList;
    }
}