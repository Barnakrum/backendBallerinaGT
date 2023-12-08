import backend.types as types;

import ballerina/http;

table<types:User> key(id) users = table [
    {id: 1, email: "Michael@dunder.com", password: "abc123ABC"},
    {id: 2, email: "Dwight@dunder.com", password: "BattlestarGalact1ca"},
    {id: 3, email: "Jim@dunder.com", password: "IL0vePranks"}

];

function findUsersByEmail(string email,int limitResults) returns types:User[] {
    types:User[] selected = from types:User u in users
            where u.email == email 
            limit limitResults
            select u;
    return selected
}

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

    resource function post .(types:UserPostDTO user) returns types:User|types:httpBadRequestWithMessage|error {
        //check if email is taken
        types:User[] selected = findUsersByEmail(user.email,1);

        if selected.length() > 0 {
            return {body:{message:"Email is taken"}};
        }
        //find highest id 
        selected = from types:User u in users
        order by u.id descending
            limit 1
            select u;

        int highestId = selected[0].id;
        types:User newUser ={id:highestId+1, email:user.email,password:user.password};
        users.add(newUser);
        return newUser;
    }

    resource function post resetPassword(record{string email;}body) returns http:Accepted|types:httpBadRequestWithMessage|error {
        //check if email is taken
        types:User[] selected = findUsersByEmail(body.email,1);

        if selected.length() > 0 {
            return http:ACCEPTED;
        }
        else {
            types:httpBadRequestWithMessage badRequest = {body:{message:"No user with that email"}};
            return badRequest;
        }
    }
}
