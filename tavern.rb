# Globals are bad practice, but this is required
# for Tavern to function the way it does.
$taverndir = __dir__

require "#{$taverndir}/core"
require "#{$taverndir}/config"

# get the configuration information
Config.parse()

# run the program based on the ARGV
if ARGV[0] == "install"
  Core.install(ARGV[1], Config.get('thisuri'), Config.get('os'))
elsif ARGV[0] == "uninstall"
  Core.uninstall(ARGV[1], Config.get('os'))
elsif ARGV[0] == "update"
  Core.update(ARGV[1], Config.get('thisuri'), Config.get('os'))
elsif ARGV[0] == "info"
  Core.info(Config.get('os'))
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
    removedtap = false
    taps = Config.get("tapnames").split(",")
    uris = Config.get("tapuris").split(",")
    taps.each_with_index do |tap, index|
      if tap == ARGV[2]
        taps.delete_at(index)
        uris.delete_at(index)
        removedtap = true
      end
    end
    Config.set("tapnames", taps.join(","))
    Config.set("tapuris", uris.join(","))
    puts "Tap '#{ARGV[2]}' not found" unless removedtap 
  elsif ARGV[1] == "pour"
    taps = Config.get("tapnames").split(",")
    uris = Config.get("tapuris").split(",")
    if taps.include? ARGV[2]
      Config.set("thistap", ARGV[2])
      Config.set("thisuri", uris[taps.index(ARGV[2])])
    else
      puts "Tap '#{ARGV[2]}' not in tap list, make sure you have added it"
    end
  elsif ARGV[1] == "list"
    taps = Config.get("tapnames").split(",")
    uris = Config.get("tapuris").split(",")
    taps.each_with_index do |name, index|
      puts "#{name} (#{uris[index]})"
    end
  elsif ARGV[1] == "current" 
    puts "#{Config.get("thistap")} (#{Config.get("thisuri")})"
  end
end

# print an extra line for readability
puts "\n"
