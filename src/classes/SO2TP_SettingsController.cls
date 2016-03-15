public class SO2TP_SettingsController{

    public SO2TP_Settings__c so2tpSettings {get; set;}
    public String scheduleJobURL{get; set;}
    public String scheduleJobLabel{get; set;}
    
    public SO2TP_SettingsController(){
        so2tpSettings = SO2TP_Settings__c.getOrgDefaults();
        if(so2tpSettings==null){
            so2tpSettings = new SO2TP_Settings__c();
        }
                
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'SO2TP_ScheduleTweetGenerator' LIMIT 1];
        if(jobs.isEmpty()){
            scheduleJobURL = System.URL.getSalesforceBaseURL().toExternalForm()+'/ui/setup/apex/batch/ScheduleBatchApexPage';
            scheduleJobLabel='Scheduled job (add new job)';
        }else{
            scheduleJobURL = System.URL.getSalesforceBaseURL().toExternalForm()+'/ui/setup/apex/batch/ScheduleBatchApexPage?job_name=SO2TP_ScheduleTweetGenerator';
            scheduleJobLabel='Scheduled job (edit current job)';
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
