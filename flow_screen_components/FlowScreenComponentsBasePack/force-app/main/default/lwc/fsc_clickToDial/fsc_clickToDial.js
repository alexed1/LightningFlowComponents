import { api, LightningElement } from 'lwc';

export default class fsc_clickToDial extends LightningElement {
    @api phoneNumber = '14155555553';
    @api recordId ='5003000000D8cuI';
    @api params = 'accountSid=xxx, sourceId=xxx, apiVersion=123';
}