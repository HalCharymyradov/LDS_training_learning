/**
 * @description       : 
 * @author            : Hal Charymyradov
 * @group             : 
 * @last modified on  : 09-15-2025
 * @last modified by  : Hal Charymyradov
**/
@isTest
public class RewardsCalloutServiceTest {

    // ---- NEW (inside this class file, not a new top-level class): Throwing mock to hit catch {} ----
    private class ThrowingMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Force Http.send(req) to throw so the service's catch block executes
            throw new CalloutException('boom');
        }
    }

    @isTest
    static void testRewardsCallout_withEligibleUser() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());

        String uniqueUsername = 'testuser' + String.valueOf(Math.random()).substring(2, 8) + '@example.com';

        User u = new User(
            Username = uniqueUsername,
            LastName = 'Test',
            Email = uniqueUsername,
            Alias = 'tuser1',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = UserInfo.getProfileId(),
            LanguageLocaleKey = 'en_US'
        );
        insert u;

        Date today = Date.today();
        Integer currentMonth = today.month();
        Integer previousQuarterStartMonth = ((currentMonth - 1) / 3) * 3 + 1 - 3;
        Integer currentYear = today.year();
        if (previousQuarterStartMonth <= 0) {
            previousQuarterStartMonth += 12;
            currentYear--;
        }
        Date previousQuarterStartDate = Date.newInstance(currentYear, previousQuarterStartMonth, 1);

        List<Wellness_Journey__c> journeys = new List<Wellness_Journey__c>();
        for (Integer i = 0; i < 12; i++) {
            journeys.add(new Wellness_Journey__c(
                Name = 'Test Journey ' + i,
                OwnerId = u.Id,
                Status__c = 'Complete',
                Completion_Date__c = previousQuarterStartDate.addDays(i)
            ));
        }
        insert journeys;

        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch(), 200);
        Test.stopTest();

        // Direct call – success path
        List<Map<String, Object>> mockUsers = new List<Map<String, Object>>();
        mockUsers.add(new Map<String, Object>{
            'userId' => u.Id,
            'fullName' => u.Name,
            'email' => u.Email,
            'username' => u.Username
        });
        String json = JSON.serialize(mockUsers);
        Integer status = RewardsCalloutService.submitUsersForRewardCallout(json);
        System.assertEquals(201, status);
    }

    @isTest
    static void testSubmitUsersForRewardCallout_direct() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());

        List<Map<String, Object>> users = new List<Map<String, Object>>();
        users.add(new Map<String, Object>{
            'userId' => '005123456789ABC',
            'fullName' => 'Test User',
            'email' => 'test@example.com',
            'username' => 'test@example.com'
        });

        String jsonBody = JSON.serialize(users);

        Test.startTest();
        Integer code = RewardsCalloutService.submitUsersForRewardCallout(jsonBody);
        Test.stopTest();

        System.assertEquals(201, code, 'Expected 201 status from mocked callout');
    }

    // Non-throwing server error (500) — covers "unsuccessful" response path inside try {}
    @isTest
    static void testRewardsCalloutService_errorHandling() {
        Test.setMock(HttpCalloutMock.class, new ErrorMock());

        List<Map<String, Object>> users = new List<Map<String, Object>>();
        users.add(new Map<String, Object>{
            'userId' => 'error-id',
            'email' => 'error@example.com',
            'username' => 'error@example.com',
            'fullName' => 'Error User'
        });
        String jsonBody = JSON.serialize(users);

        Test.startTest();
        Integer result = RewardsCalloutService.submitUsersForRewardCallout(jsonBody);
        Test.stopTest();

        System.assertEquals(500, result);
    }

    // Extra tiny test to bump coverage (empty payload success path)
    @isTest
    static void testRewardsCalloutService_emptyPayload_ok() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());

        Test.startTest();
        Integer result = RewardsCalloutService.submitUsersForRewardCallout('[]');
        Test.stopTest();

        System.assertEquals(201, result); 
    }

    // ---- NEW: explicit catch-path coverage (exception thrown by mock -> catch {} returns 500)
    @isTest
    static void testRewardsCalloutService_exceptionHandling() {
        Test.setMock(HttpCalloutMock.class, new ThrowingMock());

        Test.startTest();
        Integer result = RewardsCalloutService.submitUsersForRewardCallout('{"force":"error"}');
        Test.stopTest();

        System.assertEquals(500, result, 'Exception path should return 500');
    }
}
