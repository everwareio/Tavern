require './core'
require './config'

# get the arguments, and the configuration information
argc = ARGV.length
command, target, *flags = ARGV
config_file = File.open("Tavern.config")
config = Config.parse(config_file)

if argc <= 1
  abort "Not enough arguments specified"
end

# run the program based on the arguments
if command == "install"
  Core.install(target, config)
elsif command == "uninstall"
  Core.uninstall(target)
elsif command == "update"
  Core.update(target, config)
else
  puts "Unknown command #{command}"
end

# print an extra line for readability
puts "\n"
