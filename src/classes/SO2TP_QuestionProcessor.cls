public class SO2TP_QuestionProcessor implements Queueable, Database.AllowsCallouts {   
    private SO2TP_Settings__c settings = SO2TP_Settings__c.getOrgDefaults();
    
    public void execute(QueueableContext context){
        String soUrl = SO2TP_Constants.SO_URL;
        List<String> tags = settings.SO2TP_questionTags__c.split(',');
        List<FeedItem> feedItems = new List<FeedItem>();
        
        if(!tags.isEmpty()){
            for(String tag: tags){
                String taggedUrl = soUrl + (!String.isBlank(tag)? '&tagged='+tag : '');
                feedItems.addAll(processQuestions(taggedUrl));
            }
        }else{
            feedItems = processQuestions(soUrl);
        }
        if(!feedItems.isEmpty()){
            System.enqueueJob(new SO2TP_TweetProcessor(feedItems));
        }                       
    }
    
    private List<FeedItem> processQuestions(String url){
        List<FeedItem> feeds = new List<FeedItem>();           
                
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> questions = (List<Object>) m.get('items');
                
        for (Object q : questions){
            Map<String, Object> p = (Map<String, Object>)q;
            if(settings.SO2TP_tweetOnlyUnanswered__c
                    && (Integer)p.get('answer_count')==0){
                String link = (String)p.get('link');
                String title = (String)p.get('title');
                String message = (title.length()<=100 ? title : title.left(100)+'...')+' '+link+' #twitter';
                        
                FeedItem post = new FeedItem();
                post.parentId = UserInfo.getUserId();
                post.Body = message; 
                feeds.add(post);
            }
        }
        return feeds;             
    }
}