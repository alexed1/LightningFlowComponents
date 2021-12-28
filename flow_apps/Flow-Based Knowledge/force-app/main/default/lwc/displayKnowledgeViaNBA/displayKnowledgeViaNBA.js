import {LightningElement, api, track, wire} from 'lwc';
import setRecommendationReaction from '@salesforce/apex/ExecuteNBAStrategy.setRecommendationReaction';
import executeNBAFlow from '@salesforce/apex/KnowledgeRecommendationsGenerator.executeNBAFlow';
import launchFLow from '@salesforce/apex/ExecuteNBAStrategy.launchFLow';
import userId from '@salesforce/user/Id';
const FLOW_LABEL = 'flow';
const LEGACY_LABEL = 'legacy'

export default class DisplayKnowledgeViaNBA extends LightningElement {
    @api displayDescription;
    @api displayTitle;
    @api recordId;
    @api strategyName;
    @api _recommendations;
    @api displayMode;
    @api maxRecommendations = 25;
    @api itemsPerPage = 3;
    @api strategySource = LEGACY_LABEL;


    @track removedRecords = [];
    @track pageIndex = 0;
    @track reactedOnce = false;
    @track filteredRecs = [];
    searchString = '';

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
        if(this.strategySource === LEGACY_LABEL) {
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
        } else {
            let reaction = event.currentTarget.dataset.actionName;
            let removedId = event.currentTarget.dataset.recordId;
            let curRecommendation = this._recommendations.recommendations.find(curRec => curRec.ExternalId === removedId);
            console.log('curRecommendation', curRecommendation);
            if (curRecommendation && reaction === 'Accepted') {
                launchFLow({
                    rec : curRecommendation,
                    strategyName : this.strategyName
                }).then(
                    result => {
                        this.showToast({
                            detail: {
                                title: 'Success',
                                message: 'Recommendation ' + curRecommendation.Name + ' ' + reaction,
                                variant: reaction === this.labels.actionApprove ? 'success' : 'warning',
                                autoClose: true
                            }
                        });
                        if(result === 'Flow') {
                            window.open(this.buildFlowURL(curRecommendation.ActionReference, curRecommendation.ExternalId), '_blank');
                        }
                    }
                ).catch(
                    error => {
                        console.error(error);
                        this.showToast({
                            detail: {
                                title: 'Error',
                                message: error.body.message,
                                variant: 'error',
                                autoClose: true
                            }
                        });
                        
                    }
                );
            } else {
                this.showToast({
                    detail: {
                        title: 'Success',
                        message: 'Recommendation ' + curRecommendation.Name + ' ' + reaction,
                        variant: reaction === this.labels.actionApprove ? 'success' : 'warning',
                        autoClose: true
                    }
                });
                this.removeRecommendation(removedId);
            }
        }
    }

    buildFlowURL(flowApiName, recordId) {
        return window.location.origin + '/flow/' + flowApiName + '?recordId=' + (recordId ? recordId : this.recordId) + '&strategyName=' + this.strategyName+'&userId='+userId;
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
            if(this.strategySource === LEGACY_LABEL) {
                this.filteredRecs = this._recommendations.recommendations.filter(curRec => !this.removedRecords.includes(curRec.Id));
            } else {
                this.filteredRecs = this._recommendations.recommendations.filter(curRec => !this.removedRecords.includes(curRec.ExternalId));
            }
            console.log(this.filteredRecs);
        } else {
            this.filteredRecs = [];
        }
    }

    get recs() {
        let filteredRecs = this.filteredRecs;
        if (this.isNavigationButtonsAvailable) {
            filteredRecs = filteredRecs.slice(this.pageIndex * this.itemsPerPage, this.curPage * this.itemsPerPage);
        }
        if (filteredRecs) {
            if(this.strategySource === LEGACY_LABEL) {
                console.log(LEGACY_LABEL);
                return filteredRecs.map(cuRec => {
                    console.log('curRec', cuRec, this.displayTitle);
                    return {
                        ...cuRec, ...{
                            displayText: this.displayTitle ? cuRec.name : cuRec.description,
                            title: this.displayTitle && this.displayDescription ? '' : this.displayTitle ? cuRec.description : cuRec.name
                        }
                    };
                })
            } else {
                console.log(FLOW_LABEL);
                return filteredRecs.map(cuRec => {
                    return {
                        ...cuRec, ...{
                            Id : cuRec.ExternalId,
                            description : cuRec.Description,
                            displayText: this.displayTitle ? cuRec.Name : cuRec.Description,
                            title: this.displayTitle && this.displayDescription ? '' : this.displayTitle ? cuRec.Description : cuRec.Name
                        }
                    };
                })
            }
        } else {
            return [];
        }

    }

    showToast(event) {
        this.template.querySelector('c-toast-message').showCustomNotice(event);
    }

    changeSearchString(event) {
        this.searchString = event.detail.value;
        console.log('changeSearchString',this.searchString);
        if(this.searchString && this.searchString.length > 2) {
            executeNBAFlow({
                strategyName : this.strategyName,
                contextRecordId : this.recordId,
                searchString : this.searchString
            }).then(
                result => {
                    console.log('knowledge flow executeNBAFlow', result, this.maxRecommendations, this.strategyName, this.strategySource, this.displayTitle, this.displayDescription);
                    this.recommendations = {recommendations : result};
                }
            ).catch(
                error => {
                    console.error(error);
                }
            );
        } else {
            console.log('no changeSearchString');
            this.recommendations = null;
        }
    }
    
}