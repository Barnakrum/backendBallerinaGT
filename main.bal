import backend.types as types;

import ballerina/http;

table<types:User> key(id) users = table [
    {id: 1, email: "Michael@dunder.com", password: "abc123ABC"},
    {id: 2, email: "Dwight@dunder.com", password: "BattlestarGalact1ca"},
    {id: 3, email: "Jim@dunder.com", password: "IL0vePranks"}

];

listener http:Listener httpListener = new (9090, config = {host: "localhost"});

