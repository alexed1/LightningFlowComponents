({
  invoke : function(component, event, helper) {

		var currentUrlString = window.location.href;
    var urlSegments = currentUrlString.split('/');
    var recordid = urlSegments[urlSegments.length - 2];
    	
    component.set("v.recordId", recordid); 

   }
})
