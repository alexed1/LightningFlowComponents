({
    init : function(cmp, event, helper) {

        var street = cmp.get('v.street');
        var city = cmp.get('v.city');
        var state = cmp.get('v.state');
        var postalCode = cmp.get('v.postalCode');
        var country = cmp.get('v.country');
        var latitude = cmp.get('v.latitude');
        var longitude = cmp.get('v.longitude');
        var icon = cmp.get('v.icon');
        var description = cmp.get('v.description');
        var title = cmp.get('v.title');

        var yarnBall = "";
        var location = "";

        //A marker contains
        // Location Information: This can be a coordinate pair of latitude and longitude, or an address composed of address elements.
        // Descriptive Information: This is information like title, description and an icon which is information relevant to the marker but not specifically related to location.

        if (latitude && longitude)
            location = helper.generateCoords(cmp, latitude, longitude);
        else if (street && (city || state || country || postalCode))
            location = helper.generateAddress(cmp, street, city, state, postalCode, country);
            else throw new Error("The map component requires from the flow either a latitude/longitude pair or a street plus one other address field");


            var yarnBall = '[{'  + location + ', "description":"' + description + '", "icon":"' + icon + '", "title":"' + title;
            yarnBall = yarnBall + '"}]';

            console.log("yarnBall is:" + yarnBall);     
            cmp.set('v.mapMarkers', JSON.parse(yarnBall));



    }
})
