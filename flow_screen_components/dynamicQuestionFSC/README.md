# Dynamic Questions #

### A Flow Component solution 
### [Watch the video](https://youtu.be/KBcmWM9KEWc) ###

It’s now possible to create dynamic questions, where child questions appear and disappear based on the selection made in the parent question and you can do this without writing any code.

undefinedundefined
The implementation of dynamic questions takes advantage of Lightning Flow’s new ability, as of Spring ’18, to insert lightning components into flow screens. Using this, we’ve built a lightning component that produces dynamic questions upon request, and packaged it so that you can use it without touching code.
Here are the steps to using a dynamic question in your Flow

1. Make sure it’s installed in your org (and that your org is running Spring ’18 Salesforce)
2. Create your Parent Question
3. Configure your “Yes” child questions and your “No” child questions
4. Setup some output variables to hold the user’s answers

## Install this Component Into Your Org ##

[Installation instructions](/flow_screen_components/InstallScreenComponents.md)

## Define your Parent Question ##

Your parent question must be a Yes/No question. It will appear as a radio button field. Specify the text for your parent question by adding the Parent Question Text attribute on the Inputs tab.

Specify Your “Yes” Child Questions and your “No” Child Questions

If you want one or more child questions to appear when the user clicks “Yes” on the parent question, define them by adding a “Dynamic “Yes” Fields” attribute to the Inputs tab.

For the value, list the child fields you want in the order you want them to appear under the parent question. Use shortcut tags to specify the fields you want and separate them with spaces. This string, for example:

cb1 tf1 rb3

will cause a checkbox to appear, followed by a text field and a radio button.

Each dynamic question can use up to 16 child elements, split between the “Yes” children and the “No” children. The 16 available elements are:


Tag	Field Type
tf1	text field
tf2	text field
tf3	text field
tf4	text field
cb1	checkbox field
cb2	checkbox field
cb3	checkbox field
cb4	checkbox field
rb1	radio button group field
rb2	radio button group field
rb3	radio button group field
rb4	radio button group field
lb1	drop-down list box field
lb2	drop-down list box field
lb3	drop-down list box field
lb4	drop-down list box field



## Configure Your Child Fields ##

You configure these fields by adding additional attributes to the Input tab of the dynamic question. Note that these are not configurable by and have no relationship to any fields created the traditional way in Cloud Flow Designer.

For every field you add, you need to add the corresponding label attribute and provide a label.

Radio button groups and Listbox groups additionally require you to provide information on the choices that those controls should present to the user. These are set in attributes called Options Input String fields. Here you need to provide a string that encodes all of the label information and also specify the name of the variable that will store the choice selected  by the user. Here's an example of the format:

“I'm the label for the first radio button choice”:”first”, “I'm the second radio button. Pick me instead!”: “second”

## Map Your User Output Data ##


Once the user has encountered your dynamic question and filled out or selected choices in  the various fields, you'll want to capture those answers and use them downstream in your flow. Do this on the Output tab by adding the appropriate Output Value attributes and mapping them to flow variables.

## Resources ##

Watch the [video introduction](https://www.youtube.com/watch?v=KBcmWM9KEWc&feature=youtu.be).

Want to suggest an improvement or report a bug? Do that here.  (https://github.com/alexed1/LightningFlowComponents/issues)
undefined
Know a little javascript and want to add some improvements? Pull requests are welcome. (https://github.com/alexed1/LightningFlowComponents/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.





