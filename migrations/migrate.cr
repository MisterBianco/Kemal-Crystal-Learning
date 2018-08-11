require "db"
require "sqlite3"

require "../database/classes"

require "crypto/bcrypt"

# Create the users table
def migrate_users()

    DB.open "sqlite3:./database.sqlite" do |db|
        # Drop table if exists and start again
        db.exec "drop table if exists users"
        password = Crypto::Bcrypt::Password.create("password", cost: 10)

        # Create table
        db.exec "create table if not exists users (id integer primary key autoincrement, email text, username text, password text, acc_type integer)"
        db.exec "insert into users (email, username, password, acc_type) values (?, ?, ?, ?)", "jayrad1996@gmail.com", "Jacobsin", password.to_s, 1
        result = db.query "select * from users where id = 1"
        puts User.from_rs(result)
    end

end

def migrate_posts()

    DB.open "sqlite3:./database.sqlite" do |db|
        # Drop table if exists and start again
        db.exec "drop table if exists posts"

        # Create table
        db.exec "create table if not exists posts (id integer primary key autoincrement, username text, title text, body text, timestamp text)"
        db.exec "insert into posts (username, title, body, timestamp) values (?, ?, ?, ?)", "Jacobsin", "Hello World", "My first post", "08-10-2018"
        result = db.query "select * from posts where id = 1"
        puts Post.from_rs(result)
    end

end
