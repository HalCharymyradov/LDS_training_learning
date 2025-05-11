/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
public class RewardsCalloutService {

    public static Integer submitUsersForRewardCallout(String jsonBody) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);

        Http http = new Http();
        HttpResponse response;
        Integer statusCode;

        try {
            response = http.send(request);
            statusCode = response.getStatusCode();
            System.debug('HTTP Response Status: ' + statusCode);
            System.debug('HTTP Response Body: ' + response.getBody());
        } catch (Exception e) {
            System.debug('HTTP callout failed: ' + e.getMessage());
            statusCode = 500;
        }

        return statusCode;
    }
}