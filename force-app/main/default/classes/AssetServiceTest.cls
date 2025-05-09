/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-09-2025
 * @last modified by  : halCharymyradov
**/
@isTest
private class AssetServiceTest {

    @isTest static void testReportLostDevice_assetNotFound() {
        Test.startTest();
        String result = AssetService.reportLostDevice('NonExistentAsset');
        Test.stopTest();

        System.assertEquals('No device found.', result, 'Expected error message for non-existent asset');
    }

    @isTest static void testReportLostDevice_noInsuranceCoverage() {
        Account testAccount = new Account(Name='Test Account1');
        insert testAccount;

        Contact testContact = new Contact(FirstName='Test2', LastName='Contact2', AccountId=testAccount.Id);
        insert testContact;
        Asset testAsset = new Asset(Name='Test Asset 2',AccountId =testAccount.Id,ContactId=testContact.id, Asset_Identifier__c='Asset002', Status='Available');
        insert testAsset;

        Test.startTest();
        String result = AssetService.reportLostDevice(testAsset.Asset_Identifier__c);
        Test.stopTest();

        System.assertEquals('No coverage. Asset status adjusted to Lost.', result, 'Expected message for no insurance coverage');
    }

    @isTest static void testReportLostDevice_claimAlreadyFiled() {
        Account testAccount = new Account(Name='Test Account2');
        insert testAccount;

        Contact testContact = new Contact(FirstName='Test3', LastName='Contact3', AccountId=testAccount.Id);
        insert testContact;
        Asset testAsset = new Asset(Name='Test Asset 3',AccountId =testAccount.Id,ContactId=testContact.id, Asset_Identifier__c='Asset003', Status='Available');
        insert testAsset;

        Insurance__c testInsurance = new Insurance__c(Asset__c=testAsset.Id, Coverage__c='Comprehensive', Active__c=true);
        insert testInsurance;


        Test.startTest();
        String result = AssetService.reportLostDevice(testAsset.Asset_Identifier__c);
        Test.stopTest();
		List<Claim__c> claims = [SELECT Id,Name FROM Claim__c WHERE Insurance__c = :testInsurance.Id AND Type__c = 'Loss' LIMIT 1];

        System.assertEquals(claims[0].Name, result, 'Expected message for already filed claim');
    }
}