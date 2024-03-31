@IsTest
public class CatsComponentControllerTest {
    @Istest
    private static void testGetCats_itShouldReturnCatDataByName() {
        Test.setMock(HttpCalloutMock.class, new CatsApiMockSuccess());
        List<CatsComponentController.Cat> cats;
        Test.startTest();
        cats = CatsComponentController.getCats('name', 'american shorthair');
        Test.stopTest();
        System.Assert.areEqual(1, cats.size());
        System.Assert.areEqual('American Shorthair', cats[0].name);
    }

    @Istest
    private static void testGetCats_itShouldReturnCatDataByFamilyFriendliness() {
        Test.setMock(HttpCalloutMock.class, new CatsApiMockSuccess());
        List<CatsComponentController.Cat> cats;
        Test.startTest();
        cats = CatsComponentController.getCats('family_friendly', '3');
        Test.stopTest();
        System.debug('cats: ' + cats);
        System.Assert.areEqual(1, cats.size());
        System.Assert.areEqual('American Shorthair', cats[0].name);
    }

    @IsTest
    private static void testGetCats_itShouldThrowExceptionIfParamNotIncluded() {
        Test.setMock(HttpCalloutMock.class, new CatsApiMockSuccess());
        List<CatsComponentController.Cat> cats;
        Boolean caughtException;
        Test.startTest();
        try {
            cats = CatsComponentController.getCats('', 'american shorthair');
        } catch (Exception e) {
            caughtException = true;
        }
        Test.stopTest();
        System.Assert.isTrue(caughtException);
    }

    @IsTest
    private static void testGetCats_itShouldReturnEmptyListIfValueNotIncluded() {
        Test.setMock(HttpCalloutMock.class, new CatsApiMockSuccess());
        List<CatsComponentController.Cat> cats;
        Test.startTest();
        cats = CatsComponentController.getCats('name', '');
        Test.stopTest();
        System.Assert.isNotNull(cats);
        System.Assert.areEqual(0, cats.size());
    }

    @IsTest
    private static void testGetCats_itShouldReturnErrorIfResponseNot200() {
        Test.setMock(HttpCalloutMock.class, new CatsApiMockFailure());
        Test.startTest();
        Boolean caughtException;
        try {
            CatsComponentController.getCats('name', 'american shorthair');
        }
        catch(Exception ex) {
            caughtException = true;
        }
        Test.stopTest();
        System.Assert.isTrue(caughtException);
    }

    private class CatsApiMockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            List<CatsComponentController.Cat> cats = new List<CatsComponentController.Cat>();
            CatsComponentController.Cat cat1 = new CatsComponentController.Cat();
            cat1.name = 'American Shorthair';
            cat1.origin = 'United States';
            cat1.image_link = 'https://www.test.com/fluffy.jpg';
            cat1.family_friendly = 3;
            cats.add(cat1);
            res.setBody(JSON.serialize(cats));
            res.setStatusCode(200);
            return res;
        }
    }

    private class CatsApiMockFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('Internal Server Error');
            return res;
        }
    }
}