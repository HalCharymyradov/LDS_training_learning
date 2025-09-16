/**
 * @description       : 
 * @author            : Hal Charymyradov
 * @group             : 
 * @last modified on  : 09-15-2025
 * @last modified by  : Hal Charymyradov
**/
@IsTest
global class ErrorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(500); // simulate server error WITHOUT throwing
        res.setBody('{"message":"Simulated failure"}');
        return res;
    }
}
