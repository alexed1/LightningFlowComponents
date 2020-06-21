import { LightningElement, api } from 'lwc';

export default class InputRichTextFSC_LWC extends LightningElement {
    @api value;
    @api label;
    formats = ['font', 'size', 'bold', 'italic', 'underline',
        'strike', 'list', 'indent', 'align', 'link',
        'image', 'clean', 'table', 'header', 'color','background','code','code-block','script','blockquote','direction'];
}