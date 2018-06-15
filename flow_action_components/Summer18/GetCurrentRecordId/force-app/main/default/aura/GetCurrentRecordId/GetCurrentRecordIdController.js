({
  invoke : function(component, event, helper) {
	var args = event.getParam("arguments");
		 

	var currentUrlString = window.location.href;
	console.log("currentURL is: "+ currentUrlString);

    	var urlSegments = currentUrlString.split('/');
    	var recordid = urlSegments[urlSegments.length - 2];
	console.log("recordid is " + recordid);
    	
      	component.set("v.recordId", recordid);
	       

   }
})
