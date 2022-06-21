import { LightningElement, api, track } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";

const SESSION_STORAGE_KEY = "text-area-plus-temp-text";

// List of special characters to RTF characters
// Required for escaping search text
// If you find a new one, add it here
const rtfEscapeChars = [
  {char: '&', text: '&amp;'}, // DO THIS FIRST! Trust me
  {char: '<', text: '&lt;'},
  {char: '>', text: '&gt;'},
];

// Used for search and replace temp highlight
// mapping of highlight style to left tag (lt) and right tag (rt)
const hlStyles = {
  bright: {lt: `<span style="background-color:#ffd500">`, rt: '</span>'},
  mid: {lt: `<span style="background-color:#fff2b2">`, rt: '</span>'},
  none: {lt: '', rt: ''}
};

// timing for animation of highlights
const hlTimers = [
  {style: 'mid', ms: 0},
  {style: 'bright', ms: 75}, // main highlight - bright
  {style: 'mid', ms: 525}, // start fading out for 75ms
  {style: 'none', ms: 600} // reset to text without highlight html
];

// All possible options as of SP22
// Valid rich text formats
const validFormats = ['font','size','bold','italic','underline','strike','list','indent','align',
'link','image','clean','table','header','color','background',
'code','code-block','script','blockquote','direction'];

// Convert CB values to a boolean
function cbToBool(value) {
  return value === "CB_TRUE";
}

export default class TextAreaPlus extends LightningElement {
  // Flow inputs
  @api autoReplaceMap;
  @api counterTextTemplate;
  @api disallowedSymbolsList;
  @api disallowedWordsList;
  @api label;
  @api placeHolder;
  @api textMode;

  // Component facing props
  @track runningBlockedInput = [];
  @track undoStack = [];
  @track escapedVals = {searchTerm: '', replaceValue: ''};

  _charsLeftTemplate = '$L/$M Characters'; // Must match CPE.js default setting
  searchButton = false;
  textValue;
  autoReplaceEnabled = false;
  disallowedSymbolsRegex;
  disallowedWordsRegex;
  errorMessage;
  isValidCheck = true;
  maxLength;
  minLength;
  ignoreCase = true;
  animating = false;
  hlText;
  replaceMap = {};
  formats = validFormats;

  // If either search or autoreplace is enabled, allow case insensitive
  get showCaseInsensitive() {
    return this.searchButton || this.autoReplaceEnabled;
  }

  // This is not a Daft Punk song
  get dirty() {
    return this.undoStack.length > 0;
  }

  // Show help text appropriately based on whether Suggested Terms is enabled
  get caseInsensitiveHelpText() {
    return `${this.showCaseInsensitive ? 'Ignore Case for Search and Replace' : ''}
            ${this.autoReplaceEnabled ? ' and Suggested Terms' : ''}`;
  }

  get ignoreCaseVariant() {
    return this.ignoreCase ? "brand" : "neutral";
  }

  get applyAltText() {
    try {
      const prettyMap = Object.keys(this.replaceMap)
        ?.map(x => `${x} -> ${this.replaceMap?.[x]}`)
        ?.join(',');
      return `Apply Suggested Terms (${prettyMap})`;
    } catch (e) {
      return 'Apply Suggested Terms';
    }
  }

  // based on whether ignore case is selected, use the modifier
  get regexMod() {
    return this.ignoreCase ? "gi" : "g";
  }

  get counterText() {
    // base case - template is blank
    if (!this._charsLeftTemplate) {
      return '';
    }

    return this._charsLeftTemplate
      ?.replaceAll('$R', this.charsLeft)
      ?.replaceAll('$M', this.maxLength)
      ?.replaceAll('$L', this.len)
  }

  get plainText() {
    return this.textMode === "plain";
  }

  get showCounter() {
    return this.maxLength && this.maxLength > 0;
  }

  @api
  get advancedTools() {
    // advanced tools can only be explained for rich text
    return !this.plainText && cbToBool(this.cb_advancedTools);
  }
  @api cb_advancedTools;

  @api
  get warnOnly() {
    return cbToBool(this.cb_warnOnly);
  }
  @api cb_warnOnly;

  @api
  get required() {
    return cbToBool(this.cb_required);
  }
  @api cb_required;

  @api
  get showCharCounter() {
    return cbToBool(this.cb_showCharCounter);
  }
  @api cb_showCharCounter;

  @api
  get maxlen() {
    return this.maxLength;
  }
  set maxlen(value) {
    if (!Number.isNaN(value)) {
      this.maxLength = Number(value);
    };
  }

  @api
  get minlen() {
    return this.minLength;
  }
  set minlen(value) {
    if (!Number.isNaN(value)) {
      this.minLength = Number(value);
    };
  }

  @api
  get value() {
    return this.textValue;
  }
  set value(val) {
    this.textValue = val;
  }

  @api
  get charsLeftTemplate() {
    return this._charsLeftTemplate;
  }
  set charsLeftTemplate(value) {
    if (value && value.trim().length > 0) {
      this._charsLeftTemplate = value;
    }
  }

  getFailObject(errors) {
    // Create a bulleted error message list with line breaks
    const errorMessage = `Validation Failed, please correct the following issues:
                  ${errors.map(x => `· ${x}`).join('\r\n')}`;
    return {
      isValid: false,
      errorMessage
    };
  }

  @api validate() {
    // whatever the text is, store it in the session
    this.storeValue();
    this.value = this.textValue;
    const errors = [];

    // Case 1 - required has been checked, but there's not text
    if (this.required === true && this.len <= 0) {
      errors.push('Field is Required');
    }

    // Case 2 - characters are below minimum length required
    if (this.minlen > 0 && this.len < this.minlen) {
      errors.push(`Minimum length of ${this.minlen} characters is required.`);
    }

    // Case 3, char counter is enabled, but remaining characters is negative
    // This can happen with rich text when too much text is pasted
    if (this.showCharCounter && this.charsLeft < 0) {
      errors.push('Character Limit Exceeded.');
    }

    // these errors take precedence over warn only, return them now
    if (errors.length > 0) {
      return this.getFailObject(errors);
    }

    // If advanced tools haven't been enabled
    // Or advanced tools is enabled with warn only, we're done
    if (!this.advancedTools || this.warnOnly) {
      return { isValid: true };
    }

    // Case 3: Advanced tools only, invalid words have been used
    if (this.runningBlockedInput.length > 0) {
      errors.push(`Invalid Symbols/Words: ${this.runningBlockedInput.join(', ')}`);
    }

    if (errors.length > 0) {
      return this.getFailObject(errors);
    }

    // If we're here, it's valid
    return { isValid: true };

  }

  // Helper for removing html tags for accurate rich text length count
  stripHtml(str) {
    if (this.plainText) {
      return str;
    } else {
      // Switch all the HTML safe text back to characters for accurate length
      str = str?.replace( /(<([^>]+)>)/g, '');
      return this.unescapeRichText(str);
    }
  }

  connectedCallback() {
    this.popStoredValue();
    if (this.advancedTools) {
      // Use value from session, or blank
      this.textValue = this.value || '';
      // Build regex for disallowed symbols and words (if listed)
      // This will pass in a function to format the regex correctly by type
      this.setRegex('Symbols', x => `\\${x}`);
      this.setRegex('Words', x => `\\b${x}\\b`);

      if (this.autoReplaceMap != undefined) {
          this.replaceMap = JSON.parse(this.autoReplaceMap);
          this.autoReplaceEnabled = true;
      }
    }
  }

  // Helper to convert comma delimited list of words or symbols to pipe delimited regular expression
  setRegex(type, fn) {
    const list = this[`disallowed${type}List`];
    if (list?.length > 0) {
      const pipedList = list
        .replace(/\s/g, "")
        .split(",")
        .map(fn) // Used the passed in function to create the regex
        .join('|');
      this[`disallowed${type}Regex`] = new RegExp(pipedList, this.regexMod);
    }
  }

  // Dynamically calculate the length of text
  get len() {
    // for plain text, just return the length
    // for rich text, strip the HTML
    return this.stripHtml(this.textValue)?.length || 0;
  }

  // Dynamically calculate remaining characters
  get charsLeft() {
    const tlen = this.len;
    return (
      this.maxLength - (tlen >= 0 ? tlen : 0)
    );
  }

  // Set the class based on rich text vs plain text, and number of chars left
  get charsLeftClass() {
    const padding = this.plainText ?
      'slds-var-p-top_xxx-small slds-var-p-left_x-small' :
      'slds-var-p-left_x-small slds-var-p-right_xxx-small slds-var-p-top_x-small slds-var-p-bottom_xxx-small';
    return `${padding} ${
      this.charsLeft > 0 ? "default" : "warning"
    }`;
  }

  handleIgnoreCaseToggle() {
    this.ignoreCase = !this.ignoreCase;
  }

  // Common text value updater for Plan or Rich text
  updateText(value) {
    this.textValue = value;
    // required for Flow
    const attributeChangeEvent = new FlowAttributeChangeEvent(
      "value",
      this.textValue
    );
    this.dispatchEvent(attributeChangeEvent);
  }

  // Event handler for plain text change
  handleChange({ detail }) {
    this.updateText(detail.value);
  }

  //Handle updates to Rich Text field
  handleTextChange({target}) {
    this.updateText(target.value);
    this.isValidCheck = true;

    // We're done if advanced tools aren't enabled
    if (!this.advancedTools) {
      return;
    }

    // minimum length takes precedence over disallowed words
    if (this.minlen > 0 && this.len < this.minlen) {
      this.isValidCheck = false;
      // Will display on Rich Text.  TextArea is covered by min-length property
      this.errorMessage = `Minimum length of ${this.minlen} characters required`
      return;
    }

    this.runningBlockedInput = [];
    // base case, there are no disallowed symbols or words
    if (!this.disallowedSymbolsRegex && !this.disallowedWordsRegex) {
      this.isValidCheck = true;
      return;
    }

    if (this.hasBlockedItems(target.value)) {
      this.isValidCheck = false;
    }

    // Check invalid symbols and words
    const rbi = this.runningBlockedInput;
    this.errorMessage = rbi.length > 0 ? `Error - Invalid Symbols/Words: ${rbi.join(', ')}` : null;
  }

  handleRichTextKeyDown(event) {
    // Allow backspace (8), delete (46), home (36), end (35), arrows (37-40), control/cmd (17)
    const keys = [8,46,17,18,35,36,37,38,39,40,46];
    // Allow Control-a (65), Control-c (67), Control-x (88) so user can delete and stuff, but not type new characters or paste more junk
    const ctlKeys = [65,67,88];
    const validKey = ({ctrlKey, keyCode}) => keys.includes(keyCode) || ctrlKey && ctlKeys.includes(keyCode);
    if (this.showCounter && this.charsLeft <= 0 && !validKey(event)) {
      event.preventDefault();
    }
  }

  hasBlockedItems(text) {
    let hasEm = false;
    text = this.stripHtml(text);

    // Create a list of disallowed words/symbols that actually contain elements.
    // Anything empty will be removed
    const naughtyLists = [this.disallowedWordsRegex, this.disallowedSymbolsRegex]
      .filter(x => !!x);

    // Update runningBlockedInput
    for (const rx of naughtyLists) {
      const matches = text.match(rx);
      if (matches?.length > 0) {
        this.addBlockedItems(matches);
        hasEm = true;
        // do not try to be fancy and return or break here, or all items won't be added!!!
        // this must run for BOTH regexes in the array
      }
    }

    return hasEm;
  }

  // Create a unique list of items, add any that aren't already in the blocked list
  addBlockedItems(items) {
    items = items.map(w => w.toLowerCase());
    this.runningBlockedInput = Array.from(new Set([...this.runningBlockedInput,...items]));
  }

  // Helper function to build text for search replace with
  // different highlight styles and store it on the highlight map object
  setReplaceText(hl, prop, text, term, value) {
    // Creates highlight HTML (e.g. bright, mid) with the left and right tags (lt/rt)
    this.hlText[prop] = text?.replaceAll(term,`${hl.lt}${value}${hl.rt}`);
  }

  // push text value on to the undo stack *only* if it is different than the last item on the stack
  addUndo() {
    if (this.undoStack.length == 0 || this.undoStack[this.undoStack.length -1] !== this.textValue) {
      this.undoStack.push(this.textValue);
    }
  }

  //Handle initiation of Search and Replace
  handleOpenSearch(event) {
    this.searchButton = !this.searchButton;
  }

  // Kick off search/replace if enter is pressed
  handleSearchKeyDown({keyCode}) {
    if (keyCode === 13) {
      this.handleSearchReplace();
    }
  }

  //Search and Replace Search for Value
  handleSearchReplaceChange({target}) {
    //TODO: Fix infinite loop, block invalid chars @ keypress
    const filteredValue = this.escapeRegExp(target.value);
    const targetValue = target.dataset.id === 'search' ? 'searchTerm' : 'replaceValue';
    this.escapedVals[targetValue] = filteredValue;
  }

  //Execute Search and REplace
  handleSearchReplace() {
    if (this.escapedVals.searchTerm === '') {
      // An empty string will add the replacement value between every character!
      // This could cause exponential growth of the text with each click, so let's just not do that.
      return;
    }

    this.addUndo();

    const term = new RegExp(this.escapedVals.searchTerm, this.regexMod);
    const value = this.escapedVals.replaceValue;

    // Store the text in three forms:
    // no highlight (none), bright highlight (bright), and mid-level highlight (mid)
    this.hlText = {};
    for (const prop in hlStyles) {
      this.setReplaceText(hlStyles[prop], prop, this.textValue, term, value);
    }

    // Flash highlight
    this.animateHighlight();
  }

  // pseudo animated flash highlight of replacement text
  // Use array of animation timing to flash, then remove highlight
  animateHighlight() {
    // By passing the second parameter, animate, the search and autoreplace buttons will be disabled during
    // animation.  The last item will return false, which will re-enable the buttons.
    hlTimers.forEach((timer, ix) => this.setHighlightTimer(timer, ix < hlTimers.length - 1));
  }

  // Sets a future highlight change
  setHighlightTimer({style, ms}, animate) {
    setTimeout(() => {
      this.animating = animate;
      this.textValue = this.hlText[style];
    }, ms);
  }

  //Execute Auto-Replacement based on map.
  applySuggested(event) {
    this.addUndo();
    // Reset all text values in the highlight map
    // so highlights will work correctly
    this.hlText = {};
    for (const term in this.replaceMap) {
      for (const prop in hlStyles) {
        const rex = new RegExp(term, this.regexMod);
        const text = this.hlText[prop] || this.textValue;
        const value = this.replaceMap[term];
        this.setReplaceText(hlStyles[prop], prop, text, rex, value);
      }
    }
    // Animate highlights
    this.animateHighlight();
  }

  //Undo last change
  handleRevert() {
    this.textValue = this.undoStack.pop();
  }

  //Clean input for RegExp and matching rich text
  escapeRegExp(str) {
    if (str) {
    rtfEscapeChars.forEach(({char,text}) => {
      str = str.replaceAll(char,text);
    });
    str = str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }
    return str;
  }

  // The opposite of escaping RTF for accurate char count
  unescapeRichText(str) {
    if (str) {
    // go in reverse order, starting with &amp;
    const rtfUnescape = [...rtfEscapeChars].reverse();
    rtfUnescape.forEach(x => {
      str = str.replaceAll(x.text, x.char);
    });
  }
    return str;
  }

  popStoredValue() {
    // Text values should be on the session storage in case validation fails
    // pop from the stack of values in order
    const tmpArr = this.sessionArray;
    if (tmpArr.length > 0) {
      this.value = tmpArr.shift();
      if (tmpArr.length > 0) {
        sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(tmpArr));
      } else {
        sessionStorage.removeItem(SESSION_STORAGE_KEY); //clear value after selection
      }
    }
  }

  storeValue() {
    let tmpArr = this.sessionArray;
    tmpArr.push(this.value);
    sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(tmpArr));
  }

  // return a valid array, otherwise, remove session storage
  get sessionArray() {
    const tmpArrStr = sessionStorage?.getItem(SESSION_STORAGE_KEY);
    let tmpArr;
    if (tmpArrStr) {
      try {
        tmpArr = JSON.parse(tmpArrStr);
        if (Array.isArray(tmpArr)) {
          // This is valid - return the deserialized array
          return tmpArr;
        }
      } catch (e) {
        console.log('error parsing session info')
      }
    }
    sessionStorage.removeItem(SESSION_STORAGE_KEY);
    return [];
  }

}
