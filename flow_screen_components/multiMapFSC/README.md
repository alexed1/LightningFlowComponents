# Lightning Multi-Map Component #

Post describing this component:  https://unofficialsf.com/map-with-markers-in-flow/
Original Aura Component from Terence Chiu off which the LWC is based:  https://unofficialsf.com/displaying-map-with-markers-in-flow-screen-using-lightning-components-by-terence-chiu/

# multiMapFSC
Embed map in Flow passing in collection (of address attributes or coordinates), and allowing marker selection.

### Summary:
1)	Pass in Address or Coordinates and view on Map
2)	Adjust Title of the Map
3)	Show or hide the List View on the right side.

### Admin Instructions:
##### Enabling and Disabling Features in Flow:
1)  Set Coordinates attribute to true if you plan to pass in Latitude and Longitude.  Otherwise you will pass in address.
2)  For markerList (Address), you must pass in semi-colon delimited collection of strings in the following order:  City;Country;PostalCode;State;Street;Name;Icon;MarkerValue.
    a.  Example:  Austin;USA;78767;TX;312 Constitution Place Austin, TX 78767 USA;Edge Communications;standard:account;001B000001KKZavIAH
3)  For markerList (Coordinates), you must pass in semi-colon delimited collection of strings in the following order:  Latitude;Longitude;Name;icon;Id.
    a.  30.267153;-97.743057;Edge Communications;standard:account;001B000001KKZavIAH
4)  Set showListView to true if you want the list of markers displayed on screen.  
5)  Selected marker (if applicable) will be stored in selectedMarkerValue output - the type will depend on what value is passed in for markerList.

|Parameter	                               |I	 |O	     |Information 
|------------------------------------------|-----|-------|-------------------------------------------------------------------------------------------------------------------------------------------|
|**markerList** (Marker List)              |X    |       |List of String.  Pass in Address attributes or Latitude/Longitude depending on coordinates flag.  Default is address.  See instructions.   |
|**title**	(Map Title)     		       |X	 |       |String.  Title to appear above the map                                                                                                     |
|**showListView**	(Show List View?)      |X	 |       |Boolean.  Set to true to show the List View on the map.  Default is false (hidden)                                                         |
|**coordinates** (Use Coordinates?)	       |X    |	     |Boolean.  Set to true if you will pass in Coordinates instead of Address. Default is false                                                 |
|**selectedMarkerValue** (Selected Marker) |	 |X	     |String.  This is the 'MarkerValue' passed in to the markerList for the corresponding marker selected.                                      |

### User Instructions:
1)	Note that markers will not appear if there are address/location attributes missing.  This can cause the List View not to match the map.
2)  If enabled by your administrator, selecting a Marker on the map or list view will capture the selection you have made.  This value will correspond to the MarkerValue you've passed in to the component when building the markerList input.  For example, if 'Austin;USA;78767;TX;312 Constitution Place Austin, TX 78767 USA;Edge Communications;standard:account;001B000001KKZavIAH' is one of your markers in the collection variable, then the MarkerValue passed in is '001B000001KKZavIAH', and so selectedMarkerValue passed out if that marker is selected would be '001B000001KKZavIAH'.