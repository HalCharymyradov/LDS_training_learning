/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-22-2025
 * @last modified by  : halCharymyradov
**/
global class AccessibilityProjectBilling {
    
    @future(callout=true)
     public static void callBillingService(String projectId, Decimal billingAmount) {
     BillingServiceProxy.project project = new BillingServiceProxy.project();
     project.projectid = projectId;
     project.billAmount = billingAmount;

     // Use Trailhead-required merge field strings
     project.username = '{!$Credential.BillingServiceCredential.username}';
     project.password = '{!$Credential.BillingServiceCredential.password}';

     BillingServiceProxy.InvoicesPortSoap11 service = new BillingServiceProxy.InvoicesPortSoap11();
     service.endpoint_x = 'callout:IntegrationSB__BillingInvoiceService';

     String response = service.billProject(project);
     System.debug('SOAP Billing Response: ' + response);
     }
}