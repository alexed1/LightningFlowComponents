import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RicherTextFSC extends LightningElement {

    //Input and Output Attributes for Flow
    @api value;
    @api enableAdvancedTools = false;
    @api disallowedWordsList;
    @api disallowedSymbolsList;
    @api autoReplaceMap;
    @api warnOnly = false;
    @api label;
    formats = ['font', 'size', 'bold', 'italic', 'underline',
        'strike', 'list', 'indent', 'align', 'link',
        'image', 'clean', 'table', 'header', 'color','background','code','code-block','script','blockquote','direction'];

    //Validation hook to use standard in Flow.  Only enforce if 
    @api validate(){
        this.value = this.richText;
        if(!this.enableAdvancedTools || this.warnOnly || (!this.warnOnly && !this.runningBlockedInput.length>0)){
            return {isValid:true};
        }else{
            return {
                isValid:false,
                errorMessage: 'Cannot Advance - Invalid Symbols/Words Remain in Rich Text: '+this.runningBlockedInput.toString()
            };
        }
    }

    //Other Variables
    @track richText; //use separate variable for enhanced features as value attribute is causing conflict
    @track disallowedWordsArray = [];
    @track disallowedWords;
    @track disallowedWordsMessage;
    @track disallowedSymbolsArray = [];
    @track disallowedSymbols;
    @track disallowedSymbolsMessage;
    @track searchTerm = '';
    @track replaceValue = '';
    @track interimValue = '';
    @track symbolsNotAllowed;
    @track wordsNotAllowed;
    @track oldRichText;
    @track dirty = false;
    @track autoReplaceEnabled = false;
    @track disallowedType = 'error';
    @track disallowedMode = 'sticky';
    @track runningBlockedInput = [];
    @track searchButton = false;
    replaceMap = {};
    regTerm = '';
    applyTerm = '';
    symbolTitle = 'Invalid Symbols';
    wordTitle = 'Invalid Words';
    instructions = '1)  Find and Replace:  Use Magnifying Glass, Enter Terms and Use Check Mark.  '+
                    '2)  Auto Replace:  If your Admin has configured it, Use Merge Icon to replace suggested terms.';

    //Begin functionality

    //Set initial values on load
    connectedCallback() {
        if(this.enableAdvancedTools){
            this.richText = this.value;
            if(this.disallowedSymbolsList != undefined){
                this.disallowedSymbolsMessage = 'Do Not Use the Following Symbols: '+this.disallowedSymbolsList;
                this.disallowedSymbolsArray = this.disallowedSymbolsList.replace(/\s/g,'').split(',');
                for(let i=0; i<this.disallowedSymbolsArray.length; i++){
                    if(i == 0){
                        if(this.disallowedSymbolsArray.length != 1){
                            this.disallowedSymbols = '['+ this.disallowedSymbolsArray[i] + '|';
                        }else{
                            this.disallowedSymbols = '['+ this.disallowedSymbolsArray[i] + ']';
                        }
                    } else if (i == (this.disallowedSymbolsArray.length - 1)){
                        this.disallowedSymbols = this.disallowedSymbols.concat(this.disallowedSymbolsArray[i] + ']');
                    } else {
                        this.disallowedSymbols = this.disallowedSymbols.concat(this.disallowedSymbolsArray[i] + '|');
                    }
                }
            }
    
            if(this.disallowedWordsList != undefined){
                this.disallowedWordsMessage = 'Do Not Use the Following Words: '+this.disallowedWordsList;
                this.disallowedWordsArray = this.disallowedWordsList.replace(/\s/g,'').split(',');
                for(let i=0; i<this.disallowedWordsArray.length; i++){
                    if(i == 0){
                        if(this.disallowedWordsArray.length != 1){
                            this.disallowedWords = '('+this.disallowedWordsArray[i] + '|';
                        }else{
                            this.disallowedWords = '('+this.disallowedWordsArray[i] + ')\b';
                        }
                    } else if (i == (this.disallowedWordsArray.length - 1)){
                        this.disallowedWords = this.disallowedWords.concat(this.disallowedWordsArray[i] + ')\\b');
                    } else {
                        this.disallowedWords = this.disallowedWords.concat(this.disallowedWordsArray[i] + '|');
                    }
                }
            }
            if(this.disallowedSymbols != undefined) this.symbolsNotAllowed = new RegExp(this.disallowedSymbols,'g');
            if(this.disallowedWords != undefined) this.wordsNotAllowed = new RegExp(this.disallowedWords,'g');
            if(this.autoReplaceMap != undefined){
                this.replaceMap = JSON.parse(this.autoReplaceMap);
                this.autoReplaceEnabled = true;
            } 
            //if warn only is set, then change toast type/mode
            if(this.warnOnly){
                this.disallowedType = 'warning';
                this.disallowedMode = 'dismissable';
            }
        }
    }

    //Handle updates to Rich Text field
    handleTextChange(event) {
        this.runningBlockedInput = [];
        if (this.symbolsNotAllowed != undefined || this.wordsNotAllowed != undefined) {
            this.interimValue = (event.target.value).toLowerCase();
            this.interimValue = this.interimValue.replace(/(<([^>]+)>)/ig, "");
            
            //Symbol check section
            if (this.symbolsNotAllowed != undefined) {
                let matchesSymbol = this.interimValue.match(this.symbolsNotAllowed);
                if (matchesSymbol != null && matchesSymbol.length > 0) {
                    for(let i = 0; i < matchesSymbol.length; i++){
                        this.runningBlockedInput.push(matchesSymbol[i]);
                    }
                    const evt = new ShowToastEvent({
                        title: this.symbolTitle,
                        message: this.disallowedSymbolsMessage,
                        variant: this.disallowedType,
                        mode: this.disallowedMode
                    });
                    this.dispatchEvent(evt);
                } else {
                    this.richText = event.target.value;
                }
            }

            if (this.wordsNotAllowed != undefined) {
                let matchesWords = this.interimValue.match(this.wordsNotAllowed);
                if (matchesWords != null && matchesWords.length > 0) {
                    for(let i = 0; i < matchesWords.length; i++){
                        this.runningBlockedInput.push(matchesWords[i]);
                    }
                    const evt = new ShowToastEvent({
                        title: this.wordTitle,
                        message: this.disallowedWordsMessage,
                        variant: this.disallowedType,
                        mode: this.disallowedMode
                    });
                    this.dispatchEvent(evt);
                } else {
                    this.richText = event.target.value;
                }
            }
        } else {
            this.richText = event.target.value;
        }
    }

    //Handle initiation of Search and Replace
    handleOpenSearch(event) {
        this.searchButton = !this.searchButton;
    }

    //Search and Replace Search for Value
    handleSearchChange(event) {
        this.searchTerm = (event.target.value).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    //Search and Replace Replace with Value
    handleReplaceChange(event) {
        this.replaceValue = (event.target.value).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    //Execute Search and REplace
    searchReplace() {
        this.oldRichText = this.richText;
        this.dirty = true;
        let draftValue = this.richText;
        this.searchTerm = this.escapeRegExp(this.searchTerm);
        this.replaceValue = this.escapeRegExp(this.replaceValue);
        draftValue = this.replaceAll(draftValue, this.searchTerm, this.replaceValue);
        this.richText = draftValue;
    }

    //Execute Auto-Replacement based on map.
    applySuggested(event) {
        this.oldRichText = this.richText;
        this.dirty = true;
        let draftValue = this.richText;
        let regTerm = '';
        for (var key in this.replaceMap) {
            this.applyTerm = this.replaceMap[key];
            this.regTerm = key;
            draftValue = this.replaceAll(draftValue, this.regTerm, this.applyTerm);
        }
        this.richText = draftValue;
    }

    //Replace All function helper
    replaceAll(str, term, replacement) {
        return str.replace(new RegExp(term, 'ig'), replacement);
    }

    //Undo last change
    handleRevert() {
        this.richText = this.oldRichText;
        this.dirty = false;
    }

    //Clean input for RegExp
    escapeRegExp(str) {
        return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

}