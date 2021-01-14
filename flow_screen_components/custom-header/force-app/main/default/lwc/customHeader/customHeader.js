import { LightningElement,api } from 'lwc';
import staticResourceReference from '@salesforce/resourceUrl/customHeaderImages';

export default class CustomHeader extends LightningElement {
    @api recordId;
    @api orderNumber;
    @api imageName;
    @api iconPadding;
    @api iconSize;
    @api displayAsHorizontalLine = false;
    @api isTextAHyperlink = false;
    @api linkTargetNewWindow = false;
    @api removeTextDecoration = false;
    @api urlToRedirect;
    @api imageIsALightningIcon = false;
    @api imageIsAStaticResource = false;
    @api headerText;
    @api headerTextAlignment;
    @api headerHeight;
    @api headerBgColor; 
    @api headerTxtColor; 
    @api headerTxtFont; 
    @api headerTxtSize; 
    @api headerBrdrRadius; 
    @api headerBrdr;
    @api displayForRecordId;
    @api staticResourceImageHeight;
    @api staticResourceImageWidth;
    @api headerMargin;
    @api headerPadding;
    @api isTextOnly = false;
    @api isTextLeftImageRight = false;
    @api isTextAndImageOnLeftOfText = false;
    linkTarget ='_self';
    isTextHyperlink = false;
    showHeader = false;
    showLightningIcon = false;
    lightningIcon = 'utility:down';
    showStaticResource = false;
    staticResourceUrl;
    showTextOnly = false;
    showTextOnLeftImageOnRight = false;
    showTextAndImageOnLeftOfText = false;
    imgHeight;
    imgWidth;
    lightningIconSize;

    stylesheet = ".customHeaderCSS"+this.orderNumber+" {}";
    linkCSS = "";
    iconCSS = ".iconCSS {}";
    randomNumber = 0;
    mini = 0;
    maxi = 0;
    customHeaderCSSName = "customHeaderCSS"+this.orderNumber;
    randomNumberNew = 0;
    
    connectedCallback(){
        
        this.customHeaderCSSName = "customHeaderCSS"+this.orderNumber;
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
        if(this.showHeader){

        this.isTextHyperlink = this.isTextAHyperlink;
        console.log('this.isTextOnly:'+this.isTextOnly);
        if(this.isTextOnly){
            this.showTextOnly = true;

        }else if(this.isTextLeftImageRight){
            console.log('this.isTextLeftImageRight:'+this.isTextLeftImageRight);
            this.showTextOnLeftImageOnRight = true;
            
        }else if(this.isTextAndImageOnLeftOfText){
            console.log('this.isTextAndImageOnLeftOfText:'+this.isTextAndImageOnLeftOfText);
            this.showTextAndImageOnLeftOfText = true;
        }/*else {
            //if none are true
            console.log('if none are true:');
            this.showTextOnly = true;
        }*/

        if(this.imageName!= null && (this.showTextOnLeftImageOnRight || this.showTextAndImageOnLeftOfText)){

            if(this.iconPadding != null){
                this.iconCSS = ".iconCSS {margin:"+ this.iconPadding +";}";//"text-align: "+this.headerTextAlignment+";";
            }

            if(this.imageIsALightningIcon){
                this.lightningIcon = this.imageName;
                this.lightningIconSize = this.iconSize;
                this.showLightningIcon = true;
                
            }else if(this.imageIsAStaticResource){
                this.staticResourceUrl = staticResourceReference +'/'+this.imageName;
                this.imgHeight = this.staticResourceImageHeight;
                this.imgWidth = this.staticResourceImageWidth;
                this.showStaticResource = true;
            }

        }


        if(this.linkTargetNewWindow){
            this.linkTarget = '_blank';
        }

        if(this.removeTextDecoration){
            this.linkCSS = ".linkCSS {text-decoration:none !important;}";
        }

        this.stylesheet = "."+this.customHeaderCSSName+" {";
        
        if(this.isTextOnly || this.isTextAndImageOnLeftOfText){
            if(this.headerTextAlignment != null){
                console.log('this.headerTextAlignment--1 '+this.headerTextAlignment);
                this.stylesheet = this.stylesheet + "text-align: "+this.headerTextAlignment+";";
            }

        }



        
        
        
        if(this.headerBgColor != null){
            console.log('this.headerBgColor '+this.headerBgColor);
            this.stylesheet = this.stylesheet + "background-color: "+this.headerBgColor+";";
        }
        if(this.headerTxtColor != null){
            console.log('this.headerTxtColor '+this.headerTxtColor);
            this.stylesheet = this.stylesheet + "color: "+this.headerTxtColor+";";
        }
        if(this.headerHeight != null){
            console.log('this.headerHeight '+this.headerHeight);
            this.stylesheet = this.stylesheet + "height: "+this.headerHeight+"%;";
        }
        if(this.headerTxtFont != null){
            console.log('this.headerTxtFont '+this.headerTxtFont);
            this.stylesheet = this.stylesheet + "font-family: "+this.headerTxtFont+";";
        }
        if(this.headerTxtSize != null){
            console.log('this.headerTxtSize '+this.headerTxtSize);
            this.stylesheet = this.stylesheet + "font-size: "+this.headerTxtSize+";";
        }
        if(this.headerBrdrRadius != null){
            console.log('this.headerBrdrRadius '+this.headerBrdrRadius);
            this.stylesheet = this.stylesheet + "border-radius: "+this.headerBrdrRadius+"px;";
        }
        if(this.headerBrdr != null){
            console.log('this.headerBrdr '+this.headerBrdr);
            this.stylesheet = this.stylesheet + "border: "+this.headerBrdr+";";
        }
        if(this.headerMargin != null){
            console.log('this.headerMargin '+this.headerMargin);
            this.stylesheet = this.stylesheet + "margin: "+this.headerMargin+";";
        }
        if(this.headerPadding != null){
            console.log('this.headerPadding '+this.headerPadding);
            this.stylesheet = this.stylesheet + "padding: "+this.headerPadding+";";
        }
        this.stylesheet = this.stylesheet + " }";
        this.stylesheet = this.stylesheet + " " +this.iconCSS;
        this.stylesheet = this.stylesheet + " " +this.linkCSS;
        console.log('this.stylesheet '+this.stylesheet);
    } else{

        this.stylesheet = "."+this.customHeaderCSSName+" { width:100%; ";
        //this.stylesheet = " { width:100%; ";
        if(this.headerBgColor != null){
            console.log('this.headerBgColor '+this.headerBgColor);
            this.stylesheet = this.stylesheet + "background-color: "+this.headerBgColor+";";
        }
        if(this.headerHeight != null){
            console.log('this.headerHeight '+this.headerHeight);
            this.stylesheet = this.stylesheet + "height: "+this.headerHeight+"%;";
        }
        if(this.headerMargin != null){
            console.log('this.headerMargin '+this.headerMargin);
            this.stylesheet = this.stylesheet + "margin: "+this.headerMargin+";";
        }
        this.stylesheet = this.stylesheet + " }";
        console.log('this.stylesheet '+this.stylesheet);
        

    }
        
    }
    

    renderedCallback() {
        // This finds the placeholder element in the template
        const div = this.template.querySelector("div[data-id='stylesheet']");

        if (div) {
            div.innerHTML = "<style>" + this.stylesheet + "</style>";
        }
    }

    
}