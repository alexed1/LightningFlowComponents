import {api, track, LightningElement } from 'lwc';

export default class FlexcardCPE extends LightningElement {
    _builderContext;
    _values;

    @track inputValues = {
        value: {value: null, valueDataType: null, isCollection: false, label: 'The selected cards recordId if Allow Multi-Select is set to false'},
        icon: {value: null, valueDataType: null, isCollection: false, label: 'Icon name for example standard:account'},
        records: {value: null, valueDataType: null, isCollection: true, label: 'Record Collection variable containing the records to display in the flexcard.'},
        visibleFieldNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which fields?'},
        visibleFlowNames: {value: null, valueDataType: null, isCollection: false, label: 'Show which flow?'},
        cardSize: {value: null, valueDataType: null, isCollection: false, label: 'The size of the box in pixels. The box is a square.'},
        isClickable: {value: null, valueDataType: null, isCollection: false, label: 'Set as true if you wish to select individual cards for action further downstream in flow default is false'},
        headerStyle: {value: null, valueDataType: null, isCollection: false, label: 'Add your own style attribute to the card headers ie. background-color:red;'},
        allowMultiSelect: {value: null, valueDataType: null, isCollection: false, label: 'Allow for multiselect of cards when enabled checkboxes appear on cards and adds selected cards to collection'},
        objectAPIName: {value: null, valueDataType: null, isCollection: false, label: 'The SObject API Name used to query fields and values must be the same object selected in Flexcard Object API Name'},
        label: {value: null, valueDataType: null, isCollection: false, label: 'Enter a label for you component'},
        transitionOnClick: {value: null, valueDataType: null, isCollection: false, label: 'If marked as true will transition flow to next screen on card click'},
        
        };

}