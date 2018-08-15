require "db"
require "time"
require "faker"
require "sqlite3"
require "progress"
require "crypto/bcrypt"

require "totem"
require "totem/config_types/env"

require "../database/classes"

Gr = "\u001b[42m \u001b[0m"
Re = "\u001b[41m \u001b[0m"

# +============================================================================
# |
# |    +---> This is the migrations file that containes all the migrations to run
# |    +---> Add migrations as needed.
# |____________________________________________________________________________
# |____________________________________________________________________________

def run_migrations(totem)

    users = totem.get("USERS").as_i
    posts = totem.get("POSTS").as_i
    subs  = totem.get("SUBS").as_i

    elapsed_time = Time.measure do
        migrate_users(users)
        migrate_posts(posts)
        migrate_subscribers(subs)
    end

    puts "\r\nMigrations run successfully in #{elapsed_time}"
    exit
end

# +============================================================================
# |    This is a migration for the users table
# |    +---> Create the table
# |    +---> create an instance
def migrate_users(users)
    expected_time = users*3

    hour = (expected_time / 3600)
    mins = (expected_time % 3600) / 60
    secs = (expected_time % 60)

    puts "Running user migration -- password generation is expensive | Expected to take: #{hour.to_i}:#{mins.to_i}:#{secs.to_i}"

    bar = ProgressBar.new
    bar.total = users
    bar.complete = Gr
    bar.incomplete = Re

    DB.open "sqlite3:./database.sqlite" do |db|
        db.exec "drop table if exists users"

        db.exec "create table if not exists users (id integer primary key autoincrement, email text, username text, password text, acc_type integer)"


        (1..users).each do
            bar.inc
            password = Crypto::Bcrypt::Password.create(Faker::Internet.password, cost: 10)
            db.exec "insert into users (email, username, password, acc_type) values (?, ?, ?, ?)", Faker::Internet.safe_email, Faker::Internet.user_name, password.to_s, 0
        end
    end

end

# +============================================================================
# |    This is a migration for the posts table
# |    +---> Create the table
# |    +---> create an instance
def migrate_posts(posts)

    expected_time = posts*0.01

    hour = (expected_time / 3600)
    mins = (expected_time % 3600) / 60
    secs = (expected_time % 60)

    puts "Running post migration | Expected to take: #{hour.to_i}:#{mins.to_i}:#{secs.to_i}"

    Time::Location.local = Time::Location.load("America/New_York")
    bar = ProgressBar.new
    bar.total = posts
    bar.complete = Gr
    bar.incomplete = Re

    DB.open "sqlite3:./database.sqlite" do |db|
        db.exec "drop table if exists posts"

        db.exec "create table if not exists posts (id integer primary key autoincrement, username text, title text, body text, timestamp time)"

        (1..posts).each do
            bar.inc
            db.exec "insert into posts (username, title, body, timestamp) values (?, ?, ?, ?)", Faker::Internet.user_name, Faker::Lorem.sentence, Faker::Lorem.paragraph(6), Time.new(2016, 2, 1, 21, 1, 10)
        end

    end

end

# +============================================================================
# |    This is a migration for the subscriptions table
# |    +---> Create the table
# |    +---> create an instance
def migrate_subscribers(subs)

    expected_time = subs*0.01

    hour = (expected_time / 3600)
    mins = (expected_time % 3600) / 60
    secs = (expected_time % 60)

    puts "Running subscriber migration | Expected to take: #{hour.to_i}:#{mins.to_i}:#{secs.to_i}"

    bar = ProgressBar.new
    bar.total = subs
    bar.complete = Gr
    bar.incomplete = Re

    DB.open "sqlite3:./database.sqlite" do |db|
        db.exec "drop table if exists subscribers"

        db.exec "create table if not exists subscribers (id integer primary key autoincrement, email text)"
        db.exec "insert into subscribers (email) values (?)", "jayrad1996@gmail.com"

        (1..subs).each do
            bar.inc
            db.exec "insert into subscribers (email) values (?)",  Faker::Internet.safe_email
        end
    end

end
