require "db"
require "sqlite3"
require "crypto/bcrypt"

require "../database/classes"

def get_last_page() : Int32
    DB.open "sqlite3:./database.sqlite" do |db|
        result = db.scalar("SELECT MAX(id) FROM posts").as(Int64)
        puts result
        return (result / 25.0).ceil.to_i
    end
end

# +============================================================================
# |    This is a connector method to the database
# |    +---> This is the method to retrieve a user if exists
# |    +---> If it doesn't exist return an empty array
def get_user(username : String) : Array(User)
    DB.open "sqlite3:./database.sqlite" do |db|
        result = db.query "select * from users where username is ?", username
        return User.from_rs(result)
    end
    return [] of User
end

# +============================================================================
# |    This is a connector method to the database
# |    +---> This is the method to retrieve all the posts
# |    +---> If it doesn't exist return an empty array
def get_posts(page : Int32) : Array(Post)
    DB.open "sqlite3:./database.sqlite" do |db|
        if page == 1
            result = db.query "select * from posts limit 25"
        else
            result = db.query "select * from posts limit 25 OFFSET #{(page-1)*25}"
        end

        return Post.from_rs(result)
    end
    return [] of Post
end

def get_post(id) : Array(Post)
    DB.open "sqlite3:./database.sqlite" do |db|
        result = db.query "select * from posts where id is ?", id
        return Post.from_rs(result)
    end
    return [] of Post
end

# +============================================================================
# |    This is a connector method to the database
# |    +---> This is the method to retrieve all the subscribers
# |    +---> If it doesn't exist return an empty array
def get_subscribers() : Array(Subscriber)
    DB.open "sqlite3:./database.sqlite" do |db|
        result = db.query "select * from subscribers"
        return Subscriber.from_rs(result)
    end
    return [] of Subscriber
end

# +============================================================================
# |    This is a connector method to the database
# |    +---> This is the method to create a subscriber
def set_subscriber(email : String) : Nil
    DB.open "sqlite3:./database.sqlite" do |db|
        db.exec "insert into subscribers (email) values (?)", email
    end
end
