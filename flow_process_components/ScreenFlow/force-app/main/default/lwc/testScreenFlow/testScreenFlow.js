import {LightningElement} from 'lwc';

export default class TestScreenFlow extends LightningElement {
    flowParams = [{
        name: 'greeting',
        type: 'String',
        value: 'Hello World'
    }, {
        name: 'greeting2',
        type: 'String',
        value: 'Hello World2'
    }];

    get flowParamsJSON() {
        return JSON.stringify(this.flowParams);
    }
}

