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
        if(!tags.isEmpty()){
            for(String tag: tags){
                String taggedUrl = soUrl + (!String.isBlank(tag)? '&tagged='+tag : '');
                agregateNewQuestions(taggedUrl);   
            }
        }else{
            agregateNewQuestions(soUrl);
        }
    }
        
    @future(callout=true)
    public static void agregateNewQuestions(String finaSolUrl){       
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(finaSolUrl);
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> questions = (List<Object>) m.get('items');
        
        Integer tweetCounter = 0; //clear it later
        for (Object q : questions) {
            Map<String, Object> p = (Map<String, Object>)q;
            if(SO2TP_Settings__c.getOrgDefaults().SO2TP_tweetOnlyUnanswered__c
                    && (Integer)p.get('answer_count')==0){
                String link = (String)p.get('link');
                String title = (String)p.get('title');
                String message = (title.length()<=100 ? title : title.left(100)+'...')+' '+link;

                SO2TP_TwitterUtil tu = new SO2TP_TwitterUtil(
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterApplicationApiKey__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterApplicationApiSecret__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterAccessToken__c, 
                        SO2TP_Settings__c.getOrgDefaults().SO2TP_twitterAccessTokenSecret__c);
                boolean isTweetCreated = tu.sendTweet(message, null);
                if(isTweetCreated){
                    tweetCounter++;
                    System.debug('>>> tweet is created = '+isTweetCreated);
                }               
            }
            System.debug('>>> Tweets with similar tag were created = '+tweetCounter);
        }       
    }
}