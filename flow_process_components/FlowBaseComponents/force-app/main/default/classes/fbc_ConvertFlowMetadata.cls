public with sharing class fbc_ConvertFlowMetadata {
 
    public static String SOAP_NS = 'http://soap.sforce.com/2006/04/metadata';

    @InvocableMethod
    public static List <Results> convert(List<Requests> requestList) {
        System.debug('entering invocable method fbc_ConvertFlowMetadata.convert');
        Results response = new Results();
        List<Results> responseWrapper = new List<Results>();
        String flowName;

        for (Requests req : requestList) {
            System.debug('zip file text is:' + req.flowMetadataZipFile);
            System.debug('flowname is:' + req.flowName);

            String flowmetadata = unpackZipfile( req.flowMetadataZipFile);
            System.debug('initial retrieved unconverted pb metadata is: ' + flowmetadata);
            String validityProblemString = fbc_ValidateMetadata.validate (flowmetadata);
            System.debug('validtyProblemString is: ' + validityProblemString);
            if(validityProblemString == '') {
                String metadataText = convertMetadata(flowmetadata, req.flowName);
                response.convertedFlowMetadata = metadataText;
            } else {
                response.errors = validityProblemString;
            }
            
            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    public static String unpackZipfile(String metadataZipfile) {

             
        Blob zipBlob = EncodingUtil.base64Decode(metadataZipfile);
        fbc_Zippex curZippex = new fbc_Zippex(zipBlob);
        Set<String> fileNames = curZippex.getFileNames();
        System.debug('filenames are: ' + fileNames);
     
        List<String> filenamesList = new List<String>(fileNames);

           //currently only set up to handle a single file
        Blob fileData = curZippex.getFile(filenamesList[0]);
        System.debug ('filename: ' + filenamesList[0]);
        return  fileData.toString();
    }

    public static String convertMetadata(String metadata, String flowName) {
        Dom.Document doc = new Dom.Document();
        doc.load(metadata);
        Dom.XMLNode flowXML = doc.getRootElement();
       // System.debug('root node is:' + flowXML);
       
        Dom.XmlNode pmv_ObjectType = fbc_XmlUtils.getChildProcessMetadataValueByName(flowXML,'ObjectType');
        String contextObjectType = fbc_XmlUtils.getProcessMetadataValue(pmv_ObjectType);
        System.debug('contextObjectType for flow: ' + flowName +' is: ' + contextObjectType);

        Dom.XmlNode  pmv_TriggerType = fbc_XmlUtils.getChildProcessMetadataValueByName(flowXML,'TriggerType');
        String triggerType = fbc_XmlUtils.getProcessMetadataValue(pmv_TriggerType);
        System.debug('triggerType for flow: ' + flowName +' is: ' + triggerType); 
        String startElementReference = flowXML.getChildElement('startElementReference', SOAP_NS).getText();
        String newProcessType = 'AutolaunchedFlow';
        
        flowXML = fbc_ModifyFlowMetadata.changeProcessType(flowXML, newProcessType);
        flowXML = fbc_ModifyFlowMetadata.setStatus(flowXML, 'Draft' );
        flowXML = fbc_ModifyFlowMetadata.addStartElement(flowXML, contextObjectType, triggerType, startElementReference);
        fbc_ModifyFlowMetadata.removeExcessPMV(flowXML, 'ObjectType');
        fbc_ModifyFlowMetadata.removeExcessPMV(flowXML, 'ObjectVariable');
        fbc_ModifyFlowMetadata.removeExcessPMV(flowXML, 'OldObjectVariable');
        fbc_ModifyFlowMetadata.removeExcessPMV(flowXML, 'RecursiveCountVariable');
        fbc_ModifyFlowMetadata.removeExcessPMV(flowXML, 'TriggerType');
        doc = fbc_ModifyFlowMetadata.changeContextReference(doc);  
        doc = fbc_ModifyFlowMetadata.fixupRelatedReferences(doc);
        fbc_ModifyFlowMetadata.repositionElements(doc);
             
        String classText = doc.toXmlString();
        System.debug('===========');
        System.debug ('following all conversion, is: ' + classText);
        //deployChangedMetadata(classText, flowName, null, 'Flow');         
        return classText;
            
    }
 

    public static void deployChangedMetadata(String classText, String className, String testLevel, String objectType) {

        fbc_DeployMetadata.deploy(classText, className, testLevel, objectType);


    }

 
    

    public class Requests {
       
        @InvocableVariable 
        public String flowName;

        @InvocableVariable 
        public String flowMetadataZipFile;

       

      

    }

    public class Results {

        @InvocableVariable
        public String errors;

       
        @InvocableVariable
        public String convertedFlowMetadata;

    }

    public class PBConvertException extends Exception{}
}