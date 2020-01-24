//cpeTemplate helps build Custom Property Editors for invocable actions. For more information, join the pilot by contacting Salesforce Support
//Pilot Community: https://success.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F93A0000004mtO

import {api, track, LightningElement} from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

    //as a convention, track settings here. This is not required
    settings = {
        stringDataType: 'String',
        referenceDataType: 'reference',
        true: true,
        false: false,
        componentWidth: 320, //provides a default width
       // you can add more:
       //specifyBodyOption: 'specifyBody',
       //useTemplateOption: 'useTemplate',
    };

    //by defining inputValues here, we're able to use generic logic in initializeValues, below
    @track inputValues = {
        // example:
        //replyEmailAddress: {value: null, dataType: null},
        //orgWideEmailAddressId: {value: null, dataType: null},
    };



    //flowContext provides the CPE with the names of the 'upstream' mergefields (aka variables or resources) that
    //will be available when the Flow runs. The CPE needs to make sure that the user can select appropriate mergefields and map them to action inputs
    // Watch out for the danger of confusing flowContext and value. flowContext contains references and not values.  
    @track _flowContext;
    @api get flowContext() {
        return this._flowContext;
    }
    // flowContext is set whenever Flow Builder passes down new data. Treat flowContext as read-only and don't try to modify it yourself
    set flowContext(value) {
        this._flowContext = value;
        console.log('incoming flow context: ========');
        console.log(JSON.stringify(this._flowContext));
        //carry out any necessary conversion of values
        
    }

    //value is where the values of the underlying invocable action parameters are maintained
    //Flow Builder maintains a representation of these values. If you're editing an existing element,
    //FB will read the current values out of the Flow XML and pass them here
    //Keep in mind that when you're going the other way and passing a value change to Flow Builder, you need to dispatch an event
    @track _values;
    @api get values() {
        return this._values;
    }
    set values(value) {
        this._values = value;
        this.initializeValues();
    }

    //anytime Flow Builder provides an updated set of the values it's storing, process them.
    //this generally means setting the value of various components that the user is going to see with the current or default values
    initializeValues() {

        this._values.forEach(curInputParam => {
                if (curInputParam.id && this.inputValues[curInputParam.id]) {
                    this.inputValues[curInputParam.id].value = curInputParam.value;
                    this.inputValues[curInputParam.id].dataType = curInputParam.dataType;
                }
            
        });

        //do additional mapping of input values to existing controls   
        this.isInitialized = true;
    }

    //this function should be called any time something happens in the CPE that results in a change to an action input value
    //syntax for a mergefield: this.dispatchFlowValueChangeEvent(elementName, '{!Get_Contacts}','reference');  
    //syntax for a literal value: this.dispatchFlowValueChangeEvent(elementName, 'LaDeeDa','String' ); 
    dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
        const valueChangedEvent = new CustomEvent('valuechanged', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                id: id,
                newValue: newValue,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    //this utility function takes a value change event fired by a component and updates the inputValues representation
    //it then determines whether the change is a literal or a mergefield and passes appropriate data for dispatch to Flow Builder
    //note that many value changes will require additional processing. this code is useful for straightforward pass throughs such as the changes reported by the FlowCombobox component
    handleFlowValueChange(event) {
        let elementName = event.detail.id;
        if (this.inputValues[elementName]) {
            this.inputValues[elementName].value = event.detail.newValue;
            this.inputValues[elementName].dataType = event.detail.newValueDataType;
            let formattedValue = (event.detail.newValueDataType === this.settings.stringDataType || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
            this.dispatchFlowValueChangeEvent(elementName, formattedValue, event.detail.newValueDataType);
        }
    }

    //this utility function works with the optional componentWidth setting (see the settings definition, above)
    get inputStyle() {
        if (this.settings.componentWidth) {
            return 'max-width: ' + this.settings.componentWidth + 'px';
        }
    }

    //called at save-time
    @api validate() {
        const validity = [];
        if (!this.isSomethingTrue(this.foo)) {
            validity.push({ key: 'myMessage', errorString: 'The foo address you enter is invalid.' });
        }
        return validity;
    }
        

}