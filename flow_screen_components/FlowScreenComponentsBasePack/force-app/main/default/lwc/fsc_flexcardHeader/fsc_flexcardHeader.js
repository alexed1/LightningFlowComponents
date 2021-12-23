import { LightningElement,api } from 'lwc';

export default class fsc_FlexcardHeader extends LightningElement {

@api titleFieldName;
@api subtitleFieldName;
@api statusFieldName;
@api src;
@api icon;
@api variant;
@api hoverText;
@api headerStyle;

get showIcon() {
    return this.icon && this.icon.length > 0;
}

}
