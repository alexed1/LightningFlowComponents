import { LightningElement, api, track } from 'lwc';

export default class MultiMapFSC extends LightningElement {

    //input attributes
    @api title;
    @api markerList;
    @api showListView = false;
    @api coordinates = false;
    @api selectedMarkerValue;

    //component attributes
    @track markerObjList = [];
    @track listView = 'hidden';

    connectedCallback() {
        if (this.markerList.length > 0) {
            for (let i = 0; i < this.markerList.length; i++) {
                //Splitting location elements by ';' as some address fields can have ','.  
                //Latitude and Longitude will not be leaving for consistency in setting up flow.
                let locationData = this.markerList[i].split(';');
                //If coordinates set to be passed in, then use:
                if (this.coordinates) {
                    let markerObj = {
                        location: {
                            'Latitude': locationData[0],
                            'Longitude': locationData[1]
                        },
                        title: locationData[2],
                        description: locationData[0] + ', ' + locationData[1],
                        icon: locationData[3],
                        value: locationData[4]
                    }
                    this.markerObjList.push(markerObj);
                } else {
                    let markerObj = {
                        location: {
                            'City': locationData[0],
                            'Country': locationData[1],
                            'PostalCode': locationData[2],
                            'State': locationData[3],
                            'Street': locationData[4]
                        },
                        title: locationData[5],
                        description: locationData[0] + ', ' + locationData[3] + ' ' + locationData[2],
                        icon: locationData[6],
                        value: locationData[7]
                    }
                    this.markerObjList.push(markerObj);
                }
            }
        }
        if (this.showListView) {
            this.listView = 'visible';
        }
    }

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }

}
