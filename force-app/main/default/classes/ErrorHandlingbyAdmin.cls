public class ErrorHandlingbyAdmin {
    Public class ErrorHandlingException extends Exception{}
    @invocableMethod
    public static void errorHandlingByFlow(FlowInputs[] flowinput){
        throw createCustomException(flowInput[0].errorMessage);
    }
    public class FlowInputs{
        @InvocableVariable
        public string errorMessage;
    }
    static ErrorHandlingException createCustomException(string message){
        ErrorHandlingException ehe = new ErrorHandlingException(message);
        ehe.setMessage(message);
        return ehe;
    }

}