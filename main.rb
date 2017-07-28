require 'open-uri'
require 'fileutils'
require 'json'
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

# builds a package according to the package install instruction
def pour(package)
    kegfile = File.open("Storeroom/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    Dir.chdir("Storeroom/#{package}/") do
        keg['install'].each do |line|
            system line
        end
    end
end

# fetches a keg and pours it
def install(package)
    if is_downloaded?(package)
        puts "#{package} already installed!"     
    else
        fetch(package)
        pour(package)
    end
end

# runs Tavern
if command == "install"
    install(target)
elsif command == "uninstall"
    uninstall(target)
elsif command == "link"
    pour(target)
end

# newline for readability
puts "\n"