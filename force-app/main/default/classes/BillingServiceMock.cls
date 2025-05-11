/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        salesforceComThInvoiceWebService.billProjectResponse_element res =
            new salesforceComThInvoiceWebService.billProjectResponse_element();
        res.status = 'Success';
        response.put('response_x', res);
    }
}