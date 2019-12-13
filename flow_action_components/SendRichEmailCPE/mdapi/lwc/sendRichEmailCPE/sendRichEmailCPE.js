import { api,LightningElement } from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

/* array of complex object containing id-value of a input parameter.
     * eg: [{
     *       id: 'prop1_id',
     *       value: 'value',
     *       dataType: 'string'
         }]
    */
     @api values
 
     /* array of all input parameters
      * [{
      *       id: 'prop1_id',
      *       label: 'prop1_label',
      *       dataType: 'string',
      *       description: 'desc' // optional
      *       isRequired: true, // optional
      *       defaultValue: '', // optional
      *       context: {
      *           isCollection
      *           ...
      *           ...
      *       } // optional
      *  }]
      */
     @api property
 
     /* map of resource available in the flow
        {
            actionCalls: [],
            apexPluginCalls: [],
            constants: [],
            formulas: [],
            recordCreates: [],
            recordDeletes: [],
            recordLookups: [],
            recordUpdates: [],
            screens: [],
            stages: [],
            textTemplates: [],
            variables: []
       }
     */
     @api flowContext
 
     // Return a promise that resolve and return errors if any
     // In 224, it will be synchronus instead of async. 
     // [{
     //      key: 'key1',
     //      errorString: 'Error message'
     // }]
     @api validate() {}


}