/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
@isTest
public class BillingCalloutServiceTest {

    @isTest
    static void testBillingCallout_success() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

        Accessibility_Project__c project = new Accessibility_Project__c(
            Amount__c = 100,
            Type__c = 'Sign Language Interpreters',
            Status__c = 'Submitted'
        );
        insert project;

        Test.startTest();
        AccessibilityProjectBilling.callBillingService(project.Id, project.Amount__c);
        Test.stopTest();
    }
}