/**
 * @description       : 
 * @author            : halCharymyradov
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : halCharymyradov
**/
@isTest
global class ErrorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        throw new CalloutException('Simulated failure');
    }
}