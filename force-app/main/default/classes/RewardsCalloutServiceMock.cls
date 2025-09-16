/**
 * @description       : 
 * @author            : Hal Charymyradov
 * @group             : 
 * @last modified on  : 09-15-2025
 * @last modified by  : Hal Charymyradov
**/
@isTest
global class RewardsCalloutServiceMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"message":"Success"}');
        response.setStatusCode(201);
        return response;
    }
}