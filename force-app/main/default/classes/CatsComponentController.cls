public with sharing class CatsComponentController {
    @AuraEnabled
    public static List<Cat> getCats(String param, String value) {
        if(String.isBlank(param)) {
            throw new AuraHandledException('param is required');
        }
        if(String.isBlank(value)) {
            return new List<Cat>();
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Cats_API' + '?' + param + '=' + String.escapeSingleQuotes(value.replace(' ', '%20')));
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        if(res.getStatusCode() != 200) {
            throw new AuraHandledException('Error calling API: ' + res.getStatusCode() + '; ' + res.getBody());
        }
        List<Cat> cats;
        try {
            cats = (List<Cat>) JSON.deserialize(res.getBody(), List<Cat>.class);
        }
        catch(Exception e) {
            throw new AuraHandledException('Unable to parse API response: ' + e.getMessage());
        }
        return cats;
    }

    public class Cat {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String origin;
        @AuraEnabled
        public String image_link;
        @AuraEnabled
        public Integer family_friendly;
    }
}