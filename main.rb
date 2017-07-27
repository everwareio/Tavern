require 'open-uri'
require 'fileutils'
require_relative 'config'

def install(package)
    if is_downloaded?(package)
        puts "#{package} already installed!"     
    else
        fetch(package)
    end
end

def is_downloaded?(package)
    if File.directory?("Storeroom/#{package}")
        return true
    end
    return false
end

def fetch(package)
    puts "Fetching #{package}"
    FileUtils.mkdir_p("Storeroom/#{package}")
    tap = File.open("Storeroom/#{package}/#{package}.keg", "w")
    tap << open("https://storage.googleapis.com/tavernlibrary/#{package}.keg").read
    tap.close
    puts "Done"
end

def pour(package)
    # build a package
end

install("testpackage")