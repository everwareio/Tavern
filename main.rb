require 'open-uri'
require 'fileutils'
require_relative 'config'

command, target, *flags = ARGV

config_file = File.open("Tavern.config").read
$config = Config.parse(config_file)

# removes a package from the user's computer
def uninstall(package)
    if is_downloaded?(package)
        FileUtils.remove_dir("Storeroom/#{package}")
        puts "#{package.capitalize} uninstalled"
    end
end

# checks if a specific package is installed
def is_downloaded?(package)
    if File.directory?("Storeroom/#{package}")
        return true
    end
    return false
end

# downloads a package to the Storeroom
def fetch(package)
    puts "Fetching #{package}"
    begin
        tap = open("https://storage.googleapis.com/tavernlibrary/#{package}_#{$config['os']}.keg").read
        FileUtils.mkdir_p("Storeroom/#{package}")
        keg = File.open("Storeroom/#{package}/#{package}.keg", "w")
        keg << tap
        keg.close
    rescue
        puts "Could not find a #{package} package for your operating system"
    else
        puts "Finished"
    end
end

# builds a package and links it to the PATH
def pour(package)
    
end

# fetches a keg and pours it
def install(package)
    if is_downloaded?(package)
        puts "#{package} already installed!"     
    else
        fetch(package)
    end
end

# runs Tavern
if command == "install"
    install(target)
elsif command == "uninstall"
    uninstall(target)
end

# newline for readability
puts "\n"