import { LightningElement,api } from 'lwc';

export default class FlexcardHeader extends LightningElement {

@api TitleFieldName;
@api SubtitleFieldName;
@api StatusFieldName;
@api SRC;
@api Icon;
@api Variant;
@api HoverText

}