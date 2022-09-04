@isTest
public with sharing class WeatherConditionsSetTest {
    public WeatherConditionsSetTest() {

    }

    @isTest
    static void canCreateWeatherConditionsSet() {

        String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WeatherConditionsSet objCurrentConditions = new WeatherConditionsSet();
		System.assert(objCurrentConditions != null);
		System.assert(objCurrentConditions.wdir == null);
		System.assert(objCurrentConditions.temp == null);
		System.assert(objCurrentConditions.sunrise == null);
		System.assert(objCurrentConditions.visibility == null);
		System.assert(objCurrentConditions.wspd == null);
		System.assert(objCurrentConditions.icon == null);
		System.assert(objCurrentConditions.stations == null);
		//System.assert(objCurrentConditions.heatindex == null);
		System.assert(objCurrentConditions.cloudcover == null);
		System.assert(objCurrentConditions.datetime_Z == null);
		System.assert(objCurrentConditions.precip == null);
		System.assert(objCurrentConditions.moonphase == null);
		//System.assert(objCurrentConditions.snowdepth == null);
		System.assert(objCurrentConditions.sealevelpressure == null);
		System.assert(objCurrentConditions.dew == null);
		System.assert(objCurrentConditions.sunset == null);
		System.assert(objCurrentConditions.humidity == null);
		//System.assert(objCurrentConditions.wgust == null);
		//System.assert(objCurrentConditions.windchill == null);
    }
}
