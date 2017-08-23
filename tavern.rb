# Globals are bad practice, but this is required
# for Tavern to function the way it does.
$taverndir = File.dirname(__FILE__)

require "#{$taverndir}/core"
require "#{$taverndir}/config"

# get the configuration information
Config.parse()

# run the program based on the ARGV
if ARGV[0] == "install"
  if ARGV[2] == "-l"
    Core.install_local(ARGV[1], Config.get('thistap'), Config.get('os'))
  else
    Core.install(ARGV[1], Config.get('thistap'), Config.get('os'))
  end
elsif ARGV[0] == "uninstall"
  if ARGV[2] == "-l"
    Core.uninstall_local(ARGV[1])
  else
    Core.uninstall(ARGV[1])
  end
elsif ARGV[0] == "update"
  Core.update(ARGV[1], Config.get('thistap'), Config.get('os'))
elsif ARGV[0] == "info"
  Core.info()
elsif ARGV[0] == "config"
  if ARGV[1] == "set"
    Config.set(ARGV[2], ARGV[3])
  elsif ARGV[1] == "get"
    puts Config.get(ARGV[2])
  end
elsif ARGV[0] == "tap"
  if ARGV[1] == "add"
    Config.set("tapnames", Config.get("tapnames") + "," + ARGV[2])
    Config.set("tapuris", Config.get("tapuris") + "," + ARGV[3])
  elsif ARGV[1] == "remove"
    taps = Config.get("tapnames").split(",")
    uris = Config.get("tapuris").split(",")
    taps.each_with_index do |tap, index|
      if tap == ARGV[2]
        taps.delete_at(index)
        uris.delete_at(index)
      end
    end
    Config.set("tapnames", taps.join(","))
    Config.set("tapuris", uris.join(","))
  elsif ARGV[1] == "pour"
    Config.set("thistap", ARGV[2])
  elsif ARGV[1] == "list"
    taps = Config.get("tapnames").split(",")
    uris = Config.get("tapuris").split(",")
    taps.each_with_index do |name, index|
      puts "#{name} (#{uris[index]})"
    end
  elsif ARGV[1] == "current" 
    puts Config.get("thistap")
  end
end

# print an extra line for readability
puts "\n"
