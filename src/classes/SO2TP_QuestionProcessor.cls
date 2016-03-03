public class SO2TP_QuestionProcessor{

    public SO2TP_QuestionProcessor(){}
    
    public void processNewQuestions(){
        agregateNewQuestions();
    }
        
    @future(callout=true)
    public static void agregateNewQuestions(){
        SO2TP_Settings__c settings = SO2TP_Settings__c.getOrgDefaults();
        String url = settings.SO2TP_baseSoUrl__c;
        String tag = settings.SO2TP_questionTags__c;
        
        String finalUrl = url+tag;
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(finalUrl);
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> questions = (List<Object>) m.get('items');
        for (Object q : questions) {
            Map<String, Object> p = (Map<String, Object>)q;
            String link = (String)p.get('link');
            String title = (String)p.get('title');
            String message = (title.length()<=100 ? title : title.left(100)+'...')+' '+link;
            
            SO2TP_TwitterUtil tu = new SO2TP_TwitterUtil(
                    settings.SO2TP_twitterApplicationApiKey__c, 
                    settings.SO2TP_twitterApplicationApiSecret__c, 
                    settings.SO2TP_twitterAccessToken__c, 
                    settings.SO2TP_twitterAccessTokenSecret__c);
            boolean isTweetCreated = tu.sendTweet(message, null);            
            System.debug('>>> tweet is created = '+isTweetCreated);
        }       
    }
}