global class SO2TP_ScheduleTweetGenerator implements Schedulable{    
    global void execute(SchedulableContext sc){
        System.enqueueJob(new SO2TP_QuestionProcessor());
        
        /*
        SO2TP_QuestionProcessor processor = new SO2TP_QuestionProcessor();
        processor.processNewQuestions();
        */
    }
}