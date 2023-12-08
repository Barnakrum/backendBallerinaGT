import ballerina/http;

public type httpBadRequestWithMessage record {|
    *http:BadRequest;
    record {
        string message;
    } body;

|};


public type httpUnauthorizedWithMessage record {|
    *http:Unauthorized;
    record {
        string message;
    } body;

|};