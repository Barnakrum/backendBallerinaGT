import ballerina/http;

listener http:Listener httpListener = new (9090, config = {host: "localhost"});

