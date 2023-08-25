@isTest
private class NPSAPIInvocableTest {
    @isTest
    static void testCallAPIRequest() {
        // Create test orders with Fulfilled status
        Account Account = New Account(Name = 'Test');
        insert Account;
        Contact Contact = new Contact(LastName = 'Test', accountId = Account.Id);
        insert Contact;
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 5; i++) {
            testOrders.add(new Order(Status = 'Fulfilled', BillToContactId = Contact.Id, AccountId = Account.Id, EffectiveDate = system.today()));
        }
        insert testOrders;

        Test.startTest();
        // Call the Invocable method
        List<Id> orderIds = new List<Id>();
        for (Order order : testOrders) {
            orderIds.add(order.Id);
        }
        NPSAPIInvocable.callAPIRequest(orderIds);
        Test.stopTest();
        
        //No mock test as mentioned in the Bonus Points to write only unit Test, no Integration Test
    }

    @isTest
    static void testCallAPIRequest_NoFulfilledOrders() {
        // Create test orders without Fulfilled status
        Account Account = New Account(Name = 'Test');
        insert Account;
        Contact Contact = new Contact(LastName = 'Test', accountId = Account.Id);
        insert Contact;
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 5; i++) {
            testOrders.add(new Order(Status = 'Draft', BillToContactId = Contact.Id, AccountId = Account.Id, EffectiveDate = system.today()));
        }
        insert testOrders;

        Test.startTest();
        // Call the Invocable method
        List<Id> orderIds = new List<Id>();
        for (Order order : testOrders) {
            orderIds.add(order.Id);
        }
        NPSAPIInvocable.callAPIRequest(orderIds);
        Test.stopTest();

        //No mock test as mentioned in the Bonus Points to write only unit Test, no Integration Test
    }
}