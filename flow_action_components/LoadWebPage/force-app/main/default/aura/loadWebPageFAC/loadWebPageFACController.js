({
	invoke : function(component, event, helper) {
        return new Promise(function(resolve, reject) {

            var args = event.getParam("arguments");
            var callback = args.callback;
           
            var url = component.get("v.url");
            //document.location.href=url;
           
            window.open( url, '_blank' );
 
            resolve();
           
 		});
    }     
})