/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-12-2025
 * @last modified by  : halCharymyradov
**/
public class BatchErrorEventHelper {

    public static void handleBatchErrorEvents(List<BatchApexErrorEvent> events) {
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();

        for (BatchApexErrorEvent event : events) {
            errorLogs.add(new Error_Log__c(
                Name = 'Batch Error',
                Message__c = event.Message,
                Async_Apex_Job_Id__c = String.valueOf(event.AsyncApexJobId)
            ));
        }

        if (!errorLogs.isEmpty()) {
            insert errorLogs;
        }
    }
}