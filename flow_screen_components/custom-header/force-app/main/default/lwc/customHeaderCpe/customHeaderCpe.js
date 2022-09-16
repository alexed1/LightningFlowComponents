import TickerSymbol from '@salesforce/schema/Account.TickerSymbol';
import { LightningElement, api } from 'lwc';

export default class CustomHeaderCpe extends LightningElement {
    
    @api bannerMargin = 'slds-var-m-top_small slds-var-m-bottom_xx-small';
    @api bannerClass = 'slds-text-color_inverse slds-text-heading_medium';
    //@api bannerLabel = 'Banner Label';
    @api bannerPadding = '0.3rem';
    @api bannerColor = '#4C6E96';   //Brand is #1B5297, decreasing shades: 346096, 4C6E96, 657B96  

    @api
    get bannerStyle() { 
        return 'padding:' + this.bannerPadding + ';background:' + this.bannerColor + ';';
    }

    _builderContext;
    _values;
    hasImage = false;
    isStaticResource = false;
    isLightningIcon = false;
    isNotHorizontalLine = false;
    isTextAURL = false;
    isBold = false;

    inputValues = {
        displayMode: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Display the header as:', helpText:''},
        iconSize: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Lightning Icon Size', helpText:''},
        textAlignment: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Text Alignment', helpText:''},
        headerText: {value: null, placeholderText:'Banner Text Goes Here', valueDataType: null, isCollection: false, label: 'Banner Text', helpText:''},
        isTextAHyperlink: {value: false, placeholderText:null, valueDataType: null, isCollection: false, label: 'Display text as hyperlink?', helpText:'Once selected, be sure to fill out the URL to redirect field with a valid URL'},
        removeTextDecoration: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Remove text-decoration for the link?', helpText:''},
        linkTargetNewWindow: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Open link in new window?', helpText:''},
        orderNumber: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Order Number', helpText:'When using the header multiple times on the same page, make sure that order number has different values for each header so that the styling gets applied accordingly'},
        urlToRedirect: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'URL to redirect', helpText:''},
        imageName: {value: null, placeholderText:'Utility:add', valueDataType: null, isCollection: false, label: 'Image Name', helpText:'Provide lightning icon name like utility:add or image name stored as a static resource (public). Visit https://lightningdesignsystem.com/icons/ for lightning icons.'},
        imageType: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Image Type', helpText:''},
        iconPadding: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Image/Icon Margin', helpText:'Provide margin to include space between icon and text-useful when the icon is left aligned and text follows the icon'},
        staticResourceImageWidth: {value: null, placeholderText:50, valueDataType: null, isCollection: false, label: 'Static Resource Image Width', helpText:''},
        staticResourceImageHeight: {value: null, placeholderText:50, valueDataType: null, isCollection: false, label: 'Static Resource Image Height', helpText:''},
        headerHeight: {value: null, placeholderText:10, valueDataType: null, isCollection: false, label: 'Banner Height (in px)', helpText:''},
        headerBgColor: {value: null, placeholderText:'#ffadad', valueDataType: null, isCollection: false, label: 'Banner Background Color', helpText:'Use any- #hexcode or RGB(0, 0, 0) or color name'},
        headerTxtColor: {value: null, placeholderText:'#000000', valueDataType: null, isCollection: false, label: 'Banner Text Color (#000000)', helpText:''},
        headerTxtFont: {value: null, placeholderText:'Arial', valueDataType: null, isCollection: false, label: 'Banner Text Font Style (provide up to 3 separated by ;)', helpText:''},
        headerTxtSize: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Banner Text Font Size (in px)', helpText:''},
        headerTxtWeight: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Banner Text Font Weight', helpText:''},
        headerBrdrRadius: {value: null, placeholderText:10, valueDataType: null, isCollection: false, label: 'Banner Border Radius (in px)', helpText:''},
        headerBrdr: {value: null, placeholderText:'0px 0px 5px 0px dotted red', valueDataType: null, isCollection: false, label: 'Banner Border', helpText:'include width, style (required) and color, example- 0px 0px 5px 0px dotted red'},
        headerMargin: {value: null, placeholderText:'5px 5px 5px 5px', valueDataType: null, isCollection: false, label: 'Banner Margin', helpText:''},
        headerPadding: {value: null, placeholderText:'5px 5px 5px 5px', valueDataType: null, isCollection: false, label: 'Banner Padding', helpText:''},
        isBold: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Bold', helpText:''},
        isItalicized: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Italicize', helpText:''},
        isUnderlined: {value: null, placeholderText:null, valueDataType: null, isCollection: false, label: 'Underline', helpText:''},

    };

    settings = {
        inputAttributePrefix: 'select_'
    }

    displayChoicesAsOptions = [
        {label: 'Horizontal Line', value: 'horizontalLine'},
        {label: 'Text Only', value: 'textOnly'},
        {label: 'Text (Left) and Image (Right)', value: 'textLeftImageRight'},
        {label: 'Image (Left) and Text (Right)', value: 'ImageLeftTextRight'}
    ];

    sizeOptions = [
        {label: 'xx-small', value: 'xx-small'},
        {label: 'x-small', value: 'x-small'},
        {label: 'small', value: 'small'},
        {label: 'medium', value: 'medium'},
        {label: 'large', value: 'large'}
    ];

    weightOptions = [
        {label: '100', value: '100'},
        {label: '200', value: '200'},
        {label: '300', value: '300'},
        {label: '400', value: '400'},
        {label: '500', value: '500'},
        {label: '600', value: '600'},
        {label: '700', value: '700'},
        {label: '800', value: '800'},
        {label: '900', value: '900'}
    ];



    imageTypeOptions = [
        {label: 'Lightning Icon', value: 'lightningIcon'},
        {label: 'Static Resource', value: 'staticResource'}
    ];
    
    alignmentOptions = [
        {label: 'left', value: 'left'},
        {label: 'center', value: 'center'},
        {label: 'right', value: 'right'}
        
    ];

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    renderedCallback(){
        
        var displayModeValue=this.template.querySelector(".displayModeClass");
        console.log('displayModeValue:'+displayModeValue.value);
        switch (displayModeValue.value) {
                    case "textLeftImageRight":
                    case "ImageLeftTextRight":
                        this.hasImage = true;
                        this.isNotHorizontalLine = true;
                        break;
                    case "horizontalLine":
                        this.isNotHorizontalLine = false;
                        this.hasImage = false;
                        break;
                    case "textOnly":
                        this.isNotHorizontalLine = true;
                        this.hasImage = false;
                        break;
                }
        
        var boldValue = this.template.querySelector("[data-id='isBold']");
        if (boldValue) {
            if(boldValue.checked){
                this.isBold = true;
            }else{
                this.isBold = false;
            }
        }
                /*
                if(this.isNotHorizontalLine){

                const isTextAURLValue = this.template.querySelector("div[data-id='isURLcheckbox']");
                //alert('isTextAURLValue.checked ' + isTextAURLValue.checked + ', isTextAURLValue.value ' + isTextAURLValue.value + ', isTextAURLValue ' + isTextAURLValue);
                this.isTextAURL = isTextAURLValue.checked
                
                if(this.hasImage){

                var isLightningIconValue= this.template.querySelector(".lightningIconClass");
                this.isLightningIcon= isLightningIconValue;
                console.log('isLightningIconValue:'+isLightningIconValue);
                
                var isStaticResourceValue = this.template.querySelector(".staticResourceClass");
                
                this.isStaticResource=isStaticResourceValue;
                console.log('isStaticResource:'+isStaticResourceValue);

                }

                }*/
                
                
    
    }

    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
        }
        //this.setInputMode();
        //this.setChoiceLabels();
    }

    

    handleValueChange(event) {
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
            let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;
            let curAttributeType;
            console.log('curAttributeName:'+curAttributeName);
            console.log('curAttributeValue:'+curAttributeValue);
            console.log('curAttributeType:'+curAttributeType);
            switch (event.target.type) {
                case "checkbox":
                    curAttributeType = 'Boolean';
                    break;
                case "number":
                    curAttributeType = 'Number';
                    break;
                default:
                    curAttributeType = 'String';
            }

            switch (curAttributeName) {
                case "displayMode":
                    console.log('case displayMode');
                    switch (curAttributeValue) {
                        case "textLeftImageRight":
                        case "ImageLeftTextRight":
                            console.log('case textLeftImageRight & ImageLeftTextRight');
                            this.hasImage = true;
                            this.isNotHorizontalLine = true;
                            break;
                        case "horizontalLine":
                            console.log('case horizontalLine');
                            this.isNotHorizontalLine = false;
                            this.hasImage = false;
                            break;
                        case "textOnly":
                            console.log('case horizontalLine');
                            this.isNotHorizontalLine = true;
                            this.hasImage = false;
                            break;
                        default:
                            console.log('case default---');
                            this.isNotHorizontalLine = false;
                            this.hasImage = false;
                    }
                    break;
                case "isBold":
                    console.log('case isBold');
                    if (curAttributeValue) {
                        this.isBold = true;
                    } else {
                        this.isBold = false;
                    }
                    break;
                /*case "imageIsALightningIcon":
                    console.log('case imageIsALightningIcon');
                    this.isLightningIcon = curAttributeValue
                    this.isStaticResource = !curAttributeValue
                    break;
                case "imageIsAStaticResource":
                    console.log('case displayMode');
                    this.isStaticResource = curAttributeValue
                    this.isLightningIcon = !curAttributeValue
                    break;
                case "isTextAHyperlink":
                    console.log('case imageIsAStaticResource');
                    this.isTextAURL = curAttributeValue
                    break;
                */  
            }


            this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }
}