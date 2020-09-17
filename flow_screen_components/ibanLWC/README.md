# IBAN Validation

This component validates and formats the input of international bank account numbers ([IBAN](https://en.wikipedia.org/wiki/International_Bank_Account_Number)) which is mandatory in the European economic area and was also adopted by many other countries.

![image](https://user-images.githubusercontent.com/8611608/92599021-f4e0f600-f2a9-11ea-8d28-e7e07299da03.png)

Submitted by BrighterCloud GmbH Mannheim, Germany.

[![image](https://user-images.githubusercontent.com/8611608/92599094-0a562000-f2aa-11ea-90e9-8fda8375f097.png)](https://brighter.cloud/)

## Usage

You can use this component in your flows or in code by connecting to the "value" attribute:
```
<c-iban-component value="DE12345678901234567890"></c-iban-component>
```

## IBAN Validation
For the IBAN validation this component uses https://github.com/arhs/iban.js
