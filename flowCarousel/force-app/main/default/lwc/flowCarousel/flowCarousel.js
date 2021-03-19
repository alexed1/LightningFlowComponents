import { LightningElement,api,track } from 'lwc';

export default class FlowCarousel extends LightningElement {
    @api ImageURLs;
    @api Headers;
    @api Descriptions;
    @api AltText;
    @api carouselTitle;
    @track items = [];

    connectedCallback() {
        console.log("initializing FlowCarousel");
        console.log("ImageURLs is:" + this.ImageURLs);
        console.log("Descriptions is:" + this.Descriptions);
        console.log("AltText is:" + this.AltText);
        let items = [];
        let index = 0;
        console.log("Headers is: " + this.Headers);
        
        this.Headers.forEach(header => {
          items.push({
            header: header,
            src: this.ImageURLs[index],
            description: this.Descriptions[index],
            alttext: this.AltText[index], 
            uniqueId: this.AltText[index] + " + " + index     
          });
          console.log("items is: " + items);
          index + 1;
        });
        this.items = items;
    }
}