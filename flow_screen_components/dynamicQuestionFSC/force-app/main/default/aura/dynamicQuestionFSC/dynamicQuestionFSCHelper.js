({
    
    //REFACTOR these two functions should be combined, and should use a promise instead of a janky global
	initRadioOptions:  function(cmp,evt,helper){
        //initialize the options for any radio button groups
        //the options are passed in in a single string from flow, in this format:
        //  "I'm the first string label":"firststringvalue","I'm the secondstringlabel:secondstringvalue"
           
        var childRadioControlList = cmp.get('v.availableChildRadioControls');
        var self = this; //because "this" is unreliable 
        childRadioControlList.forEach(function(element){
            var inputStringAttributeName = element + "_optionsInputString";  
            var curInputString = cmp.get(inputStringAttributeName);
            if(curInputString) {
                self.parseInputString(cmp, element, curInputString);
            }
            var output = cmp.get("v.output");
            var radioControlOptionsAttributeName = element + "_options";  
            cmp.set(radioControlOptionsAttributeName, output  );
            }	
    	); 
    },
    
    initListboxOptions:  function(cmp,evt,helper){
        //initialize the options for any drop down list box child controls
        //the options are passed in in a single string from flow, in this format:
        //  "I'm the first string label":"firststringvalue","I'm the secondstringlabel:secondstringvalue"
        var self = this; //because "this" is unreliable   
        var childListboxList = cmp.get('v.availableChildListboxControls');
        
        childListboxList.forEach(function(element){
            var inputStringAttributeName = element + "_optionsInputString";  
            var curInputString = cmp.get(inputStringAttributeName);
            if(curInputString) {
    			self.parseInputString(cmp, element, curInputString);
        		};
            var output = cmp.get("v.output");
            var listboxOptionsAttributeName = element + "_options";  
            cmp.set(listboxOptionsAttributeName, output  );
           
            }
     		
    	);
        
    },
    
    //parses the input string passed in from the flow to the form expected by the lightning controls
    //  "I'm the first string label":"firststringvalue","I'm the secondstringlabel:secondstringvalue"
    parseInputString : function(cmp, element, curInputString) {
        var optionList = [];
        
        curInputString.split(',').forEach(function(element) {
            var curOption = []; //if you don't reset it like this, it ends up holding references and they keep adjusting so only the final value is set in all of the slots
            var kvp = element.split(':');
            curOption['label']=kvp[0].replace('"','').slice(0,-1); //this string parsing is horrible and should be replaced
            curOption['value']=kvp[1].replace('"','').slice(0,-1); //this string parsing is horrible
            optionList.push(curOption);
        });
        cmp.set("v.output", optionList);                               
                                          
    },
    
    //create a child control for each control specified in the flow config
    initChildControls : function(cmp,evt,helper){
        var self = this; //because "this" changes
        var curArray = [];
        
        curArray = cmp.get("v.childComponentsArrayLinkedToYes");
        curArray.forEach(function(element) {   
            self.createControl(cmp, element, "yes", helper);
        });
        curArray = cmp.get("v.childComponentsArrayLinkedToNo");
        curArray.forEach(function(element) {   
            self.createControl(cmp, element, "no", helper);
        });      
              
    },
    
    //dynamic injection is code efficient, encourages encapsulation, and allows custom ordering of the elements
    createControl : function(cmp,element,conditionalRelationship, helper) {
        var self = helper;

        this.lookupName(cmp,element);
        var childName = cmp.get("v.curName");

        //first set the conditionalRelationship on the parent       
        var conditionalRelationshipAttributeName = "v." + childName + '_conditionalRelationship';
        cmp.set(conditionalRelationshipAttributeName, conditionalRelationship);

        var optionParam = "";
        //only set an options parameter if the control has an options attribute
        //if name stripped of the final char
        if ((childName.slice(0,-1) == "childListbox") || (childName.slice(0,-1) == "childRadio")) {
            optionParam = cmp.get("v." + childName + "_options");
        }

        //at design time, user can specify a default value for a field. They can specify either text or a merge field (which gets resolved before it gets here)
        var defaultValue="";
        var requestedDefaultValue = cmp.get("v." + childName + "_defaultValue");
        if (requestedDefaultValue != null) {
            defaultValue = requestedDefaultValue;
        }

        //set initial visibility, which depends on the presence of a default value for the parent
        //if the current parent value matches the conditional relationship passed in from the flow, show this child control
        var parentValue = cmp.get('v.parentQuestion_value');       
        if ((parentValue == "yes" && conditionalRelationship == 'yes') ||
            (parentValue == "no" && conditionalRelationship == 'no') ) {                
                cmp.set("v." + childName + "_nowVisible", "true");
                
        } else {
                cmp.set("v." + childName + "_nowVisible", "false");
        };


        
        //then create the child component     
        $A.createComponent(
            "c:DynamicQuestionChild",
            {"nowVisible": cmp.get("v." + childName + "_nowVisible"),
             "options": optionParam,
             "label": cmp.get("v." + childName + "_label"),
             "controlType": cmp.get("v." + childName + "_controlType"),
             "name": childName,
             "parentLabel" : cmp.get("v.parentQuestionLabel"),
             "value" : defaultValue
  			 },
            
            function(newCmp) {
                if(cmp.isValid()){
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);

                }
            });
    },
    
    //this allows the a few variations on how they want to specify child controls in the flow.
    lookupName : function(cmp, element){ 
        var radio1Array = ["r1", "rb1", "radio1", "childRadio1"];
        var radio2Array = ["r2", "rb2","radio2", "childRadio2"];
        var radio3Array = ["r3", "rb3","radio3", "childRadio3"];
        var radio4Array = ["r4", "rb4","radio4", "childRadio4"];
        var checkbox1Array = ["c1", "cb1", "checkbox1", "childCheckbox1"];
        var checkbox2Array = ["c2", "cb2", "checkbox2", "childCheckbox2"];
        var checkbox3Array = ["c3", "cb3", "checkbox3", "childCheckbox3"];
        var checkbox4Array = ["c4", "cb4", "checkbox4", "childCheckbox4"];
		var textField1Array = ["tf1", "tF1", "textField1", "childTextField1"];
        var textField2Array = ["tf2", "tF2", "textField2", "childTextField2"];
        var textField3Array = ["tf3", "tF3", "textField3", "childTextField3"];
        var textField4Array = ["tf4", "tF4", "textField4", "childTextField4"]; 
        var listBox1Array = ["lb1", "lB1", "listBox1", "childListbox1"];
        var listBox2Array = ["lb2", "lB2", "listBox2", "childListbox2"];
        var listBox3Array = ["lb3", "lB3", "listBox3", "childListbox3"];
        var listBox4Array = ["lb4", "lB4", "listBox4", "childListbox4"];
        
        if (radio1Array.includes(element))
            cmp.set("v.curName", "childRadio1");
        if (radio2Array.includes(element))
            cmp.set("v.curName", "childRadio2");
        if (radio3Array.includes(element))
            cmp.set("v.curName", "childRadio3");
        if (radio4Array.includes(element))
            cmp.set("v.curName", "childRadio4");
        if (checkbox1Array.includes(element))
            cmp.set("v.curName", "childCheckbox1");
        if (checkbox2Array.includes(element))
            cmp.set("v.curName", "childCheckbox2");
        if (checkbox3Array.includes(element))
            cmp.set("v.curName", "childCheckbox3");
        if (checkbox4Array.includes(element))
            cmp.set("v.curName", "childCheckbox4");
        if (textField1Array.includes(element))
            cmp.set("v.curName", "childTextField1");
        if (textField2Array.includes(element))
            cmp.set("v.curName", "childTextField2");
        if (textField3Array.includes(element))
            cmp.set("v.curName", "childTextField3");
        if (textField4Array.includes(element))
            cmp.set("v.curName", "childTextField4");
        if (listBox1Array.includes(element))
            cmp.set("v.curName", "childListbox1");
        if (listBox2Array.includes(element))
            cmp.set("v.curName", "childListbox2");
        if (listBox3Array.includes(element))
            cmp.set("v.curName", "childListbox3");
        if (listBox4Array.includes(element))
            cmp.set("v.curName", "childListbox4");
    },
    
    
    updateStorage:  function(cmp,clickedControl){
         //we assemble the name of the storage attribute that we'll use to publish the value to the flow
         var attributeName = "v." + clickedControl.get("v.name")+ "_storage";
         cmp.set(attributeName, clickedControl.get("v.value"));
    },

    //this is called when the parent radio buttons are clicked and also at init time
    updateChildControls: function(cmp, helper) {
        var self=helper;


        
        var childControlsList = cmp.get('v.childComponentsArrayLinkedToYes')
            .concat(cmp.get('v.childComponentsArrayLinkedToNo'));
        
        //reset the visibility counter that is used to determine whether to render the card style
        cmp.set("v.visibleCount", 0);

        childControlsList.forEach(function(element) {
            self.updateControlState(cmp,element,helper);         
        });  
    },

    updateControlState : function(cmp, element, helper) {
        //find out whether this child control should show on a Yes or a No
            var self=helper;
            self.lookupName(cmp,element);
            var parentValue = cmp.get('v.parentQuestion_value');
            var childName = cmp.get("v.curName");
            var statusAttributeName = 'v.' + childName + '_conditionalRelationship';
            var conditionalRelationship = cmp.get(statusAttributeName).toLowerCase();
            
            //if the current parent value matches the conditional relationship passed in from the flow, show this child control
            var curVisibility = "";         
            if ((parentValue == "yes" && conditionalRelationship == 'yes') ||
                (parentValue == "no" && conditionalRelationship == 'no') ) {                
                    curVisibility = "true";
                    cmp.set("v.visibleCount", cmp.get("v.visibleCount") + 1 );
                    
            } else {
                    curVisibility = "false";
            };
           
            
            //if the visibility has changed (cur vis != old vis) fire an event to notify this child control
            //REFACTOR: probably should gather up all the changes and fire a single event that can be read by all child controls
            var childComponentVisibilityAttributeName = 'v.' + childName  + '_nowVisible';
            if (cmp.get(childComponentVisibilityAttributeName).toString() != curVisibility){
                var updateEvent = $A.get("e.c:ChildControlVisibilityUpdateEvent");
                updateEvent.setParams({"childControlName" : childComponentVisibilityAttributeName});
                updateEvent.setParams({"childControlVisibilityChanged" : true});
                updateEvent.setParams({"parentLabel" : cmp.get("v.parentQuestionLabel")});
                updateEvent.fire();
            };
            
            //persist the visibility status of the child component for the next time this method gets called
            cmp.set(childComponentVisibilityAttributeName, curVisibility);
    }
   
})