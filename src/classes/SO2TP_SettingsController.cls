public class SO2TP_SettingsController{

    public SO2TP_Settings__c so2tpSettings {get; set;}
    public String scheduleJobURL{
        get{
            List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'SO2TP_ScheduleTweetGenerator' LIMIT 1];
            if(jobs.isEmpty()){
                return System.URL.getSalesforceBaseURL().toExternalForm()+'/ui/setup/apex/batch/ScheduleBatchApexPage';
            }else{
                return System.URL.getSalesforceBaseURL().toExternalForm()+'/ui/setup/apex/batch/ScheduleBatchApexPage?job_name=SO2TP_ScheduleTweetGenerator';
            }            
        }
        set;
    }
    
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
        SO2TP_QuestionProcessor processor = new SO2TP_QuestionProcessor();
        processor.processNewQuestions();
        return null;
    }    
}