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

    resource function post .(types:UserPostDTO user) returns types:User|types:httpBadRequestWithMessage|error {
        //check if email is taken
        types:User[] selected = from types:User u in users
            where u.email == user.email 
            limit 1
            select u;

        if selected.length() > 0 {
            return {body:{message:"Email is taken"}};
        }
        //find highest id 
        selected = from types:User u in users
        order by u.id descending
            select u;

        int highestId = selected[0].id;
        types:User newUser ={id:highestId+1, email:user.email,password:user.password};
        users.add(newUser);
        return newUser;
    }
}
