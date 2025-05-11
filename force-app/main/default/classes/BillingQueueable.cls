/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
public class BillingQueueable implements Queueable {

    private Id projectId;
    private Decimal billingAmount;

    public BillingQueueable(Id projectId, Decimal billingAmount) {
        this.projectId = projectId;
        this.billingAmount = billingAmount;
    }

    public void execute(QueueableContext context) {
        AccessibilityProjectBilling.callBillingService(projectId, billingAmount);
    }
}