public class SO2TP_SettingsController{

    public SO2TP_Settings__c so2tpSettings {get; set;}
    
    public SO2TP_SettingsController(){
        so2tpSettings = SO2TP_Settings__c.getOrgDefaults();
        if(so2tpSettings==null){
            so2tpSettings = new SO2TP_Settings__c();
        }
    }
    
    public PageReference save(){
        upsert so2tpSettings;
        return null;
    }
    
    public PageReference startAggregation(){
        System.enqueueJob(new SO2TP_QuestionProcessor());
        /*
        SO2TP_QuestionProcessor processor = new SO2TP_QuestionProcessor();
        processor.processNewQuestions();
        */
        return null;
    }    
}