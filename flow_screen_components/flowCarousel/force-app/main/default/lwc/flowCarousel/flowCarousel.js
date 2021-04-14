import { LightningElement,api,track } from 'lwc';

export default class FlowCarousel extends LightningElement {
    @api imageURLs;
    @api headers;
    @api descriptions;
    @api hyperlinkURLs;
    @api altText;
    @api carouselTitle;
    @api slideSize;
    @track items = [];

    connectedCallback() {
        console.log("initializing FlowCarousel");
        console.log("ImageURLs is:" + this.imageURLs);
        console.log("Descriptions is:" + this.descriptions);
        console.log("AltText is:" + this.altText);
        console.log("URLs is:" + this.hyperlinkURLs);
        let items = [];
        let index = 0;
        console.log("Headers is: " + this.headers);        
        this.headers.forEach(header => {
          items.push({
            header: header,
            src: this.imageURLs[index],
            description: this.descriptions[index],
            alttext: this.altText[index],
            href:this.hyperlinkURLs[index], 
            uniqueId: this.altText[index] + " + " + index     
          });
          console.log("items is: " + items);
          index += 1;
        });
        this.items = items;
    }
}
