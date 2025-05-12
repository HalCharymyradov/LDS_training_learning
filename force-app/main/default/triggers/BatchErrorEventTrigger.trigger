/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-12-2025
 * @last modified by  : halCharymyradov
**/
trigger BatchErrorEventTrigger on BatchApexErrorEvent (after insert) {
    BatchErrorEventHelper.handleBatchErrorEvents(Trigger.New);
}