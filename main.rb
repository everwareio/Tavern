require 'open-uri'
require 'fileutils'
require_relative 'config'

def install(package)
    if isDownloaded?(package)
        puts "#{package} already installed!"     
    else
        pkg = fetch(package) 
    end
end

def isDownloaded?(package)
    if File.directory?("Storeroom/#{package}")
        return true
    end
    return false
end

def fetch(package)
    puts "Fetching #{package}"
    FileUtils.mkdir_p("Storeroom/#{package}")
    tap = File.open("Storeroom/#{package}/#{package}.keg", "w")
    tap << open("http://google.com.au").read
    tap.close
    puts "Done"
end

def pour(package)
    # build a package
end

install("samplepackage")