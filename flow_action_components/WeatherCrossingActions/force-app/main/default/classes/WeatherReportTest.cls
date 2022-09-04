@isTest
public with sharing class WeatherReportTest {

    @isTest
    static void canCreateWeatherReport() {
            String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
            WeatherReport testWeatherReport  = new WeatherReport();
            System.assert(testWeatherReport != null);
            System.assert(testWeatherReport.wdir == null);
            System.assert(testWeatherReport.uvindex == null);
            System.assert(testWeatherReport.datetimeStr == null);
            System.assert(testWeatherReport.preciptype == null);
            System.assert(testWeatherReport.cin == null);
            System.assert(testWeatherReport.cloudcover == null);
            System.assert(testWeatherReport.pop == null);
            System.assert(testWeatherReport.mint == null);
            System.assert(testWeatherReport.datetime_Z == null);
            System.assert(testWeatherReport.precip == null);
            System.assert(testWeatherReport.solarradiation == null);
            System.assert(testWeatherReport.dew == null);
            System.assert(testWeatherReport.humidity == null);
            System.assert(testWeatherReport.temp == null);
            System.assert(testWeatherReport.maxt == null);
            System.assert(testWeatherReport.visibility == null);
            System.assert(testWeatherReport.wspd == null);
            System.assert(testWeatherReport.severerisk == null);
            System.assert(testWeatherReport.solarenergy == null);
            System.assert(testWeatherReport.heatindex == null);
            System.assert(testWeatherReport.snowdepth == null);
            System.assert(testWeatherReport.sealevelpressure == null);
            System.assert(testWeatherReport.snow == null);
            System.assert(testWeatherReport.wgust == null);
            System.assert(testWeatherReport.conditions == null);
            System.assert(testWeatherReport.windchill == null);
            System.assert(testWeatherReport.cape == null);
    }


}