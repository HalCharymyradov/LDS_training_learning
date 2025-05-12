/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-12-2025
 * @last modified by  : halCharymyradov
**/
@isTest
public class BatchErrorEventTriggerTest {

    @testSetup
    static void setup() {
        Contact pilot = new Contact(FirstName = 'Test', LastName = 'Pilot', Pilot_Rating__c = 3.0);
        insert pilot;

        Mission__c mission = new Mission__c(
            Pilot__c = pilot.Id,
            Completion_Rating__c = 4.0,
            Overall_Rating__c = 5.0,
            Safety_Incidents__c = 1.0,
            Status__c = 'Complete',
            Subject__c = 'Test Mission'
        );
        insert mission;
    }

    @isTest
    static void testBatchApexErrorEventTrigger() {
        Test.startTest();
        Database.executeBatch(new PilotRatingBatch(), 1);
        Test.stopTest();

        List<Error_Log__c> logs = [
            SELECT Id, Message__c, Async_Apex_Job_Id__c
            FROM Error_Log__c
            LIMIT 1
        ];
        System.assertEquals(1, logs.size(), 'Expected 1 error log');
    }
}