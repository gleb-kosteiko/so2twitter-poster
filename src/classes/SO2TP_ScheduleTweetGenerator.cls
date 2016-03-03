global class SO2TP_ScheduleTweetGenerator implements Schedulable{    
    global void execute(SchedulableContext sc){
        SO2TP_QuestionProcessor processor = new SO2TP_QuestionProcessor();
        processor.processNewQuestions();
    }
}