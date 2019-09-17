({
    invoke : function(component, event, helper) {
        return new Promise(function(resolve, reject) {        
            
            var url = component.get("v.url");
            var mode = component.get("v.mode");
            var target = '_blank';
            var features = '';
            
            switch (mode) {
                case 'replace':
                    target = '_self';
                    break;
                case 'newWindow':
                    features = features + 'height=100';
                    break;
                default:
                    break;
            }
    
            window.open( url, target, features );
            resolve();
               
        });
    }
})