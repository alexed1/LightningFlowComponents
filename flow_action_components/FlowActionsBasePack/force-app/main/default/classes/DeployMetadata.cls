global with sharing class DeployMetadata {
    final static String ACTIVATE_STATUS = 'Activate';
    final static String DEACTIVATE_STATUS = 'Deactivate';
    final static String LEAVE_ONE_PICLIST_VALUE_MESSAGE = 'Please, leave at least one active value';
    @AuraEnabled 
    global static String deploy(String metadataText, String metadataName, String testLevel, String objectType) {
        System.debug('entering deploy. metadata text, objectname, testlevel, and object type are:' );
       // System.debug ('metadataText: ' + metadataText);
        System.debug ('objectName: ' + metadataName);
        System.debug ('testLevel: ' + testLevel);
        System.debug ('objectType: ' + objectType);
        MetadataService.MetadataPort service = createService();
        if (String.isEmpty(testLevel))
            testLevel = 'NoTestRun';

        String zippedClass = generateZipfile(metadataText, metadataName, objectType);
        MetadataService.AsyncResult deployResult= service.deploy(zippedClass, getDeployOptions());

        String jobId = deployResult.id;
        MetadataService.DeployResult result = service.checkDeployStatus(jobId,true);
        System.debug('deploy status is: ' + metadataName + ' ' + result.status + ' ' + result.stateDetail); 
        return jobId;
    }

    @auraEnabled
	global static String checkAsyncRequest(String jobId) {
        System.debug('entering checkAsyncRequest, job id: ' + jobId);
		// Check the status of the retrieve request
		MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(jobId, true);
        System.debug('returned from checkDeployStatus call to metadata service. deploy result is: ' + deployResult);
		if(deployResult.done)
		{
			// Errors?
			if(deployResult.status != 'Succeeded')
			{   
                System.debug ('status is: ' + deployResult.status);
                System.debug ('error is: ' + deployResult.errorMessage);
                String problems = '';
                System.debug('deploy result:' + deployResult.details.componentFailures);
                System.debug('deploy success:' + deployResult.details.componentSuccesses);
                for(MetadataService.DeployMessage curMessage : deployResult.details.componentFailures) {
                    problems = problems + '\n' + curMessage.problem;
                }
                System.debug('problem is: ' + problems);
			    return problems;				
			}
			else
			{
                System.debug('deploy succeeded');
			 
                return 'success';
			}
		}
		else return 'inprocess';
	}

    global static void deployPickListValues(String apiName, Map<String, String> selectedPicklistValueMap, String picklistAction) {
        MetadataService.MetadataPort service = createService();   
        MetadataService.CustomField customField = (MetadataService.CustomField) service.readMetadata('CustomField', new String[] { apiName}).getRecords()[0];
        Integer activeValuesSize = 0;

        if(String.isNotEmpty(picklistAction)) {
            for(MetadataService.CustomValue objCustomValue : customField.valueSet.valueSetDefinition.value){
                if(selectedPicklistValueMap.containsKey(objCustomValue.fullName)) {
                    objCustomValue.isActive = picklistAction == ACTIVATE_STATUS ? true : false;
                }

                if(objCustomValue.isActive==null || objCustomValue.isActive) {
                    activeValuesSize++;
                }
            }
        }

        //check active values size
        if(activeValuesSize == 0) {
            throw new CustomException(LEAVE_ONE_PICLIST_VALUE_MESSAGE);
        }

        // Update picklist values
        List<MetadataService.SaveResult> lstResults = service.updateMetadata( new MetadataService.Metadata[] { customField });

        for (MetadataService.SaveResult objResult : lstResults) {
            if (!objResult.success && objResult.errors.size() > 0) {
                throw new CustomException('eror : ' + objResult.errors[0].message);
            }
        }
    }

    global static String generateZipfile(String classText, String objectName, String objectType) {
            Zippex sampleZip = new Zippex();
            System.debug('assembling package with objectName: ' + objectName);
            Blob fileData = Blob.valueOf(getPackageXml(objectName, objectType));
            System.debug('preparing to deploy package.xml: ' + fileData.toString());
            sampleZip.addFile('package.xml', fileData, null);
           // fileData = Blob.valueOf(getObjectMetadata(objectType));
           // System.debug('preparing to deploy meta file: ' + fileData.toString());
           // sampleZip.addFile(  'flows/' + objectName + '.flow-meta.xml', fileData, null);
            fileData = Blob.valueOf(classText);
            System.debug('preparing to deploy object file: ' + fileData.toString());
            sampleZip.addFile( 'flows/' + objectName +'.flow', fileData, null);
            return EncodingUtil.base64Encode(sampleZip.getZipArchive());

        }
    global static MetadataService.DeployOptions getDeployOptions(){
             
        MetadataService.DeployOptions curDeployOption = new MetadataService.DeployOptions();
        curDeployOption.allowMissingFiles = false;
        curDeployOption.autoUpdatePackage = true;
        curDeployOption.checkOnly = false;
        curDeployOption.ignoreWarnings = true;
        curDeployOption.performRetrieve = false;
        curDeployOption.purgeOnDelete = false;
        curDeployOption.rollbackOnError = true;
        curDeployOption.runTests = new String[]{};
        curDeployOption.singlePackage = true;
        curDeployOption.testLevel = 'NoTestRun';
           
        return curDeployOption;
        }

        private static MetadataService.MetadataPort createService()
        { 
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            return service;		
        }	

        global static String getPackageXml(String className, String objectType)
        {
            return '<?xml version=\"1.0\" encoding=\"UTF-8\"?>' + 
                '<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">' + 
                    '<types>' + 
                        '<members>' + className + '</members>' +
                        '<name>' + objectType +'</name>' + 
                    '</types>' + 
                    '<version>48.0</version>' + 
                '</Package>';		
        }
    
        global static String getObjectMetadata(String objectName)
        {
            String boilerplate =  '<?xml version="1.0" encoding="UTF-8"?>' +
            '<Flow xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>48.0</apiVersion>' + 
                '<status>Active</status>' +
            '</Flow>';

            boilerplate = boilerplate.replace('ObjectName', objectName);
            return boilerplate;
	
        }

        class  CustomException extends Exception {
            
        } 

        
            

}
