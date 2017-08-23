# Globals are bad practice, but this is required
# for Tavern to function the way it does.
$taverndir = File.dirname(__FILE__)

require "#{$taverndir}/core"
require "#{$taverndir}/config"

# get the configuration information
Config.parse()

# run the program based on the ARGV
if ARGV[0] == "install"
  unless ARGV[1] == ""
    if ARGV[2] == "-l"
      Core.install_local(ARGV[1], Config.get('lib'), Config.get('os'))
    else
      Core.install(ARGV[1], Config.get('lib'), Config.get('os'))
    end
  end
elsif ARGV[0] == "uninstall"
  unless ARGV[1] == ""
    if ARGV[2] == "-l"
      Core.uninstall_local(ARGV[1])
    else
      Core.uninstall(ARGV[1])
    end
  end
elsif ARGV[0] == "update"
  unless ARGV[1] == ""
    Core.update(ARGV[1], Config.get('lib'), Config.get('os'))
  end
elsif ARGV[0] == "info"
  Core.info()
elsif ARGV[0] == "config"
  if ARGV[1] == "set"
    unless ARGV[3] == ""
      Config.set(ARGV[2], ARGV[3])
    end
  elsif ARGV[1] == "get"
    unless ARGV[2] ==  ""
      puts Config.get(ARGV[2])
    end
  end
end

# print an extra line for readability
puts "\n"
