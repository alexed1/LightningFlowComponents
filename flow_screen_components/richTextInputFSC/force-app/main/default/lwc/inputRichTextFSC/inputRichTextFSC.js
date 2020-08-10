import { LightningElement, api, track } from 'lwc';

export default class inputRichTextFSC_LWC extends LightningElement {

    //Input and Output Attributes for Flow
    @api value; //set empty in connectedCallback if undefined.
    @api disableAdvancedTools = false;
    @api disallowedWordsList;
    @api disallowedSymbolsList;
    @api autoReplaceMap;
    @api warnOnly = false;
    @api label;
    @api characterLimit;
    formats = ['font', 'size', 'bold', 'italic', 'underline',
        'strike', 'list', 'indent', 'align', 'link',
        'image', 'clean', 'table', 'header', 'color','background','code','code-block','script','blockquote','direction'];

    //Validation hook to use standard in Flow.  Only enforce if Advanced Tools are enabled
    @api validate(){
        if(!this.disableAdvancedTools){
            this.value = this.richText;
        }
        if(this.disableAdvancedTools || this.warnOnly){
            return {isValid:true};
        }else if(this.characterCap && (this.characterCount > this.characterLimit)){
            //failure scenario so set tempValue in sessionStorage
            sessionStorage.setItem('tempValue',this.value);
            return {
                isValid:false,
                errorMessage: 'Cannot Advance - Character Limit Exceeded: '+this.characterCount + ' > ' + this.characterLimit
            };
        }else if(!this.isValidCheck){
            //failure scenario so set tempValue in sessionStorage
            sessionStorage.setItem('tempValue',this.value);
            return {
                isValid:false,
                errorMessage: 'Cannot Advance - Invalid Symbols/Words Remain in Rich Text: '+this.runningBlockedInput.toString()
            };
        }else{
            return {isValid:true};
        }
    }

    //Other Variables
    @track richText; //use separate variable for richerText as value attribute is causing conflict
    @track disallowedWordsArray = [];
    @track disallowedWords;
    @track disallowedSymbolsArray = [];
    @track disallowedSymbols;
    @track searchTerm = '';
    @track replaceValue = '';
    @track interimValue = '';
    @track symbolsNotAllowed;
    @track wordsNotAllowed;
    @track oldRichText;
    @track dirty = false;
    @track autoReplaceEnabled = false;
    @track runningBlockedInput = [];
    @track searchButton = false;
    @track isValidCheck = true;
    @track errorMessage;
    @track characterCount = 0;
    @track characterCap = false;
    replaceMap = {};
    regTerm = '';
    applyTerm = '';
    instructions = '1)  Find and Replace:  Use Magnifying Glass, Enter Terms and Use Check Mark.  '+
                    '2)  Auto Replace:  If your Admin has configured it, Use Merge Icon to replace suggested terms.';

    //Begin functionality

    //Set initial values on load
    connectedCallback() {
		
        //use sessionStorage to fetch and restore latest value before validation failure.
        if(sessionStorage){
            if(sessionStorage.getItem('tempValue')){
                this.value = sessionStorage.getItem('tempValue');
                sessionStorage.removeItem('tempValue'); //clear value after selection
            }
        }

        if(!this.disableAdvancedTools){
            console.log('disableAdvancedTools is false, in connected callback');
			(this.value != undefined) ? this.richText = this.value : this.richText = '';
            this.characterCount = this.richText.length;
            if(this.disallowedSymbolsList != undefined){
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
            if(this.characterLimit > 0){
                this.characterCap = true;
            }
        }
    }
	
	//Handle updates to Rich Text field with no enhanced features
    handleValueChange(event) {
        this.value = event.target.value;
    }

    //Handle updates to Rich Text field with enhanced features
    handleTextChange(event) {
        this.runningBlockedInput = [];
        this.isValidCheck = true;
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
                    this.isValidCheck = false;
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
                    this.isValidCheck = false;
                } else {
                    this.richText = event.target.value;
                }
            }
        } else {
            this.isValidCheck = true;
            this.richText = event.target.value;
        }
        this.characterCount = this.richText.length;
        if(this.characterCap && this.characterCount > this.characterLimit){
            this.isValidCheck = false;
        }
        //Display different message if warn only - validation also won't be enforced on Next.
        if(this.characterCap && this.characterCount > this.characterLimit){
            this.errorMessage = 'Error - Character Limit Exceeded';
        }else if(!this.warnOnly){
            this.errorMessage = 'Error - Invalid Symbols/Words found: '+this.runningBlockedInput.toString();
        }else{
            this.errorMessage = 'Warning - Invalid Symbols/Words found: '+this.runningBlockedInput.toString();
        }
        
    }

    //Set css on Character count if passing character limit
    get charClass(){
        return (this.characterLimit < this.characterCount ? 'warning' : '');
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