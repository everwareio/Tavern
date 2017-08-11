# Globals are bad practice, but this is required
# for Tavern to function the way it does.
$thispath = File.dirname(__FILE__)

require "#{$thispath}/core"
require "#{$thispath}/config"

# get the arguments, and the configuration information
argc = ARGV.length
command, target, *flags = ARGV
Config.parse()

# run the program based on the arguments
if command == "install"
  Core.install(target, Config.get('lib'), Config.get('os'))
elsif command == "uninstall"
  Core.uninstall(target)
elsif command == "update"
  Core.update(target, Config.get('lib'), Config.get('os'))
elsif command == "info"
  Core.info()
elsif command == "config"
  puts Config.get(target)
else
  puts "Unknown command #{command}"
end

# print an extra line for readability
puts "\n"
