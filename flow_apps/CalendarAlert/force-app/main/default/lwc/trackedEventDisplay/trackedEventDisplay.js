import { api, LightningElement } from 'lwc';

export default class TrackedEventDisplay extends LightningElement {
    @api item;

    get isSnoozed() {
        return this.item.alarmStatus === 'Snoozed';
    }

    updateEvent(event) {
        console.log(event.target.dataset.id);
        let meetingId = event.target.dataset.id;
        let meetingStatus = event.target.dataset.status;
        const selectedEvent = new CustomEvent('eventupdated', { detail: {
            meetingId : meetingId,
            status : meetingStatus
        }});
        this.dispatchEvent(selectedEvent);
    }
}