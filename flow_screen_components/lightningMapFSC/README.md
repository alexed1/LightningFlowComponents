# Lightning Map Component #

Post describing this component:  https://unofficialsf.com/map-with-markers-in-flow/
Original Aura Component off which the LWC is based:  https://unofficialsf.com/displaying-map-with-markers-in-flow-screen-using-lightning-components-by-terence-chiu/

# lightningMapFSC
Embed map in Flow passing in collection (of address attributes or geolocation), and allowing marker selection.

### Summary:
1)	Pass in Address or Geolocation and view on Map
2)	Adjust Title of the Map
3)	Show or hide the List View on the right side.

### Admin Instructions:
##### Enabling and Disabling Features in Flow:
1)  Set Geolocation attribute to true if you plan to pass in Latitude and Longitude.  Otherwise you will pass in address.
2)  For markerList (Address), you must pass in semi-colon delimited collection of strings in the following order:  City;Country;PostalCode;State;Street;Name;Icon;MarkerValue.
    a.  Example:  Austin;USA;78767;TX;312 Constitution Place Austin, TX 78767 USA;Edge Communications;standard:account;001B000001KKZavIAH
3)  For markerList (Geolocation), you must pass in semi-colon delimited collection of strings in the following order:  Latitude;Longitude;Name;icon;Id.
    a.  30.267153;-97.743057;Edge Communications;standard:account;001B000001KKZavIAH
4)  Set showListView to true if you want the list of markers displayed on screen.  
5)  Selected marker (if applicable) will be stored in selectedMarkerValue output - the type will depend on what value is passed in for markerList.

|Parameter	               |I	 |O	     |Information 
|--------------------------|-----|-------|-------------------------------------------------------------------------------------------------------------------------------------------|
|**markerList**            |X    |       |List of String.  Pass in Address attributes or Latitude/Longitude depending on geolocation flag.  Default is address.  See instructions.   |
|**title**	       		   |X	 |       |String.  Title to appear above the map                                                                                                     |
|**showListView**	       |X	 |       |Boolean.  Set to true to show the List View on the map.  Default is false (hidden)                                                         |
|**geolocation**	       |X    |	     |Boolean.  Set to true if you will pass in Geolocation instead of Address. Default is false                                                 |
|**selectedMarkerValue**   |	 |X	     |String.  This is the 'MarkerValue' passed in to the markerList for the corresponding marker selected.                                      |

### User Instructions:
1)	Note that markers will not appear if there are address/location attributes missing.  This can cause the List View not to match the map.
2)  If enabled by your administrator, selecting a Marker on the map or list view will capture the selection you have made.  This value will correspond to the MarkerValue you've passed in to the component when building the markerList input.  For example, if 'Austin;USA;78767;TX;312 Constitution Place Austin, TX 78767 USA;Edge Communications;standard:account;001B000001KKZavIAH' is one of your markers in the collection variable, then the MarkerValue passed in is '001B000001KKZavIAH', and so selectedMarkerValue passed out if that marker is selected would be '001B000001KKZavIAH'.