# **Customizable Header/Banner LWC**

In need of making your flows looks more like a Salesforce Standard Page Layout? OR Simply want to display customizable headers with icons, text, links, etc. in communities, home/record pages? Use this lightning web component which allows you to display customizable headers anywhere on Salesforce platform.


**What Features does this component have?**

1. Full control over text-color, font, background-color, section border, text alignment, etc.
2. Ability to display text (with/without) icon
3. Ability to use Lightning-icons or custom image stored as a static resource
4. Display hyperlink
5. Use as a Line/Page Break
6. Ability to use the same component multiple times in a screen to ensure consistency or to get variety
7. and more.....

**Where can I use it?**

 The Customizable Header/Banner works with-

1. App Page
2. Home Page
3. Record Page
4. Flows
5. Communities

**Anything I should keep in mind while setting up/using this component?**

1. To use image from static resource
  1. Check to see if there exists a static resource by the name of &#39;customHeaderImages&#39;. If yes, Skip step 2.
  2. Create a static resource by the name- customHeaderImages, set Cache Control to &#39;Public&#39;
  3. Create a zip file with the name as &#39;customHeaderImages&#39; containing your desired images. Upload the zip file to above Static Resource
  4. When setting up the LWC, enter image name and check &#39;is Image a Static Resource?&#39; to true. Additionally, select either of the options to display image and text
  5. NOTE: Make sure that you are not compressing a folder when zipping the images. Only select the image(s) you want to use and NOT the folder in which those images are.
2. Avoid any and all typos.
3. In terms of preference (if more than one option is selected)- &#39;Is header text only?&#39; \&gt; &#39;Header has text (left aligned) and image (right aligned)&#39; \&gt; &#39;Header has image and text (with image on left of text)&#39;
4. Image name accepts static resource as well as Lightning icon. For more information on lightning icons, visit- [https://www.lightningdesignsystem.com/icons](https://www.lightningdesignsystem.com/icons/#utility)

| **Input Variable** | **Description** | **Default/Sample Value** | **Notes** |
| --- | --- | --- | --- |
| Display for Record Id? | Only appears on record page. To show the banner for a particular record, update the field value with recordId (from URL). Else, leave it blank to display the banner for all records. |
| Display Mode | Horizontal Line, Text Only, Image on Left and Text on Right, Text on Left and Image on Right | Horizontal Line | If selected it gets the highest priority and the header is displayed as a horizontal line. Once selected, control the display using Banner Height and Banner Background-color fields |
| Banner Text | Text to display inside of the banner | Banner Text Goes Here | Does not show up if the Display Mode is set to Horizontal Line |
| Banner Text Alignment | Use to align the banner text. Valid inputs: left, center, right | center |
| Display text as hyperlink? | Check when the text is a link to a webpage,article,etc. | FALSE | Once selected, be sure to fill out the URL to redirect field with a valid URL |
| URL to redirect | Enter a valid url for the user to be redirected to when the text is displayed as a hyperlink | https://www.google.com |
| Remove text-decoration for the link? | Check when displaying the text as URL and you want to remove the text-decoration, ex-underline under the hyperlink. | FALSE |
| Open link in new window? | Check when displaying the text as URL and you want the link to open in a new window | FALSE |
| Order Number | When using this component more than once on the same screen, be sure to provide a unique order number to each of the component to ensure that styling(CSS) from one component does not interfere with that of the other. Example, when using the component twice on a screen, give one component an order number of 1 and the other as 2. |
| Image Name | When displaying image along with text, use this field to provide the image name. To use a lightning icon, enter name as &#39;utility:add&#39; or &#39;custom:custom1&#39;. To use image from static resource, follow step#1 above and create a static resource. Once created, simply provide the static resource image name WITH EXTENSION- example: smiley.png | utility:add | When using a static resource, provide image name with extension- example: smiley.png |
| Is image a Lightning Icon? | Check when using a lightning icon. | FALSE | Gets priority over- &#39;Is image a static resource&#39; if both are selected |
| Lightning Icon Size | Valid inputs: xx-small, x-small, small, medium, or large. | medium |
| Icon Margin | Provide margin to include space between icon and text-useful when the icon is left aligned and text follows the icon | 0px 7px 0px 0px |
| Is image a static resource? | Check if the image to be displayed is a static resource | FALSE |
| Static Resource Image Width | Define width for static resource- ex- 30 | 30 |
| Static Resource Image Height | Define height for static resource- ex- 30 | 30 |
| Banner Height | Use to define banner height in px. Also controls the banner thickness when using as a page break | 10 |
| Banner Background Color | To define banner background color, use any- #hexcode or RGB(0, 0, 0) or color name like red | rgb(243, 242, 242) |
| Banner Text Font Size | Valid inputs: xx-small, x-small, small, medium, or large. | medium |
| Banner Text Font Style | Font Style | Arial |
| Banner Margin | Margin | 5px 5px 5px 5px |
| Banner Padding | Padding | 5px 5px 5px 5px |
| Banner Border | When wanting to have the banner border radius, include width, style (required) and color, example- 0px 0px 5px 0px dotted red; | 5px dotted green |
| Bold | If checked, makes the banner text bold | FALSE |
| Italicize | If checked, renders the banner text in italics | FALSE |
| Underline | If checked, underlines the banner text | FALSE |

**When using inside a Flow-**
![Screen Shot 2022-06-08 at 9 52 46 AM](https://user-images.githubusercontent.com/17482257/174900315-0d2b3185-d80a-4f22-9aa4-76ff4372006a.png)
**Static Resource Setup-**
![Screen Shot 2020-08-27 at 7 48 53 PM](https://user-images.githubusercontent.com/17482257/174900355-f83ed7cb-7ee8-427c-84b8-4890393c3415.png)

**When using within a community, record/home page-**
![Screen Shot 2020-08-27 at 7 52 35 PM](https://user-images.githubusercontent.com/17482257/174900374-919e7730-6caf-45a3-a601-d72480deed8c.png)

**Where do I provide suggestions or reach out for help?**
 Leave a review comment on the app exchange listing

 Built by: Sharad Chandra Maheshwari

**Component in Action** -
**#1 Use as section headers**
Scenario- Users have always wanted their flow screens to resemble like Standard Salesforce page layouts. Use Case: Lightning Scheduler has a default review screen with countless fields. If you would like to replace that with a custom screen with limited number of fields, then you lose all the standard Salesforce formatting. Use this demo component for formatting your flow screen. Optionally, add images (either lightning icons or static resources).

![Screen Shot 2020-09-03 at 8 25 09 PM](https://user-images.githubusercontent.com/17482257/174900501-e578a6cf-d6bf-4196-a9a3-f4f345d2e18a.png)

![Screen Shot 2022-06-13 at 11 27 32 AM](https://user-images.githubusercontent.com/17482257/174900542-2d797814-8be5-4d2f-90c3-2d8a837ffbdf.png)

**#2 Use as page break or horizontal ruler/line**

![Screen Shot 2020-09-03 at 8 33 33 PM](https://user-images.githubusercontent.com/17482257/174900561-58d19b1e-b90c-4113-b49a-9973f0692197.png)

**#3 Use within communities as site banner to display link, notice or important information**

![Screen Shot 2020-09-03 at 8 13 58 PM](https://user-images.githubusercontent.com/17482257/174900587-83bac5d3-60bf-432a-9fbc-e295da714d9f.png)

![Screen Shot 2020-09-03 at 8 10 37 PM](https://user-images.githubusercontent.com/17482257/174900600-3a9dd10c-5a6e-4908-ab0e-034cbe6e9ee7.png)

**#4 Use at record level**

![Screen Shot 2020-09-03 at 8 36 57 PM](https://user-images.githubusercontent.com/17482257/174900616-aa033279-6c7e-4b66-8fb7-5593dff80074.png)

**#5 Reuse- ability to use the same component multiple times within a page with different styling for each instance**

<img width="1293" alt="Screen Shot 2020-09-24 at 11 48 16 PM" src="https://user-images.githubusercontent.com/17482257/174900631-39534819-5da5-4552-9f1a-a3acab521020.png">


![image](https://user-images.githubusercontent.com/17482257/174900648-2a1722e7-8157-425c-99e6-71090c7c3d92.png)
