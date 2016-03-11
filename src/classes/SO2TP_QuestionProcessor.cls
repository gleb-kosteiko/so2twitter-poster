public class SO2TP_QuestionProcessor{
    private SO2TP_Settings__c settings;
    private String soUrl;
    private List<String> tags;

    public SO2TP_QuestionProcessor(){
        settings = SO2TP_Settings__c.getOrgDefaults();
        soUrl = SO2TP_Constants.SO_URL;
        tags = settings.SO2TP_questionTags__c.split(',');
    }
    
    public void processNewQuestions(){
        clearPreviousStatistics();
        if(!tags.isEmpty()){
            for(String tag: tags){
                String taggedUrl = soUrl + (!String.isBlank(tag)? '&tagged='+tag : '');
                agregateNewQuestions(taggedUrl);   
            }
        }else{
            agregateNewQuestions(soUrl);
        }
    }
    
    private void clearPreviousStatistics(){
        settings.SO2TP_tweetsAmount__c=0;
        settings.SO2TP_runningRequests__c='';
        update settings;
    }
        
    @future(callout=true)
    public static void agregateNewQuestions(String finalSoUrl){       
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(finalSoUrl);
        req.setMethod('GET');
        
        System.debug('>>> SO request URL = '+finalSoUrl);
        SO2TP_Settings__c stngs = SO2TP_Settings__c.getOrgDefaults();
        stngs.SO2TP_runningRequests__c = String.isBlank(stngs.SO2TP_runningRequests__c)?
                stngs.SO2TP_runningRequests__c = finalSoUrl : stngs.SO2TP_runningRequests__c +'\n '+finalSoUrl;
        //update stngs;
          
        HttpResponse res = http.send(req);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> questions = (List<Object>) m.get('items');                
        for (Object q : questions){
            Map<String, Object> p = (Map<String, Object>)q;
            if(stngs.SO2TP_tweetOnlyUnanswered__c
                    && (Integer)p.get('answer_count')==0){
                String link = (String)p.get('link');
                String title = (String)p.get('title');
                String message = (title.length()<=100 ? title : title.left(100)+'...')+' '+link;

                SO2TP_TwitterUtil tu = new SO2TP_TwitterUtil(
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterApplicationApiKey__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterApplicationApiSecret__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterAccessToken__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterAccessTokenSecret__c);
                boolean isTweetCreated = tu.sendTweet(message.unescapeHtml4(), null);
                if(isTweetCreated){
                    stngs.SO2TP_tweetsAmount__c++;
                }               
            }
        }
        update stngs;       
    }
}
