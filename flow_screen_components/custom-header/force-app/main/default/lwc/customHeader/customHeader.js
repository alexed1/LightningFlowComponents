import { LightningElement,api } from 'lwc';
import staticResourceReference from '@salesforce/resourceUrl/customHeaderImages';

export default class CustomHeader extends LightningElement {
    //---recordId- used when the component is placed on a record page
    @api recordId;
    @api displayForRecordId;
    
    //---When using the component more than once on the same screen, OrderNumber helps distinguish the components
    @api orderNumber;

    //----display Mode
    @api displayMode;
    @api displayAsHorizontalLine = false;
    @api isTextOnly = false;
    @api isTextLeftImageRight = false;
    @api isTextAndImageOnLeftOfText = false;

    
    //----Banner styling
    @api textAlignment;
    @api headerHeight;
    @api headerBgColor; 
    @api headerTxtColor; 
    @api headerTxtFont; 
    @api headerTxtSize; 
    @api headerBrdrRadius; 
    @api headerBrdr;
    @api headerMargin;
    @api headerPadding;
    @api isBold = false;
    @api isItalicized = false;
    @api isUnderlined = false;
    
    @api imageName;
    @api iconPadding;
    @api iconSize;
    @api isTextAHyperlink = false;
    @api linkTargetNewWindow = false;
    @api removeTextDecoration = false;
    @api urlToRedirect;
    @api imageType = '';
    @api imageIsALightningIcon = false;
    @api imageIsAStaticResource = false;
    @api staticResourceImageHeight;
    @api staticResourceImageWidth;

    @api headerText;

    displayChoicesAsOptions = [
        {label: 'Horizontal Line', value: 'horizontalLine'},
        {label: 'Text Only', value: 'textOnly'},
        {label: 'Text (Left) and Image (Right)', value: 'textLeftImageRight'},
        {label: 'Image (Left) and Text (Right)', value: 'ImageLeftTextRight'}
    ];

    linkTarget ='_self';
    showHeader = false;
    showLightningIcon = false;
    staticResourceUrl;

    stylesheet = ".customHeaderCSS"+this.orderNumber+" {}";
    linkCSS = "";
    iconCSS = ".iconCSS {}";
    customHeaderCSSName = "customHeaderCSS"+this.orderNumber;
    
    connectedCallback(){
        console.log('in connectedCallback');
        console.log('this.headerText '+this.headerText);
        console.log('this.headerBgColor '+this.headerBgColor);
        console.log('this.headerHeight '+this.headerHeight);
        console.log('this.headerMargin '+this.headerMargin);
        console.log('this.headerBrdrRadius '+this.headerBrdrRadius);
        console.log('this.headerBrdr '+this.headerBrdr);
        console.log('this.headerPadding '+this.headerPadding);
        console.log('this.textAlignment '+this.textAlignment);
        console.log('this.headerTxtColor '+this.headerTxtColor);
        console.log('this.headerTxtFont '+this.headerTxtFont);
        console.log('this.headerTxtSize '+this.headerTxtSize);
             
        this.customHeaderCSSName = "customHeaderCSS"+this.orderNumber;
        this.setDisplayMode(this.displayMode);
        console.log('displayAsHorizontalLine-2 :'+this.displayAsHorizontalLine);
          console.log('isTextOnly-2 :'+this.isTextOnly);
          console.log('isImageLeftTextRight-2 :'+this.isImageLeftTextRight);
          console.log('isTextLeftImageRight-2 :'+this.isTextLeftImageRight);
        if(this.displayAsHorizontalLine){
            this.showHeader = false;
        }else{
            

            //logic to show for a selected record when using on a record page
            if(this.displayForRecordId != null){
                console.log('recordId:'+this.recordId);
                console.log('displayForRecordId:'+this.displayForRecordId);
                if(this.recordId == this.displayForRecordId){
                    this.showHeader = true;
                }else{
                    this.showHeader = false;
                }

            }else{
                this.showHeader = true;
            }
           
            
        }

        this.stylesheet = "."+this.customHeaderCSSName+" {";

        if(this.headerBgColor != null){
            this.stylesheet = this.stylesheet + "background-color: "+this.headerBgColor+"; ";
        }
        if(this.headerHeight != null){
            this.stylesheet = this.stylesheet + "height: "+this.headerHeight+"px; ";
        }
        if(this.headerMargin != null){
            this.stylesheet = this.stylesheet + "margin: "+this.headerMargin+"; ";
        }
        if(this.headerBrdrRadius != null){
            this.stylesheet = this.stylesheet + "border-radius: "+this.headerBrdrRadius+"px; ";
        }
        if(this.headerBrdr != null){
            this.stylesheet = this.stylesheet + "border: "+this.headerBrdr+"; ";
        }
        if(this.headerPadding != null){
            this.stylesheet = this.stylesheet + "padding: "+this.headerPadding+"; ";
        }
        

        if(this.showHeader){

        console.log('this.isTextOnly:'+this.isTextOnly);
        
        if(this.imageName!= null && (this.isTextLeftImageRight || this.isImageLeftTextRight)){

            if(this.iconPadding != null){
                this.iconCSS = ".iconCSS {margin:"+ this.iconPadding +"; }";
            }

            if(this.imageType == 'lightningIcon'){//imageType is set from CPE available for FLow Screens only
                this.imageIsALightningIcon = true;
                this.imageIsAStaticResource = false;
            }else if(this.imageType == 'staticResource'){
                this.imageIsALightningIcon = false;
                this.imageIsAStaticResource = true;
            }


            if(this.imageIsALightningIcon){//lightning icon gets priority over Static Resource
                this.imageIsAStaticResource = false;
            }
                
            if(this.imageIsAStaticResource){
                this.staticResourceUrl = staticResourceReference +'/'+this.imageName;
            }

        }


        
        if(this.isTextAHyperlink){
            if(this.linkTargetNewWindow){
                this.linkTarget = '_blank';
            }

            this.linkCSS = "a.linkCSS:link, a.linkCSS:hover, a.linkCSS:visited, a.linkCSS:active {";

            if(this.removeTextDecoration){
                this.linkCSS = this.linkCSS + "text-decoration:none !important;";
            }

            if(this.headerTxtColor != null){
                this.linkCSS = this.linkCSS + "color: "+this.headerTxtColor+"; ";
            }
            if(this.headerTxtSize != null){
                this.linkCSS = this.linkCSS + "font-size: "+this.headerTxtSize+"; ";
            }

            this.linkCSS = this.linkCSS + "}";
            
        }
        
        
        if(this.isTextOnly || this.isImageLeftTextRight){
            if(this.textAlignment != null){
                this.stylesheet = this.stylesheet + "text-align: "+this.textAlignment+"; ";
            }

        }
        
        if(this.headerTxtColor != null){
            this.stylesheet = this.stylesheet + "color: "+this.headerTxtColor+"; ";
        }
        if(this.headerTxtFont != null){
            this.stylesheet = this.stylesheet + "font-family: "+this.headerTxtFont+"; ";
        }
        if(this.headerTxtSize != null){
            this.stylesheet = this.stylesheet + "font-size: "+this.headerTxtSize+"; ";
        }
        if(this.isBold){
            this.stylesheet = this.stylesheet + "font-weight: bold; ";
        }
        if(this.isItalicized){
            this.stylesheet = this.stylesheet + "font-style: italic; ";
        }
        if(this.isUnderlined){
            this.stylesheet = this.stylesheet + "text-decoration: underline !important; ";
        }
        this.stylesheet = this.stylesheet + " }";
        this.stylesheet = this.stylesheet + " " +this.iconCSS;
        this.stylesheet = this.stylesheet + " " +this.linkCSS;
        
    } else{

        this.stylesheet = this.stylesheet + " width:100%;} ";

    }
    console.log('this.stylesheet '+this.stylesheet);
        
    }

    setDisplayMode(inputDisplayMode){
        console.log('in setDisplayMode: '+inputDisplayMode);
        this.displayAsHorizontalLine = false;
        this.isTextOnly = false;
        this.isImageLeftTextRight = false;
        this.isTextLeftImageRight = false;

        switch(inputDisplayMode) {
            case 'horizontalLine':
            case 'Horizontal Line':
            console.log('case horizontalLine');
              this.displayAsHorizontalLine = true;
              break;
            case 'textOnly':
            case 'Text Only':
                console.log('case textOnly');
              this.isTextOnly = true;
              break;
            case 'textLeftImageRight':
            case 'Text on Left and Image on Right':
                console.log('case textLeftImageRight');
              this.isTextLeftImageRight = true;
              break;
            case 'ImageLeftTextRight':
            case 'Image on Left and Text on Right':
                console.log('case ImageLeftTextRight');
              this.isImageLeftTextRight = true;
              break;
            default:
                console.log('case default');
                this.displayAsHorizontalLine = true;
          }

        
    }
    

    renderedCallback() {
        //console.log('in renderedCallback');
        // This finds the placeholder element in the template
        const div = this.template.querySelector("div[data-id='stylesheet']");

        if (div) {
            div.innerHTML = "<style>" + this.stylesheet + "</style>";
        }
    }

    
}
