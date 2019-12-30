// Example of an invocable action associating an LWC component
global class CPEDemo {
    @InvocableMethod(label= 'Hello CPE' configurationEditor = 'c:configEditorLwc')
    public static void myMethod(List<Requests> requestList) {

    }

    public  class Requests {

        @InvocableVariable
        public String targetObject;

        @InvocableVariable
        public String targetField;

        @InvocableVariable
        public String targetValue;

    }
}