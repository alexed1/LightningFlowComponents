/**
 * @description       : An invocable class to be used as Apex-Defined for testing webhook2flow
 * @author            : Jack D. Pond
 * @group             : 
 * @last modified on  : 05-11-2021
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-11-2021   Jack D. Pond   Initial Version
**/
public inherited sharing class webhook2flow_apexclass_test{

	@invocableVariable(label='type' )
    @AuraEnabled
	public String type;

	@invocableVariable(label='channel' )
    @AuraEnabled
	public String channel;

    @invocableVariable(label='user' )
    @AuraEnabled
	public String user;

    @invocableVariable(label='text' )
    @AuraEnabled
	public String text;

    @invocableVariable(label='ts' )
    @AuraEnabled
	public String ts;

    @invocableVariable(label='team' )
    @AuraEnabled
	public String team;
   
}