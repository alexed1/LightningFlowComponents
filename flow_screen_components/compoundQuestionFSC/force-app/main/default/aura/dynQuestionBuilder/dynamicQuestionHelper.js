({
	initRadioOptions:  function(cmp,evt,helper){
        //initialize the options for any radio button groups
        //the options are passed in in a single string from flow, in this format:
        //  "I'm the first string label":"firststringvalue","I'm the secondstringlabel:secondstringvalue"
           
        var childRadioControlList = cmp.get('v.availableChildRadioControls');
        
        childRadioControlList.forEach(function(element){
            var output = [];
            var inputStringAttributeName = element + "_optionsInputString";  
            var curInputString = cmp.get("v.childRadio1_optionsInputString");
   
     		var result = curInputString.split(',').forEach(function(element) {
                var option = [];
                var kvp = element.split(':');
                option['label']=kvp[0].replace('"','').slice(0,-1); //this string parsing is horrible and should be replaced
                option['value']=kvp[1].replace('"','').slice(0,-1); //this string parsing is horrible
                console.log(option);
                output.push(option);
                console.log(option.length);
        	})
            var radioControlOptionsAttributeName = element + "_options";  
            cmp.set(radioControlOptionsAttributeName, output  );
    	});
        
    },
    
    initChildControls : function(cmp,evt,helper){
        var self = this; //because "this" changes
        //get the string of children
        //split it into a list
        //for each child, inject a component
        var componentList = cmp.get("v.childComponentList").split(" ");
        componentList.forEach(function(element) {   
            self.createControl(cmp, element);
        })
         
    },
    
    //crazyass dynamic injection to achieve custom ordering of the elements
    createControl : function(cmp,element,helper) {
        this.lookupName(cmp,element);
        var childName = cmp.get("v.curName");
        console.log("in createControl. curName is:" + childName);
        $A.createComponent(
            "c:childControl",
            {"nowVisible": cmp.get("v." + childName + "_nowVisible"),
             "options": cmp.get("v." + childName + "_options"),
             "label": cmp.get("v." + childName + "_label"),
             "controlType": cmp.get("v." + childName + "_controlType"),
             "name": childName,
             "saveStuff" : cmp.getReference("c.saveStuff")
  			 },
            
            function(newCmp) {
                if(cmp.isValid()){
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);
                }
            });
    },
    
    lookupName : function(cmp, element){ 
        var radio1Array = ["r1", "radio1", "childRadio1"];
        var radio2Array = ["r2", "radio2", "childRadio2"];
        var checkbox1Array = ["c1", "cb1", "checkbox1", "childCheckbox1"];
        if (radio1Array.includes(element))
            cmp.set("v.curName", "childRadio1");
        if (radio2Array.includes(element))
            cmp.set("v.curName", "childRadio2");
        if (checkbox1Array.includes(element))
            cmp.set("v.curName", "childCheckbox1");
        
    },
    
    updateStorage:  function(cmp,clickedControl){
        console.log("entering updateStorage");
         //we assemble the name of the storage attribute that we'll use to publish the value to the flow
         var attributeName = "v." + clickedControl.get("v.name")+ "_storage";
        console.log("storing into attribute:" + attributeName);
         cmp.set(attributeName, clickedControl.get("v.value"));
        console.log("just stored value: " + clickedControl.get("v.value"));
    },
    
    quickUpdate: function(cmp, value){
        
    }
   
})