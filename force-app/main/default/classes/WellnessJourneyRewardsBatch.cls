/**
 * @description       : 
 * @author            : Hal Charymyradov
 * @group             : 
 * @last modified on  : 09-15-2025
 * @last modified by  : Hal Charymyradov
**/
global with sharing class WellnessJourneyRewardsBatch
    implements Database.Batchable<SObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date startDate = getStartDate();
        Date endDate   = getEndDate();

        return Database.getQueryLocator([
            SELECT Id,
                   OwnerId,
                   Owner.Name,
                   Owner.Email,
                   Owner.Username,
                   Status__c,
                   Completion_Date__c
            FROM Wellness_Journey__c
            WHERE Status__c = 'Complete'
              AND Completion_Date__c >= :startDate
              AND Completion_Date__c <= :endDate
            ORDER BY OwnerId, Completion_Date__c
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Wellness_Journey__c> scope) {
        Map<Id, Integer> countByUser = new Map<Id, Integer>();
        for (Wellness_Journey__c wj : scope) {
            countByUser.put(wj.OwnerId, (countByUser.containsKey(wj.OwnerId) ? countByUser.get(wj.OwnerId) : 0) + 1);
        }

        Set<Id> eligibleUserIds = new Set<Id>();
        for (Id uid : countByUser.keySet()) {
            if (countByUser.get(uid) >= 12) eligibleUserIds.add(uid);
        }

        Map<Id, Wellness_Journey__c> sampleRowByUser = new Map<Id, Wellness_Journey__c>();
        for (Wellness_Journey__c wj : scope) {
            if (eligibleUserIds.contains(wj.OwnerId) && !sampleRowByUser.containsKey(wj.OwnerId)) {
                sampleRowByUser.put(wj.OwnerId, wj);
            }
        }

        List<Map<String, Object>> usersPayload = new List<Map<String, Object>>();
        for (Id uid : sampleRowByUser.keySet()) {
            Wellness_Journey__c anyRow = sampleRowByUser.get(uid);
            usersPayload.add(new Map<String, Object>{
                'userId'   => anyRow.OwnerId,
                'fullName' => anyRow.Owner.Name,
                'username' => anyRow.Owner.Username,
                'email'    => anyRow.Owner.Email
            });
        }

        String jsonBody = JSON.serialize(usersPayload);
        Integer status  = RewardsCalloutService.submitUsersForRewardCallout(jsonBody);
        System.debug('WellnessJourneyRewardsBatch → HTTP Status: ' + status);
    }

    global void finish(Database.BatchableContext bc) { System.debug('WellnessJourneyRewardsBatch → Finished.'); }

    private Date getStartDate() {
        Date t = Date.today(); Integer y = t.year(), m = t.month();
        Integer p = ((m - 1) / 3) * 3 + 1 - 3;
        if (p <= 0) { p += 12; y--; }
        return Date.newInstance(y, p, 1);
    }
    private Date getEndDate() { Date s = getStartDate(); return s.addMonths(3).addDays(-1); }
}
