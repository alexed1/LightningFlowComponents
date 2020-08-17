@isTest
public with sharing class fbc_ExtractMetadataStringFromZipfileTest {
    
    static testMethod void test()  {

        String zipFile = 'UEsDBBQACAgIAD1wEVEAAAAAAAAAAAAAAAAUAAAAZmxvd3MvVGVzdF9GbG93LmZsb3fNU11P3DAQfM+viPLeczgoQpXP6GiFhHQIqT2q8oRMbi9nybEje3PAv6/jfDkJBR6bt50d27MzWXr5Usj4CMYKrVbJySJNYlCZ3gmVr5L77fWXi+SSRfRa6ufYUZVdJQfE8hshVvNyYffaZLDIdEGWaXpO0jNSAPIdR56wKHYf5daKXBWg0DaIRxUvgG3B4uPa9ynxyECQ/AmkZ8Qdo4ECis44Ot1/2NnywrX7ck55YCeny4HyEFAGfTcIRaAx6G71T9iDcc4AO3JDyRweH9MlGI7asE57D4x5Ry6ryVmPWzQugd++u6YkLMcXkMkNnbTJPCHcQUIhmKOA581gdZ0zJZNONA2kYQVx0NLoDKy9bbP3SmdxX1VC7sBsX0uYxf2GESMTNiI/oHJl/XZ70T98GXlCyTvSPif7zohcqP9WfK2IrSvUG16p7AC7Jp2wG7WKuME31+dr+tH2hIxweTKtFGTz/9o9lQMO2zHa9GkzGH5yX21SL7oeACvLfhi+R9+pq6hNwAj+JOfh+W2dxFU76X355ROgpAcGjrDftZROihuY7bm0LvURFlJvVFnhwGrKkHBX4YjR1lGXeC+ekjo9Fv0FUEsHCJnFc03DAQAAmAUAAFBLAwQUAAgICAA9cBFRAAAAAAAAAAAAAAAACwAAAHBhY2thZ2UueG1sTU67DsIwENvzFVF2cgFVqELXdOvMUGYU0qMgmqRqIh5/T9WHwJN9tnzG8u06/qQh3oMvxFYqwcnb0Nx9W4hTXW1yUWqGR2MfpiU+pn0sxC2l/gAQg+llvIbBkrTBwU6pPagMHCXTmGSEZnwEpk9PceaTduQu40tdU0znqgsvhPX0C3njSM/mROcq+OvCZbfOcqkQVsUQlrmafQFQSwcI7kY5IZsAAADgAAAAUEsBAhQAFAAICAgAPXARUZnFc03DAQAAmAUAABQAAAAAAAAAAAAAAAAAAAAAAGZsb3dzL1Rlc3RfRmxvdy5mbG93UEsBAhQAFAAICAgAPXARUe5GOSGbAAAA4AAAAAsAAAAAAAAAAAAAAAAABQIAAHBhY2thZ2UueG1sUEsFBgAAAAACAAIAewAAANkCAAAAAA==';
        
        String extractedFile = '<?xml version="1.0" encoding="UTF-8"?>' + '\n' +
        '<Flow xmlns="http://soap.sforce.com/2006/04/metadata">' + '\n' +
        '<assignments>' + '\n' +
        '<name>Test_Assign</name>' + '\n' +
        '<label>Test Assign</label>' + '\n' +
        '<locationX>428</locationX>' + '\n' +
        '<locationY>132</locationY>' + '\n' +
        '<assignmentItems>' + '\n' +
        '<assignToReference>var</assignToReference>' + '\n' +
        '<operator>Assign</operator>' + '\n' +
        '<value>' + '\n' +
        '<stringValue>A</stringValue>' + '\n' +
        '</value>' + '\n' +
        '</assignmentItems>' + '\n' +
        '</assignments>' + '\n' +
        '<interviewLabel>Test Flow</interviewLabel>' + '\n' +
        '<label>Test Flow</label>' + '\n' +
        '<processMetadataValues>' + '\n' +
        '<name>BuilderType</name>' + '\n' +
        '<value>' + '\n' +
        '<stringValue>LightningFlowBuilder</stringValue>' + '\n' +
        '</value>' + '\n' +
        '</processMetadataValues>' + '\n' +
        '<processMetadataValues>' + '\n' +
        '<name>OriginBuilderType</name>' + '\n' +
        '<value>' + '\n' +
        '<stringValue>LightningFlowBuilder</stringValue>' + '\n' +
        '</value>' + '\n' +
        '</processMetadataValues>' + '\n' +
        '<processType>AutoLaunchedFlow</processType>' + '\n' +
        '<start>' + '\n' +
        '<locationX>50</locationX>' + '\n' +
        '<locationY>50</locationY>' + '\n' +
        '<connector>' + '\n' +
        '<targetReference>Test_Assign</targetReference>' + '\n' +
        '</connector>' + '\n' +
        '</start>' + '\n' +
        '<status>Draft</status>' + '\n' +
        '<variables>' + '\n' +
        '<name>var</name>' + '\n' +
        '<dataType>String</dataType>' + '\n' +
        '<isCollection>false</isCollection>' + '\n' +
        '<isInput>false</isInput>' + '\n' +
        '<isOutput>false</isOutput>' + '\n' +
        '</variables>' + '\n' +
        '</Flow>';

        String escapedFile = '&lt;?xml version="1.0" encoding="UTF-8"?&gt;' +
        '&lt;Flow xmlns="http://soap.sforce.com/2006/04/metadata"&gt;' +
        '&lt;assignments&gt;' +
        '&lt;name&gt;Test_Assign&lt;/name&gt;' +
        '&lt;label&gt;Test Assign&lt;/label&gt;' +
        '&lt;locationX&gt;428&lt;/locationX&gt;' +
        '&lt;locationY&gt;132&lt;/locationY&gt;' +
        '&lt;assignmentItems&gt;' +
        '&lt;assignToReference&gt;var&lt;/assignToReference&gt;' +
        '&lt;operator&gt;Assign&lt;/operator&gt;' +
        '&lt;value&gt;' +
        '&lt;stringValue&gt;A&lt;/stringValue&gt;' +
        '&lt;/value&gt;' +
        '&lt;/assignmentItems&gt;' +
        '&lt;/assignments&gt;' +
        '&lt;interviewLabel&gt;Test Flow&lt;/interviewLabel&gt;' +
        '&lt;label&gt;Test Flow&lt;/label&gt;' +
        '&lt;processMetadataValues&gt;' +
        '&lt;name&gt;BuilderType&lt;/name&gt;' +
        '&lt;value&gt;' +
        '&lt;stringValue&gt;LightningFlowBuilder&lt;/stringValue&gt;' +
        '&lt;/value&gt;' +
        '&lt;/processMetadataValues&gt;' +
        '&lt;processMetadataValues&gt;' +
        '&lt;name&gt;OriginBuilderType&lt;/name&gt;' +
        '&lt;value&gt;' +
        '&lt;stringValue&gt;LightningFlowBuilder&lt;/stringValue&gt;' +
        '&lt;/value&gt;' +
        '&lt;/processMetadataValues&gt;' +
        '&lt;processType&gt;AutoLaunchedFlow&lt;/processType&gt;' +
        '&lt;start&gt;' +
        '&lt;locationX&gt;50&lt;/locationX&gt;' +
        '&lt;locationY&gt;50&lt;/locationY&gt;' +
        '&lt;connector&gt;' +
        '&lt;targetReference&gt;Test_Assign&lt;/targetReference&gt;' +
        '&lt;/connector&gt;' +
        '&lt;/start&gt;' +
        '&lt;status&gt;Draft&lt;/status&gt;' +
        '&lt;variables&gt;' +
        '&lt;name&gt;var&lt;/name&gt;' +
        '&lt;dataType&gt;String&lt;/dataType&gt;' +
        '&lt;isCollection&gt;false&lt;/isCollection&gt;' +
        '&lt;isInput&gt;false&lt;/isInput&gt;' +
        '&lt;isOutput&gt;false&lt;/isOutput&gt;' +
        '&lt;/variables&gt;' +
        '&lt;/Flow&gt;';

        fbc_ExtractMetadataStringFromZipfile.Request testRequest = new fbc_ExtractMetadataStringFromZipfile.Request();

        testRequest.flowMetadataZipFile = zipFile;

        List<fbc_ExtractMetadataStringFromZipfile.Request> testRequestList = new List<fbc_ExtractMetadataStringFromZipfile.Request>();
        testRequestList.add(testRequest);

        List<fbc_ExtractMetadataStringFromZipfile.Result> testResponseList = fbc_ExtractMetadataStringFromZipfile.extract(testRequestList);
        system.debug('RESPONSE - '+testResponseList);

        system.assertEquals(testResponseList[0].extractedFlowMetadata.trim().replaceAll('(\\s+)', ' '), extractedFile.trim().replaceAll('(\\s+)', ' '));
        system.assertEquals(testResponseList[0].escapedFlowMetadata.trim().replaceAll('(\\s+)', ''), escapedFile.trim().replaceAll('(\\s+)', ''));

    }
}
