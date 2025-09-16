/**
 * @description       : Tests for CredentialVerificationService.verifyCredential
 * @author            : halCharymyradov
 * @last modified on  : 09-15-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
private class CredentialVerificationServiceTest {

    // ----------------- Helpers -----------------

    private static Contact createContact(String lastName) {
        Contact c = new Contact(
            FirstName = 'Test',
            LastName  = lastName
        );
        insert c;
        return c;
    }

    private static Certification__c createCertification(String name) {
        Certification__c cert = new Certification__c(Name = name);
        insert cert;
        return cert;
    }

    private static Contact_Certification__c createContactCertification(
        Contact contact,
        Certification__c cert,
        Boolean isActive
    ) {
        Contact_Certification__c cc = new Contact_Certification__c(
            Contact__c       = contact.Id,
            Certification__c = cert.Id,
            isActive__c      = isActive,
            Issue_Date__c    = Date.today() // <-- remove if this field doesn't exist in your org
        );
        insert cc;
        return cc;
    }

    // ----------------- Tests -----------------

    @IsTest
    static void testValidCertification() {
        Contact c = createContact('Doe');
        Certification__c cert = createCertification('Pro Drone Cert');
        Contact_Certification__c cc = createContactCertification(c, cert, true);

        // Re-query to ensure auto-number Name is populated
        cc = [SELECT Name FROM Contact_Certification__c WHERE Id = :cc.Id];

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Doe', cc.Name);
        Test.stopTest();

        System.assertEquals('Valid', result, 'Expected certification to be Valid');
    }

    @IsTest
    static void testNeedsRenewalCertification() {
        Contact c = createContact('Smith');
        Certification__c cert = createCertification('Basic Cert');
        Contact_Certification__c cc = createContactCertification(c, cert, false);

        // Re-query to ensure auto-number Name is populated
        cc = [SELECT Name FROM Contact_Certification__c WHERE Id = :cc.Id];

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Smith', cc.Name);
        Test.stopTest();

        System.assertEquals('Needs Renewal', result, 'Expected certification to be Needs Renewal');
    }

    @IsTest
    static void testNoContactFound() {
        // Create a different contact/cert so we have a valid CC Name that won't match the last name we pass
        Contact other = createContact('SomeoneElse');
        Certification__c cert = createCertification('Whatever');
        Contact_Certification__c cc = createContactCertification(other, cert, true);
        cc = [SELECT Name FROM Contact_Certification__c WHERE Id = :cc.Id];

        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Ghost', cc.Name);
        Test.stopTest();

        System.assertEquals('No record found', result, 'Expected no contact found');
    }

    @IsTest
    static void testNoCertificationFound() {
        Contact c = createContact('Johnson');
        // Intentionally do not create a Contact_Certification__c with this Name
        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Johnson', 'MissingCert');
        Test.stopTest();

        System.assertEquals('No record found', result, 'Expected no certification found');
    }

    @IsTest
    static void testNullAndEmptyInputs() {
        Test.startTest();
        String result1 = CredentialVerificationService.verifyCredential(null, 'SomeCert');
        String result2 = CredentialVerificationService.verifyCredential('Smith', null);
        String result3 = CredentialVerificationService.verifyCredential('', '');
        Test.stopTest();

        System.assertEquals('No record found', result1, 'Null lastName should return No record found');
        System.assertEquals('No record found', result2, 'Null certificationName should return No record found');
        System.assertEquals('No record found', result3, 'Empty inputs should return No record found');
    }
}