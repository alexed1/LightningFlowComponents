public with sharing class CreateOrEditListView {
  

        @InvocableMethod(label='Create or Edit ListView')
        public static List<Response> execute (List<Request> requests) {
            System.debug('entering Create or Edit ListView');
            List<Response> responseWrapper = new List<Response>();
            
            for (Request curRequest : requests) {
    
                //Create a Results object to hold the return values
                Response response = new Response();

                MetadataService.MetadataPort service = MetadataServiceExamples.createService();		
                MetadataService.ListView listView = new MetadataService.ListView();
                listView.fullName = curRequest.objectName + '.' + curRequest.apiName;
                listView.label = curRequest.label;
                listView.filterScope = curRequest.filterScope != null ? curRequest.filterScope : 'Everything';
    
                listView.columns = generateColumnList(curRequest.objectName,curRequest.columnNameCSV);
                
                System.debug ('columns are: '+ listView.columns);
                List<MetadataService.SaveResult> results = 		
                    service.createMetadata(
                        new MetadataService.Metadata[] { listView });		
                try {
                    MetadataServiceExamples.handleSaveResults(results[0]);
                } catch (Exception e) {
                    response.errors = e.getMessage();
                }
                //if things don't work out, an exception will be thrown and the flow will be stopped. 
                //so if we get this far, we know things have worked out. There's no need for 'success' here, but the invocable action requires at least one output, so this is basically a dummy
                response.success = 'true';
            
                //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
                responseWrapper.add(response);
    
            }  
            return responseWrapper; 
            
        }

       /*  This is what a ListView looks like when you retrieve its metadata in XML:
       
       <ListView xmlns="http://soap.sforce.com/2006/04/metadata">
            <fullName>listmanual</fullName>
            <columns>ACCOUNT.NAME</columns>
            <columns>ACCOUNT.SITE</columns>
            <columns>ACCOUNT.ADDRESS1_STATE</columns>
            <columns>ACCOUNT.PHONE1</columns>
            <columns>ACCOUNT.TYPE</columns>
            <columns>CORE.USERS.ALIAS</columns>
            <filterScope>Mine</filterScope>
            <label>listmanual</label>
        </ListView> 
        
        There's one in this project in the 'objects' folder. 
        
        Both the capitalization and the full definition of the object name appear required. 
        
        Note that there are some concerns about how the column names appear to be underlying low level table names and not the api names. That's going to make it harder
        to figure out what to put into the metadata. 
        
        */

    
        public static List<String> generateColumnList(String objectName, String columnNameCSV) {
            List<String> initialColumns = columnNameCSV.split(',');
            List<String> finalColumns = new List<String>();
            String curColumnName;
            for (String column : initialColumns) {
                curColumnName = objectName.toUpperCase() + '.' + column.toUpperCase();
                finalColumns.add(curColumnName);
            }
            return finalColumns;
        }


        public class Request {
            @InvocableVariable
            public String listViewId;
    
            @InvocableVariable(required=true)
            public String objectName;

            @InvocableVariable 
            public String label;
    
            @InvocableVariable 
            public String apiName;

            @InvocableVariable 
            public String filterScope;

            @InvocableVariable 
            public String columnNameCSV;

 
        }
    
        public class Response {
           @InvocableVariable
           public String errors;
    
           
    
        
        }
    
        
    
        class InvocableActionException extends Exception {}
    }