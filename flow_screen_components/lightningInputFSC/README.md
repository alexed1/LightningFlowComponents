# Lightning Input
This is a a Flow-optimized version of the [Lightning Input](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_input.htm) component, which includes the following input types:

checkbox | checkbox-button | color | date | datetime-local | email | month | number | password | radio | range | tel | time | toggle | url | week

## How It Works ##

The component has two required attributs: `type` (possible values noted above) and `label`, which must be set in the Flow. There are also several type-specific attributes and validation attributes available ([see here for full documentation]((https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_input.htm)))

A `value` attribute captures the user's input and can be used to set a Flow variable.

For checkboxes and radio buttons, setting the "Group Name" attribute in the Flow will tie the buttons together.

## Attributes and Examples by Type

* type: "checkbox"
   * label: "Red" 
   * checked: "true"

* type: "checkbox"
   * label: "Blue" 

* type: "checkbox"
   * label: "Add pepperoni" 
   * checked: "true" 
   * value: "pepperoni" 

* type: "checkbox-button" 
  * label: "Add salami" 
  * value: "salami" 

* type: "color"
   * label: "Color" 
   * value: "#EEEEEE"

* type: "date"
   * label: "Birthday" 

* type: "datetime-local" 
  * label: "Birthday" 

* type: "email"
   * label: "Email" 
   * value: "abc@domain.com" 

* type: "month"
   * label: "Birthday" 

* type: "number"
   * label: "Number" 
   * value: "12345"

* type: "number"
   * label: "Enter a number" 

* type: "number"
   * label: "Enter a decimal value" 
   * step: "0.001"

* type: "number"
   * label: "Enter a percentage value" 
   * formatter: "percent" 
   * step: "0.01" 

* type: "number"
   * label: "Enter a dollar amount" 
   * formatter: "currency" 
   * step: "0.01" 

* type: "password"
   * label: "Password" 

* type: "radio"
   * label: "Red" 
   * value: "red" 
   * checked: "true" 

* type: "radio"
   * label: "Blue" 
   * value: "blue" 

* Radio Group
  * type: "radio"
    * label: "Red" 
    * group name: "color" 
    * value: "red" 
    * checked: "true" 

  * type: "radio"
    * label: "Blue" 
    * group name: "color" 
    * value: "blue" 


* type: "range"
   * label: "Number" 
   * min: "0" 
   * max: "10"

* type: "tel"
   * label: "Telephone" 
   * value: "343-343-3434" 
   * pattern: "[0-9]{3}-[0-9]{3}-[0-9]{4}"

* type: "time"
   * label: "Time" 

* type: "toggle"
   * label: "Toggle value" 
   * checked: "true" 

* type: "url"
   * label: "Website" 

* type: "week"
   * label: "Week" 

## Custom Validation Parameters and Messages

### The following validations can be set in the Flow to show default or custom messages:
 max | maxlength | min | minlength | required | pattern

#### pattern usage
For type `tel` the pattern  [0-9]{3}-[0-9]{3}-[0-9]{4} allows '415-555-1212', but shows an error message for '33-555-1212'.

To require a two digit country code, e.g., 01-678-910-1234, the pattern [0-9]{2}-[0-9]{3}-[0-9]{3}-[0-9]{4} could be used.

### The following attributes can be set in the Flow to display custom validation messages:
msg: Toggle Active | msg: Toggle Inactive | err: Bad Input | err: Pattern Mismatch | err: Range Overflow | err: Range Underflow | err: Step Mismatch | err: Too Long | err: Type Mismatch | err: Value Missing | 
  
#### By default the following messages are displayed when a validation set has failed.
* badInput: Enter a valid value.
* patternMismatch: Your entry does not match the allowed pattern.
* rangeOverflow: The number is too high.
* rangeUnderflow: The number is too low.
* stepMismatch: Your entry isn't a valid increment.
* tooLong: Your entry is too long.
* typeMismatch: You have entered an invalid format.
* valueMissing: Complete this field.

#### These default messages can be overridden by setting the following attributes in the flow.
* messageWhenBadInput
* messageWhenPatternMismatch
* messageWhenRangeOverflow
* messageWhenRangeUnderflow
* messageWhenStepMismatch
* messageWhenTooLong
* messageWhenTypeMismatch
* messageWhenValueMissing

#### The following attributes control the text displayed beneath the `toggle` input in each of its states:
* messageToggleActive
* messageToggleInactive


## Formatter
#### formatter usage
The `formatter` attribute can be set to the following for number input fields.
 * percent 
 * percent-fixed 
 * currency