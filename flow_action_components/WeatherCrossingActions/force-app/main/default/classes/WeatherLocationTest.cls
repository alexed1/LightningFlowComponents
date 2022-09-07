@isTest
public with sharing class WeatherLocationTest {
    public WeatherLocationTest() {

    }

    @isTest
    static void canCreateWeatherLocation() {

        String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WeatherLocation testWeatherLocation= new WeatherLocation();
		System.assert(testWeatherLocation != null);
		//System.assert(testWeatherLocation.stationContributions == null);
		//System.assert(testWeatherLocation.values == null);
		System.assert(testWeatherLocation.id == null);
		System.assert(testWeatherLocation.address == null);
		System.assert(testWeatherLocation.name == null);
		System.assert(testWeatherLocation.index == null);
		System.assert(testWeatherLocation.latitude == null);
		System.assert(testWeatherLocation.longitude == null);
		System.assert(testWeatherLocation.distance == null);
		System.assert(testWeatherLocation.time_Z == null);
		System.assert(testWeatherLocation.tz == null);
		System.assert(testWeatherLocation.currentConditions == null);
		//System.assert(testWeatherLocation.alerts == null);

    }
}
