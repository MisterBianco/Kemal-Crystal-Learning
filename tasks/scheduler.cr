require "schedule"
require "../database/queries"

# +============================================================================
# |   This module is used to run scheduled tasks on an interval
# |   +---> You can create new runner instances
# |   +---> Runner instances act like cron and run in their own "fiber"
runner = Schedule::Runner.new

# +============================================================================
# |    This runner instance is best as a unit in for docker instances
# |    +---> It is useful for displaying all the information in a system live.
# |    +---> If it isn't needed it would be best to remove it from the system.
runner.every(100.seconds) do
    puts "+=============================================+"
    puts "| Runner -> get objects                       |"
    puts "+=============================================+"

    get_posts(0).each do |post|
        puts "| #{post.username}: #{post.title} | #{post.body[1..50]}"
    end

    puts "+=============================================+"
    get_subscribers.each do |subv|
        puts "| #{subv.email}"
    end

    puts "+=============================================+"
end

# +============================================================================
# |    This runner instance is just a sample
# |    +--->  It should be adapted for other uses.
runner.every(1000.seconds) do
    puts "Hello world"
end
