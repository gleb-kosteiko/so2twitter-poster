@isTest
public class SO2TP_TestStringUtil{
       
    static testMethod void testPercentEncode() {
        Test.startTest();
        String initialString = 'oauth_consumer_key';
        String percentEncodeRes = SO2TP_StringUtil.percentEncode(initialString);
        System.assertEquals(initialString, percentEncodeRes);
        Test.stopTest();
    }
}