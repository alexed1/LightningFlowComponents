/* eslint-disable no-console */
import { LightningElement, api} from 'lwc';

export default class ExpressionLine extends LightningElement {

    @api logicType;	
    @api value;	 
    @api availableLHSObjectFields;
    @api availableRHSMergeFields;
    @api addButtonLabel;


    handleChange(event) {
        console.log('handleChange triggered: ' + event.target.value);
        
    }
}