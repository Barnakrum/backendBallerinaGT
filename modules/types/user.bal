public type User record {
    readonly int id;
    string email;
    string password;

};

public type UserPostDTO record {
    string email;
    string password;
};
