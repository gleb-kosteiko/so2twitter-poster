public class SO2TP_SettingsController{

    public SO2TP_Settings__c so2tpSettings {get; set;}
    
    public SO2TP_SettingsController(){
        so2tpSettings = SO2TP_Settings__c.getOrgDefaults();
    }
    
    public PageReference save(){
        update so2tpSettings;
        return null;
    }
    
    public PageReference startAggregation(){
        SO2TP_QuestionProcessor processor = new SO2TP_QuestionProcessor();
        processor.processNewQuestions();
        return null;
    }    
}
