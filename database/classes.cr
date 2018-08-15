require "json"

# +============================================================================
# |    This is a class for the database
# |    +--->  This should act like a connector between the app and the database
class Subscriber
    DB.mapping({
        id:   Int64,
        email: {type: String}
    })

    JSON.mapping({
        id:   Int64,
        email: {type: String}
    })

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like a getter method
    def email
        @email
    end
end

# +============================================================================
# |    This is a class for the database
# |    +--->  This should act like a connector between the app and the database
class User
    DB.mapping({
        id:   Int64,
        email: {type: String},
        username: {type: String},
        password: {type: String},
        acc_type: {type: Int64}
    })

    JSON.mapping({
        id:   Int64,
        email: {type: String},
        username: {type: String},
        password: {type: String},
        acc_type: {type: Int64}
    })

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like a getter method
    def email
        @email
    end

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like a getter method
    def username
        @username
    end

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like a getter method
    def password
        @password
    end

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like a getter method
    def password
        @acc_type
    end
end

# +============================================================================
# |    This is a class for the database
# |    +--->  This should act like a connector between the app and the database
class Post
    DB.mapping({
        id:   Int64,
        username: {type: String},
        title: {type: String},
        body: {type: String},
        timestamp: {type: String}
    })

    JSON.mapping({
        id:   Int64,
        username: {type: String},
        title: {type: String},
        body: {type: String},
        timestamp: {type: String}
    })
end
