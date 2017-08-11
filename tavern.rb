# Globals are bad practice, but this is required
# for Tavern to function the way it does.
$taverndir = File.dirname(__FILE__)

require "#{$taverndir}/core"
require "#{$taverndir}/config"

# get the configuration information
Config.parse()

# run the program based on the ARGV
if ARGV[0] == "install"
  Core.install(ARGV[1], Config.get('lib'), Config.get('os'))
elsif ARGV[0] == "uninstall"
  Core.uninstall(ARGV[1])
elsif ARGV[0] == "update"
  Core.update(ARGV[1], Config.get('lib'), Config.get('os'))
elsif ARGV[0] == "info"
  Core.info()
elsif ARGV[0] == "config"
  if ARGV[1] == "set"
    Config.set(ARGV[2], ARGV[3])
  elsif ARGV[1] == "get"
    puts Config.get(ARGV[2])
  end
end

# print an extra line for readability
puts "\n"
