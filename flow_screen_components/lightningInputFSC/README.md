# Lightning Input
This is a port of the [Lightning Input](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_input.htm) component, which includes the following input types:

checkbox | checkbox-button | color | date | datetime-local | email | month | number | password | radio | range | tel | time | toggle | url | week

## How It Works ##

The component has two required attributes: `type` (possible values noted above) and `label`, which must be set in the Flow. There are also several type-specific attributes and validation attributes available ([see here for full documentation]((https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_input.htm)))

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
formatter | max | maxlength | min | minlength | required 

### The following attributes can be set in the Flow to display custom validation messages:
msg: Toggle Active | msg: Toggle Inactive | err: Bad Input | err: Pattern Mismatch | err: Range Overflow | err: Range Underflow | err: Step Mismatch | err: Too Long | err: Type Mismatch | err: Value Missing | 


