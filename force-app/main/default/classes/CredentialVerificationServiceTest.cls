/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-09-2025
 * @last modified by  : halCharymyradov
**/
@isTest
private class CredentialVerificationServiceTest {

    private static Contact createContact(String lastName) {
        Contact c = new Contact(LastName = lastName);
        insert c;
        return c;
    }

    private static Certification__c createCertification(String name) {
        Certification__c cert = new Certification__c(Name = name);
        insert cert;
        return cert;
    }

    private static Contact_Certification__c createContactCertification(Contact contact, Certification__c cert, Boolean isActive) {
        Contact_Certification__c cc = new Contact_Certification__c(
            Contact__c = contact.Id,
            Certification__c = cert.Id,
            isActive__c = isActive,
            Issue_Date__c = Date.today()
        );
        insert cc;
        return cc;
    }

    @isTest
    static void testValidCertification() {
        Contact c = createContact('Doe');
        Certification__c cert = createCertification('Pro Drone Cert');
        Contact_Certification__c cc = createContactCertification(c, cert, true);

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Doe', cc.Name);
        Test.stopTest();

        System.assertEquals('Valid', result, 'Expected certification to be Valid');
    }

    @isTest
    static void testNeedsRenewalCertification() {
        Contact c = createContact('Smith');
        Certification__c cert = createCertification('Basic Cert');
        Contact_Certification__c cc = createContactCertification(c, cert, false);

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Smith', cc.Name); // Corrected to use Contact_Certification__c.Name
        Test.stopTest();

        System.assertEquals('Needs Renewal', result, 'Expected certification to be Needs Renewal');
    }

    @isTest
    static void testNoContactFound() {
        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Ghost', 'NonExistentCert');
        Test.stopTest();

        System.assertEquals('No record found', result, 'Expected no contact found');
    }

    @isTest
    static void testNoCertificationFound() {
        Contact c = createContact('Johnson');

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Johnson', 'MissingCert');
        Test.stopTest();

        System.assertEquals('No record found', result, 'Expected no certification found');
    }

    @isTest
    static void testNullAndEmptyInputs() {
        Test.startTest();
        String result1 = CredentialVerificationService.verifyCredential(null, 'SomeCert');
        String result2 = CredentialVerificationService.verifyCredential('Smith', null);
        String result3 = CredentialVerificationService.verifyCredential('', '');
        Test.stopTest();

        System.assertEquals('No record found', result1);
        System.assertEquals('No record found', result2);
        System.assertEquals('No record found', result3);
    }
}