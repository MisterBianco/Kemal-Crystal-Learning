require "db"
require "sqlite3"

require "../database/classes"

require "crypto/bcrypt"

def get_user?(username : String) : Array
    DB.open "sqlite3:./database.sqlite" do |db|
        result = db.query "select * from users where username is ?", username
        user = User.from_rs(result)
    end
end
