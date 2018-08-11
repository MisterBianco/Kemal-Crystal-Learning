require "schedule"

# Use this to run tests or to run constant environment tests
MAX_COUNT = 5
RETRIES = 0

runner = Schedule::Runner.new
runner.every(5.seconds) do
    puts "Ran Test"
    result = 1

    Schedule.retry if result == -1
    Schedule.stop if result == 2 >= MAX_COUNT
end
