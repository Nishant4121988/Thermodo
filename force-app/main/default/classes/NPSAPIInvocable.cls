public with sharing class NPSAPIInvocable {
    @InvocableMethod(label='Send NPS API Request')
    Public static void callAPIRequest(List<Id>Ids){
        List<Id>orderIds = Ids;
        List<Order> orders = [SELECT Id, OrderNumber, BillToContact.Email
                              FROM Order
                              WHERE Id IN :orderIds AND Status = 'Fulfilled'];

        if (orders.isEmpty()) {
            // No orders with status Fulfilled, return without making the callout
            return;
        }

        // Prepare the request data for the NPS API
        List<Map<String, Object>> requestData = new List<Map<String, Object>>();
        for (Order order : orders) {
            Map<String, Object> data = new Map<String, Object>();
            data.put('orderNumber', order.OrderNumber);
            data.put('email', order.BillToContact.Email);
            data.put('sfId', order.Id);
            requestData.add(data);
        }

        // Serialize the request data to JSON
        String requestBody = JSON.serialize(requestData);
        system.debug(requestBody);

        // Make the HTTP callout to the NPS API
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('tmondo:Noy84LRpYvMZuETB')));
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        
            // Send the request
            HttpResponse response = new Http().send(request);
        	SYSTEM.DEBUG(response.getBody());
            // Check the response status code
            if (response.getStatusCode() != 200) {
                // Request encountered an error, handle the response accordingly
                String errorMessageforAdmin = 'HTTP Error - Status Code: ' + response.getStatusCode() + ', Response: ' + response.getBody();
                // Log the error or throw a custom exception
                System.debug(errorMessageforAdmin);
                List<string> ErrorMessage = new list<string>();
                ErrorMessage.add(errorMessageforAdmin);
                /*
                Map<String, string> errorMessage = new Map<String, string>();
                errorMessage.put('ErrorMessage', errorMessageforAdmin);
                Flow.Interview.Error_Handling_by_Admin flow = new Flow.Interview.Error_Handling_by_Admin(errorMessage);
                flow.start();
                // Please change the profileId in getEmail for User element in the flow
                */
                ExceptionUtilityCls.throwCustomException(ErrorMessage);
            }
    }
}