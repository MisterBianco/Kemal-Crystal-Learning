

class User
    DB.mapping({
        id:   Int64,
        email: {type: String},
        username: {type: String},
        password: {type: String},
        acc_type: {type: Int64}
    })
end

class Post
    DB.mapping({
        id:   Int64,
        username: {type: String},
        title: {type: String},
        body: {type: String},
        timestamp: {type: String}
    })
end
