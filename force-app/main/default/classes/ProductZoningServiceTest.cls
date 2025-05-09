/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-09-2025
 * @last modified by  : halCharymyradov
**/
@IsTest
private class ProductZoningServiceTest {
    
    @TestSetup
    static void setup() {
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'GC1020', Family = 'TestFamily');
        insert product;
    }
    
    @IsTest
    static void testGetPermissibleFlyZoneWithValidMapping() {
        // Create a Test Double for Product_Geo_Mapping__mdt
        Product_Geo_Mapping__mdt mapping = new Product_Geo_Mapping__mdt(
            Permissible_Fly_Zone__c = 'Zone A',
            Product_Family__c = 'TestFamily',
            Country_Code__c = 'US'
        );
        
        // Set up request
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'GC1020');
        req.httpMethod = 'GET';
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        // Mock the SOQL query result for metadata
        Test.startTest();
        // You would need a way to mock the SOQL query here
        String response = ProductZoningService.getPermissibleFlyZone();
        Test.stopTest();
        
        // Assertions would depend on your mocking implementation
    }
    
    @IsTest
    static void testGetPermissibleFlyZoneConfirmWithAuthorities() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'GC1020');
        req.httpMethod = 'GET';
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        String response = ProductZoningService.getPermissibleFlyZone();
        System.assertEquals('Confirm with the local authorities', response);
    }
    
    @IsTest
    static void testDefaultCountryCode() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'GC1020');
        req.httpMethod = 'GET';
        // No CountryCode header set
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        String response = ProductZoningService.getPermissibleFlyZone();
        System.assertEquals('Confirm with the local authorities', response);
    }
    
    @IsTest
    static void testMissingProductCode() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        String response = ProductZoningService.getPermissibleFlyZone();
        System.assertEquals('ProductCode is missing or doesn\'t exist', response);
    }
    
    @IsTest
    static void testInvalidProductCode() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'INVALID');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        String response = ProductZoningService.getPermissibleFlyZone();
        System.assertEquals('ProductCode is missing or doesn\'t exist', response);
    }
}