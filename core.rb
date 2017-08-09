require 'open-uri'
require 'fileutils'
require 'json'
require 'tempfile'

module Core
  #the path to this file
  @thispath = File.dirname(__FILE__)

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
    rescue
      puts "Could not find a #{package} package for your operating system"
      return false
    else
      FileUtils.mkdir_p("#{@thispath}/Storeroom/#{package}")
      keg = File.open("#{@thispath}/Storeroom/#{package}/#{package}.keg", "w")
      keg << tap
      keg.close
      puts "Finished"
      return true
    end
  end

  # builds a package according to the package install instructions
  def self.pour(package, config)
    kegfile = File.open("#{@thispath}/Storeroom/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    Dir.chdir("#{@thispath}/Storeroom/#{package}/") do
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
      kegfile = File.open("#{@thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      Dir.chdir("#{@thispath}/Storeroom/#{package}/") do
        keg['uninstall'].each do |line|
          system line
        end
      end
      FileUtils.remove_dir("#{@thispath}/Storeroom/#{package}")
      temp = Tempfile.new("kegs")
      File.open("#{@thispath}/Storeroom/installed.menu", 'r').each do |line|
        temp << line unless line.chomp == package
      end
      temp.close
      FileUtils.mv(temp.path, "#{@thispath}/Storeroom/installed.menu")
      puts "#{package.capitalize} uninstalled"
    end
  end

  # updates a package
  def self.update(package, config)
    if self.is_downloaded?(package)
      currentkegfile = File.open("#{@thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      currentkeg = JSON.parse(currentkegfile)
      currentkegfile.close
      puts "Local version: #{currentkeg['version']}"
      serverkegfile = open("https://storage.googleapis.com/tavernlibrary/#{package}_#{config['os']}.keg").read
      serverkeg = JSON.parse(serverkegfile)
      serverkegfile.close
      puts "Server version: #{serverkeg['version']}"
      if serverkeg['version'] != currentkeg['version']
        puts "Updating"
        self.uninstall(package)
        self.install(package, config)
      else
        puts "No update required"
      end
    else
      puts "Package not found, install? (y/n)"
      response = gets
      if response.downcase == "y"
        self.install(package, config)
      end
    end
  end

  # gets all the installed packages
  def self.info()
    menu = File.open("#{@thispath}/Storeroom/installed.menu", "r")
    menu.each_line do |package|
      kegfile = File.open("#{@thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      puts "#{keg['name']}, version: #{keg['version']}"
    end
  end

  # installs a package
  def self.install(package, config)
    if is_downloaded?(package)
      puts "#{package} already installed!"
    else
      if self.fetch(package, config)
        menu = File.open("#{@thispath}/Storeroom/installed.menu", "a")
        menu << "#{package}"
        menu.close
        self.pour(package, config)
      end
    end
  end
end
