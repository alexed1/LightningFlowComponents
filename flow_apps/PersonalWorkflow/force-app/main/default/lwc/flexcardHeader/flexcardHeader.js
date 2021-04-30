  
import { LightningElement,api } from 'lwc';

export default class FlexcardHeader extends LightningElement {

@api titleFieldName;
@api subtitleFieldName;
@api statusFieldName;
@api src;
@api icon;
@api variant;
@api hoverText


}