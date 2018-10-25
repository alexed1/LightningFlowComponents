({
    generateCoords : function(cmp, latitude, longitude) {
        return '"location": { "Latitude": " ' + latitude + '","Longitude": "' + longitude + '"}';
        
    },

    generateAddress : function(cmp, street, city, state, postalCode, country) {
        var loc= '"location": { "Country": " ' + country + '","PostalCode": " ' + postalCode + '","State": " ' + state + '","City": " ' + city + '","Street": "' + street + '"}';
        return loc;
    },
})