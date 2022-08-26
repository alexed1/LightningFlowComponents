import { api, LightningElement } from 'lwc';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';

const LATE_STATUS = 'Late';
const IMMINENT_STATUS = 'Imminent';
const SOON_STATUS = 'Soon';
const UPCOMING_STATUS = 'Upcoming';
const ACTIVE_STATUS = 'Active';
const SNOOZED_STATUS = 'Snoozed';
const DISMESSED_STATUS = 'Dismissed';

export default class CalendarAlerter extends LightningElement {
    @api firstAlarm = 15; //The number of minutes before an event when Alerter starts generating alarms
    @api secondAlarm = 5;
    @api thirdAlarm = 1;
    @api meetitngRange = 15;
    @api evaluationFrequency = 1;
    @api eventList = [{
        id : '37nnq4lel3v3g3nlb3g09vo',
        summary : 'test 1',
        start : {
            startTime : '2022-08-18T16:15:00+01:00'
        },

    },{
        summary : 'test 2',
        id : '37nnq4lel3v3g3nlb3g09von01',
        start : {
            startTime : '2022-08-18T16:30:00+01:00'
        },

    },{
        summary : 'test 3',
        id : '37nnq4lel3v3g3nlb3g09von02',
        start : {
            startTime : '2022-08-18T16:50:00+01:00'
        },

    },];

    imminentIntervalId = '';
    evaluationIntervalId = '';
    alertedMeetingId = '';

    alertCount = 0;
    get eventToShowList () {
        return this.eventList.filter(
            (item) => item.alarmStatus !== DISMESSED_STATUS
        );
    }
    statusForFirstMeeting = '';
    audio = {};

    playThis = '/resource/MeetingAlert';

    connectedCallback() {
        
        this.eventList = JSON.parse(JSON.stringify(this.eventList));
        let eventListJSON = localStorage.getItem('eventList');
        if(eventListJSON) {
            let eventList = JSON.parse(eventListJSON);

            this.eventList.forEach(
                (item) => {
                    let event = eventList.find((findItem) => findItem.id === item.id);
                    if(event) {
                        item.alarmStatus = event.alarmStatus;
                        if(item.start.startTime === event.start.startTime) {
                            item.firstAlarmCompleted = event.firstAlarmCompleted;
                            item.secondAlarmCompleted = event.secondAlarmCompleted;
                            item.thirdAlarmCompleted = event.thirdAlarmCompleted;
                            item.meetingStatus = event.meetingStatus;
                        }
                        
                        
                    }
                }
            );
        }

        this.initAudio();
        setTimeout(
            this.evaluateEvents,
            5000
        );
        this.evaluationIntervalId = setInterval(
            this.evaluateEvents,
            (this.evaluationFrequency * 60000)
        );

        setTimeout(
            () => {
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }, this.meetitngRange * 60000
        );
    }

    initAudio() {
        this.audio = new Audio();
        this.audio.src = this.playThis;
        this.audio.load();

    }

    playAudio() {
        if(this.imminentIntervalId) {
            window.clearInterval(this.imminentIntervalId);
            this.imminentIntervalId = '';
        }
        console.log('status ', this.statusForFirstMeeting, this.firstAlarm, this.secondAlarm, this.thirdAlarm);
        let volume = 0;
        if(this.statusForFirstMeeting === UPCOMING_STATUS) {
            volume = 0.1;
            this.alertCount = 2;
        } else if(this.statusForFirstMeeting === SOON_STATUS) {
            volume = 0.4;
            this.alertCount = 3;
        } else if(this.statusForFirstMeeting === IMMINENT_STATUS) {
            volume = 0.7;
            this.alertCount = 5;
        } else if(this.statusForFirstMeeting === LATE_STATUS) {
            volume = 1;    
            this.alertCount = 1000;
        }

        
        if(volume > 0) {
            this.audio.volume = volume;
            this.audio.play();
            this.alertCount--;
            this.imminentIntervalId = setInterval(
                () => {
                    this.audio.play();
                    this.alertCount--;
                    if(this.alertCount <= 0 ) {
                        window.clearInterval(this.imminentIntervalId);
                        this.imminentIntervalId = '';
                    }
                }, this.audio.duration * 1000 + 1000
            );
        }
    }


    evaluateEvents = () => {
        this.statusForFirstMeeting = '';
        let minutsToFirstMeet = this.firstAlarm + 1;
        this.eventList.forEach((event) => {
            console.log(new Date(Date.now()));
            console.log(new Date(Date.parse(event.start.startTime)));
            console.log((Date.parse(event.start.startTime) / 60000) - (Date.now()/ 60000)  );
            let minutsToEvent = (Date.parse(event.start.startTime) / 60000) - (Date.now()/ 60000) ;
            let isRunAlert = false;
            if(event.alarmStatus !== SNOOZED_STATUS && event.alarmStatus !== DISMESSED_STATUS) {
                if(!event.firstAlarmCompleted && minutsToEvent <= this.firstAlarm && minutsToEvent > this.secondAlarm) {
                    event.meetingStatus = UPCOMING_STATUS;
                    event.firstAlarmCompleted = true;
                    isRunAlert = true;
                } else if(!event.secondAlarmCompleted && minutsToEvent <= this.secondAlarm && minutsToEvent > this.thirdAlarm) {
                    event.firstAlarmCompleted = true;
                    event.secondAlarmCompleted = true;
                    isRunAlert = true;
                    event.meetingStatus = SOON_STATUS;
                } else if(!event.thirdAlarmCompleted && minutsToEvent < this.thirdAlarm && minutsToEvent > 0) {
                    event.firstAlarmCompleted = true;
                    event.secondAlarmCompleted = true;
                    event.thirdAlarmCompleted = true;
                    isRunAlert = true;
                    event.meetingStatus = IMMINENT_STATUS;
                } else if(minutsToEvent < 0 && minutsToEvent > -15){
                    event.meetingStatus = LATE_STATUS;
                    isRunAlert = true;
                }

                if(isRunAlert && minutsToEvent <= minutsToFirstMeet) {
                    this.statusForFirstMeeting = event.meetingStatus;
                    this.alertedMeetingId = event.id;
                    minutsToFirstMeet = minutsToEvent
                }
                
        }

            console.log(event.meetingStatus);
        });
        this.eventList = JSON.parse(JSON.stringify(this.eventList));

        localStorage.setItem('eventList', JSON.stringify(this.eventList));
        if(this.statusForFirstMeeting) {
            this.playAudio();
        }

        
    }


    updateEvent(event) {
        let meetingId = event.detail.meetingId;
        let meetingStatus = event.detail.status;
        let meeting = this.eventList.find(
            (item) => item.id === meetingId
        );

        if(meeting) {
            meeting.alarmStatus = meetingStatus;
        }

        console.log(this.eventList);
        this.eventList = JSON.parse(JSON.stringify(this.eventList));
        localStorage.setItem('eventList', JSON.stringify(this.eventList));
        if(meetingId == this.alertedMeetingId) {
            window.clearInterval(this.imminentIntervalId);
            this.audio.pause();
            this.audio.currentTime = 0;
        }
    }

    @api validate() {
        clearInterval(this.imminentIntervalId);
        clearInterval(this.evaluationIntervalId);
        this.audio.pause();
        this.audio.currentTime = 0;
    }
}

