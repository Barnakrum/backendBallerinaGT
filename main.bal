import backend.types as types;

import ballerina/http;

table<types:User> key(id) users = table [
    {id: 1, email: "Michael@dunder.com", password: "abc123ABC"},
    {id: 2, email: "Dwight@dunder.com", password: "BattlestarGalact1ca"},
    {id: 3, email: "Jim@dunder.com", password: "IL0vePranks"}

];

listener http:Listener httpListener = new (9090, config = {host: "localhost"});

service /api/users on httpListener {
    resource function get .() returns types:User[]|error? {
        return users.toArray();
    }
    resource function get [int id]() returns types:User|http:NotFound|error {
        types:User? user = users[id];
        if user is () {
            return http:NOT_FOUND;
        }
        return user;
    }
}

