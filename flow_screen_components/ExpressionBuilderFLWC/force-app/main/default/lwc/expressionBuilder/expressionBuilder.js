import { LightningElement, api } from 'lwc';

export default class ExpressionBuilder extends LightningElement {

    @api logicType;
    @api value;	 
    @api availableLHSObjectFields;
    @api availableRHSMergeFields;
    @api addButtonLabel;
    
}