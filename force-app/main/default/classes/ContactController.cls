/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-04-2025
 * @last modified by  : halCharymyradov
**/
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, FirstName, LastName, Email FROM Contact WITH security_enforced LIMIT 500];
    }
}