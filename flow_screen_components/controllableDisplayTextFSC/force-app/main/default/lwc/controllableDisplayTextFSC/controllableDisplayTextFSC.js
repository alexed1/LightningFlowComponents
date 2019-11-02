import { LightningElement, api } from 'lwc';

export default class ControllableDisplayTextFSC extends LightningElement {
    masterString;
    @api string1='This ControllableDisplayText Flow Screen Component has not been assigned a value';
    @api fontfamily1;
    @api fontsizepct1;
    @api sizetag1="h2";
    @api color1;
    @api bold1;
    @api italics1;
    @api url1;
    @api textalign1;
    @api addbreak1;

    

    connectedCallback() {
           this.masterString = this.formatString(this.string1, this.bold1, this.sizetag1, this.italics1,
             this.color1, this.url1, this.fontfamily1, this.textalign1, this.addbreak1, this.fontsizepct1);
          }

    formatString(curString, boldBoolean, sizetag, italicsBoolean, color='', url, fontfamily, textalign, addbreak, fontsizepct) {
        var outerStyleString = 'style="';
        var outerColorString = '';
        var anchorlinkColorString = '';

        //first figure out if there will be an inner anchor link
        if (url) {
            //check to see if the url needs to have 'https://' added to it
            if (url.substring(0,4) !== 'http')
            url = 'https://' + url;

            //color can only be applied to urls if it goes inside the anchor link
            if(color)
                anchorlinkColorString = "style= color:" + color + ";";
            curString = "<a " + anchorlinkColorString + " href=" +  url + " target='_blank'>" + curString + "</a>";
        }
        



        if (boldBoolean)
            curString = "<b>" + curString + "</b>";

        if (italicsBoolean)
            curString = "<i>" + curString + "</i>";
        
        

        //apply styles
        //if a url is involved, color was already inserted into the anchorlink, above
        if (!url && color !== '')
            outerStyleString = outerStyleString + " color:" + color + "; ";

        if (fontfamily)
            outerStyleString = outerStyleString + " font-family:" + fontfamily + "; ";
        if (textalign)
            outerStyleString = outerStyleString + " text-align:" + textalign + "; ";
        if (fontsizepct)
            outerStyleString = outerStyleString + " font-size:" + fontsizepct + "%; ";

        outerStyleString = outerStyleString + '"';

        if (sizetag)
        //TODO: add some error checking to make sure it's a legitimate 
            curString = "<" + sizetag.toLowerCase() + " " + outerStyleString + ">" + curString + "</" + sizetag.toLowerCase() + ">";
        if (addbreak)
            curString = curString + "<br>";
            
        console.log(curString);
        return curString;
    }
}