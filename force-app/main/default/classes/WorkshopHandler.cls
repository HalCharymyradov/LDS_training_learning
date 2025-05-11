/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
public class WorkshopHandler {

    public static void handleAfterInsert(List<Workshop__c> newWorkshops) {
        List<Accessibility_Project__c> projectsToInsert = new List<Accessibility_Project__c>();

        for (Workshop__c ws : newWorkshops) {
            if (ws.DHH_Accessible__c == true) {
                Accessibility_Project__c ap = new Accessibility_Project__c(
                    Amount__c = 50,
                    Type__c = 'Sign Language Interpreters',
                    Status__c = 'Submitted'
                );
                projectsToInsert.add(ap);
            }
        }

        if (!projectsToInsert.isEmpty()) {
            insert projectsToInsert;

            for (Accessibility_Project__c ap : projectsToInsert) {
                System.enqueueJob(new BillingQueueable(ap.Id, ap.Amount__c));
            }
        }
    }
}