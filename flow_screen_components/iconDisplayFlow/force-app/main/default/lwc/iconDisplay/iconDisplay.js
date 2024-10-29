import { LightningElement , api } from 'lwc';

export default class IconDisplay extends LightningElement {
    @api iconType;
    @api iconName;
    @api foregroundColor;
    @api backgroundColor;

    get iconTypeName(){
        return this.iconType + ":" + this.iconName;
    }

    get myIconClass(){
        return !this.foregroundColor || !this.backgroundColor ? '' : 'my-icon'
    }
    //both foregroundColor and backgroundColor are required to set custom color. 

    renderedCallback() { 
        this.initCSSVariables();
    }

    initCSSVariables() {
        this.template.querySelector('.my-icon').style.setProperty('--backgroundColor', this.backgroundColor);
        this.template.querySelector('.my-icon').style.setProperty('--foregroundColor', this.foregroundColor);
    }
}
