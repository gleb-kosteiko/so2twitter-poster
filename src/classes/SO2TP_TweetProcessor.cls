public class SO2TP_TweetProcessor implements Queueable, Database.AllowsCallouts{
    private List<FeedItem> feedItems;
    
    public SO2TP_TweetProcessor(List<FeedItem> tweets){
        feedItems = tweets;
    }
    
    public void execute(QueueableContext context){
        insert feedItems;
    }
}