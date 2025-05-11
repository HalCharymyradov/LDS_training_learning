/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
trigger WorkshopTrigger on Workshop__c (after insert) {
    WorkshopHandler.handleAfterInsert(Trigger.new);
}