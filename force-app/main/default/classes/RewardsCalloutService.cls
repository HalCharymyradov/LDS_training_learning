/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
public class RewardsCalloutService{

    public static Integer submitUsersForRewardCallout(String jsonBody) {
        //Set Endpoint from Named Credential
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);
        
        //Make HTTP Callout
        Http http = new Http();
        HttpResponse response;
        Integer statusCode;
        
        try {
            response = http.send(request);
            statusCode = response.getStatusCode();
            System.debug('HTTP Response Status: ' + statusCode);
            System.debug('HTTP Response Body: ' + response.getBody());
        } catch (Exception e) {
            System.debug('HTTP Callout Failed: ' + e.getMessage());
            statusCode = 500;
        }
        
        //Update to return response status code
        return statusCode;    
    }
}