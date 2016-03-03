public class SO2TP_SettingsController{

    public SO2TP_Settings__c so2tpSettings {get; set;}
    
    public SO2TP_SettingsController(){
        so2tpSettings = SO2TP_Settings__c.getOrgDefaults();
    }
    
    public PageReference Save(){
        update so2tpSettings;
        return null;
    }
}