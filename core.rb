require 'open-uri'
require 'fileutils'
require 'json'

module Core
  # checks whether or not a package has already been downloaded
  def self.is_downloaded?(package)
    if File.directory?("Storeroom/#{package}")
      return true
    end
    return false
  end

  # attempts to download and install a package
  def self.fetch(package, config)
    puts "Fetching #{package}"
    begin
      tap = open("https://storage.googleapis.com/tavernlibrary/#{package}_#{config['os']}.keg").read
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

  # builds a package according to the package install instructions
  def self.pour(package, config)
    kegfile = File.open("Storeroom/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    Dir.chdir("Storeroom/#{package}/") do
      keg['build'].each do |line|
        system line
      end

      keg['install'].each do |line|
        system line
      end
    end
  end

  # removes a package from the Storeroom
  def self.uninstall(package)
    if self.is_downloaded?(package)
      kegfile = File.open("Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      Dir.chdir("Storeroom/#{package}/") do
        keg['uninstall'].each do |line|
          system line
        end
      end
      FileUtils.remove_dir("Storeroom/#{package}")
      puts "#{package.capitalize} uninstalled"
    end
  end

  # installs a package
  def self.install(package, config)
    if is_downloaded?(package)
      puts "#{package} already installed!"
    else
      fetch(package, config)
      pour(package, config)
    end
  end
end
