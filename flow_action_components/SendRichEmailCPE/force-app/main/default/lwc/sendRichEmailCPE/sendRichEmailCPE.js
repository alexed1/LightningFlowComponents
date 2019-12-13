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
     @api validate() {
            //do some checking for errors

            //return the data structure shown above which is an array of objects

            // for example, if the error is due to a slider being out of bounds then you 
            //could return this data structure:
           //[{
           //   key: 'SendRichEmail - Set Return Date Maximum',
           //   errorString: 'Return Date Maximum must be less than 30'
            //}]


            

     }


}