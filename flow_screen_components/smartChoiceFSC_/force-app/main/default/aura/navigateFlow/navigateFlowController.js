({
    invoke: function (component, event, helper) {
        var navService = component.find('navService');
        var recordId = component.get('v.recordId');
        var objectName = component.get('v.sObject');
        var mode = component.get('v.mode').toLowerCase();
        var destinationType = component.get('v.destinationType');

        switch (destinationType) {
            case 'Record' :
                // Open the Record page in View mode first so that it persists after the Edit Modal closes
                var pageReference = {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: recordId,
                        objectApiName: objectName,
                        actionName: 'view'
                    }
                }
                navService.navigate(pageReference);   

                if (mode == 'edit') {
                    var pageReference = {
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: recordId,
                            objectApiName: objectName,
                            actionName: mode
                        }
                    }
                    navService.navigate(pageReference);
                }

                break;
            case 'List' :
                console.log('entering list section');
                console.log('objectName is: ' + objectName);
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: objectName,
                        actionName: 'list'
                    }
                }
                navService.navigate(pageReference);   

            break;
         default:
            throw new Error("Unsupported or missing destination Type. Currently this component supports Record and List");
        
         } 
     }       
})