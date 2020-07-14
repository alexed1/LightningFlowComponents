/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * This example demonstrates how to utilise the Metadata API Retrieve operation inconjunction with the JSZip JavaScript library
 **/
public  with sharing class RetrieveMetadata 
{
	private static final Integer METADATA_API_VERSION = 48;

	public static List<SelectOption> MetaDataTypes {get; set;}
	public static String MetaDataType {get; set;}		
	public static List<SelectOption> MetaDataItems {get; set;}
	public static String MetaDataFolder {get; set;} 
	public static String MetaDataItem {get; set;}	
	public static String MetadataFileName {get; set;}
	public static String MetadataFileData {get; set;}
	public static MetadataService.AsyncResult AsyncResult {get; private set;}
	public static String MetaDataRetrieveZip { get; private set; }	
	public static List<MetadataFile> MetadataFiles { get; set; }		
	
    
/*     
    // Retrieve Custom Object Meta data for Source Object
RetrieveRequest retrieveRequest = new RetrieveRequest();
retrieveRequest.setSinglePackage(true);
com.sforce.soap.metadata.Package packageManifest = new com.sforce.soap.metadata.Package();
ArrayList<PackageTypeMembers> types = new ArrayList<PackageTypeMembers>();
PackageTypeMembers packageTypeMember = new PackageTypeMembers();
packageTypeMember.setName("CustomObject");
packageTypeMember.setMembers(new String[] { sourceObject });
types.add(packageTypeMember);
packageManifest.setTypes((PackageTypeMembers[]) types.toArray(new PackageTypeMembers[] {}));
retrieveRequest.setUnpackaged(packageManifest);
AsyncResult response = metadataConnection.retrieve(retrieveRequest);
while(!response.isDone())
{
    Thread.sleep(1000);
    response = metadataConnection.checkStatus(new String[] { response.getId()} )[0];
}
RetrieveResult retrieveResult = metadataConnection.checkRetrieveStatus(response.getId()); */

    
    @auraEnabled
	public static String retrieveMetadataItem(String metadataName)
	{		
        
	   System.debug('entering retrieveMetadataItem with metadataName: ' + metadataName);




        
		// Reset state from any previous requests
		MetaDataRetrieveZip = null;
		MetadataFiles = null;
		 
		// Construct unmanaged package with list of desired components to retrieve in zip
		MetadataService.MetadataPort service = createService();				
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();

      
		retrieveRequest.apiVersion = METADATA_API_VERSION;
		retrieveRequest.packageNames = null;
		retrieveRequest.singlePackage = true;
		retrieveRequest.specificFiles = null;
		retrieveRequest.unpackaged = new MetadataService.Package_x();
		retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
        
        //Flow-specific code
		packageType.name = 'Flow'; 
		packageType.members = new String[] { metadataName };
        retrieveRequest.unpackaged.types.add(packageType);
        System.debug('retrieve request is: ' + retrieveRequest);
 
        

        MetadataService.AsyncResult curAsyncResult = service.retrieve(retrieveRequest);
        

        String jobId = curAsyncResult.id;
        MetadataService.RetrieveResult result = service.checkRetrieveStatus(jobId,true);
        System.debug('retrieve status is: done=' +  ' ' + result.done + ' status: ' + result.status + ' success: '+ result.success); 
        System.debug('zip file is: ' + result.zipfile);
						
		return jobId;	
    }
    
	@auraEnabled
	public static String checkAsyncRequest(String jobId) {
        System.debug('entering checkAsyncRequest, job id: ' + jobId);
		// Check the status of the retrieve request
		MetadataService.MetadataPort service = createService();
		MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(jobId, true);
		if(retrieveResult.done == true)
		{
			// Errors?
			if(retrieveResult.status != 'Succeeded')
			{
			    return JSON.serialize(retrieveResult);			
			}
			else
			{
				MetaDataRetrieveZip = retrieveResult.zipFile;
				MetadataFiles = new List<MetadataFile>();
                AsyncResult = null;
                return retrieveResult.zipFile;
			}
		}
		else {
			System.debug ('not done retrieving');
			return 'inprocess';
		}
		 
	}
	

	@AuraEnabled(cacheable=true)
	public static string getFileNames(String zipfile){
		System.debug ('entering getFileNames');
        if (zipfile != '') {
			Blob zipBlob = EncodingUtil.base64Decode(zipfile);
			Zippex curZippex = new Zippex(zipBlob);
			Set<String> fileNames = curZippex.getFileNames();
			System.debug('filenames are: ' + fileNames);
		 
			List<String> filenamesList = new List<String>(fileNames);
			return 'foo';
			//return filenamesList.toString();
		}
		else return 'nothing yet...';
		

		
	}

	
	private static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
    }	
    
    public static String getPackageXml(String flowName)
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' + 
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
                '<types>' + 
                    '<members>' + flowName + '</members>' +
                    '<name>Flow</name>' + 
                '</types>' + 
                '<version>48.0</version>' + 
            '</Package>';		
    }
	
	/**
	 * Simple container class for retrieve metadata file, may as well leverage the Metadata API class for this
	 **/
	public class MetadataFile extends MetadataService.MetadataWithContent
	{
		public String getFullname()
		{
			return fullName;
		}
		
		public String getContent()
		{
			return content;
		}
	}
}