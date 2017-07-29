require './core'
require './config'

# get the arguments, and the configuration information
command, target, *flags = ARGV
config_file = File.open("Tavern.config")
config = Config.parse(config_file)

# run the program based on the arguments
if command == "install"
    Core.install(target, config)
elsif command == "uninstall"
    Core.uninstall(target)
elsif command == "pour"
    Core.pour(target, config)
else
    puts "Unknown command #{command}"
end

# print an extra line for readability
puts "\n"