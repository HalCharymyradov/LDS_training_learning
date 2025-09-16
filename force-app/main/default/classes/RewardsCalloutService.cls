/**
 * @description       : 
 * @author            : Hal Charymyradov
 * @group             : 
 * @last modified on  : 09-15-2025
 * @last modified by  : Hal Charymyradov
**/
public with sharing class RewardsCalloutService {

    public static Integer submitUsersForRewardCallout(String jsonBody) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards'); // exact NC + path
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);

        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('RewardsCalloutService → Status: ' + res.getStatusCode());
            System.debug('RewardsCalloutService → Body: ' + res.getBody());
            return res.getStatusCode();
        } catch (Exception e) {
            System.debug('RewardsCalloutService → Callout failed: ' + e.getMessage());
            return 500;
        }
    }
}
