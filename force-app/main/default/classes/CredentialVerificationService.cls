/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-09-2025
 * @last modified by  : halCharymyradov
**/
global with sharing class CredentialVerificationService {

    webservice static String verifyCredential(String lastName, String certificationName) {
        System.debug('Input Parameters - LastName: ' + lastName + ', CertificationName: ' + certificationName);

        if (String.isBlank(lastName) || String.isBlank(certificationName)) {
            return 'No record found';
        }

        // Query Contact
        List<Contact> contacts = [
            SELECT Id 
            FROM Contact 
            WHERE LastName = :lastName 
            LIMIT 1
        ];

        if (contacts.isEmpty()) {
            return 'No record found';
        }

        Contact contact = contacts[0];

        // Query Certification
        List<Contact_Certification__c> certs = [
            SELECT isActive__c 
            FROM Contact_Certification__c 
            WHERE Name = :certificationName AND Contact__c = :contact.Id 
            LIMIT 1
        ];

        if (certs.isEmpty()) {
            return 'No record found';
        }

        return certs[0].isActive__c ? 'Valid' : 'Needs Renewal';
    }
}