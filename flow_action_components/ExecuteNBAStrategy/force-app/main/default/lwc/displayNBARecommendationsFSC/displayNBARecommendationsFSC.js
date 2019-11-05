import {LightningElement, api, track, wire} from 'lwc';
import setRecommendationReaction from '@salesforce/apex/ExecuteNBAStrategy.setRecommendationReaction';
import userId from '@salesforce/user/Id';

export default class DisplayNBARecommendationsFSC extends LightningElement {
    @api displayDescription;
    @api displayTitle;
    @api recordId;
    @api strategyName;
    @api _recommendations;
    @api displayMode;
    @api maxRecommendations = 25;
    @api itemsPerPage = 3;


    @track removedRecords = [];
    @track pageIndex = 0;
    @track reactedOnce = false;
    @track filteredRecs = [];

    labels = {
        noTitleDescription: 'Neither "title" nor "description" field is selected',
        noRecommendationsFound: 'We could not find any recommendations for you',
        reactedToAll: 'You have reacted to all recommendations',
        previous: 'Previous',
        next: 'Next',
        page: 'Page',
        outOf: '/',
        actionApprove: 'Accepted',
        actionReject: 'Rejected'
    };

    navigate(event) {
        let direction = parseInt(event.currentTarget.dataset.navigationDirection);
        let newIndex = this.pageIndex + direction;
        this.pageIndex = (newIndex < 0 || newIndex > this.totalPages) ? this.pageIndex : newIndex;
    }

    handleAction(event) {
        let reaction = event.currentTarget.dataset.actionName;
        let removedId = event.currentTarget.dataset.recordId;
        let curRecommendation = this._recommendations.recommendations.find(curRec => curRec.Id === removedId);
        if (curRecommendation && curRecommendation.acceptFlowType === 'Flow' && reaction === 'Accepted') {
            window.open(this.buildFlowURL(curRecommendation.acceptFlowName), '_blank');
        }
        setRecommendationReaction({
            recordId: this.recordId,
            reaction: reaction,
            strategyName: this.strategyName,
            recommendation: JSON.stringify(curRecommendation)
        }).then(result => {
            this.showToast({
                detail: {
                    title: 'Success',
                    message: 'Recommendation ' + curRecommendation.name + ' ' + reaction,
                    variant: reaction === this.labels.actionApprove ? 'success' : 'warning',
                    autoClose: true
                }
            });
            this.removeRecommendation(removedId);
        }).catch(error => {
            this.showToast({
                detail: {
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    autoClose: true
                }
            });
        });
    }

    buildFlowURL(flowApiName) {
        return window.location.origin + '/flow/' + flowApiName + '?recordId=' + this.recordId + '&strategyName=' + this.strategyName+'&userId='+userId;
    }

    removeRecommendation(removedId) {
        this.reactedOnce = true;
        this.removedRecords.push(removedId);
        this.updateFilteredRecs();
        this.checkPageIndex();
    }

    checkPageIndex() {
        if (this.pageIndex + 1 > this.totalPages) {
            this.pageIndex--;
        }
    }

    @api
    get recommendations() {
        return this._recommendations;
    }

    set recommendations(value) {
        this._recommendations = value;
        this.updateFilteredRecs();
    }

    get errorMessage() {
        if (!this.filteredRecs || this.filteredRecs.length === 0) {
            return this.reactedOnce ? this.labels.reactedToAll : this.labels.noRecommendationsFound;
        } else if (!this.displayDescription && !this.displayTitle) {
            return this.labels.noTitleDescription;
        }
    }

    get curPage() {
        return this.pageIndex + 1;
    }

    get isPreviousButtonDisabled() {
        return this.curPage === 1;
    }

    get isNextButtonDisabled() {
        return this.curPage === this.totalPages;
    }

    get isNavigationButtonsAvailable() {
        return (this.filteredRecs.length !== 0 && this.displayMode === 'ShowPages');
    }

    get totalPages() {
        let filteredRecs = this.filteredRecs;
        if (filteredRecs && filteredRecs.length > 0) {
            let totalItems = filteredRecs.length;
            let totalPages = Math.round(totalItems / this.itemsPerPage + 0.499);
            return totalPages;
        } else {
            return 0;
        }
    }

    updateFilteredRecs() {
        if (this._recommendations) {
            this.filteredRecs = this._recommendations.recommendations.filter(curRec => !this.removedRecords.includes(curRec.Id));
        } else {
            this.filteredRecs;
        }
    }

    get recs() {
        let filteredRecs = this.filteredRecs;
        if (this.isNavigationButtonsAvailable) {
            filteredRecs = filteredRecs.slice(this.pageIndex * this.itemsPerPage, this.curPage * this.itemsPerPage);
        }
        if (filteredRecs) {
            return filteredRecs.map(cuRec => {
                return {
                    ...cuRec, ...{
                        displayText: this.displayTitle ? cuRec.name : cuRec.description,
                        title: this.displayTitle && this.displayDescription ? '' : this.displayTitle ? cuRec.description : cuRec.name
                    }
                };
            })
        } else {
            return [];
        }

    }

    showToast(event) {
        this.template.querySelector('c-toast-message').showCustomNotice(event);
    }
}
