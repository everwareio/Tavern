require 'open-uri'
require 'fileutils'
require 'json'
require 'tempfile'

module Core
  # checks whether or not a package has already been downloaded
  def self.is_downloaded?(package)
    if File.directory?("#{$thispath}/Storeroom/#{package}")
      return true
    end
    return false
  end

  # attempts to download and install a package
  def self.fetch(package, libraryurl, os)
    puts "Fetching '#{package}'"
    begin
      tap = open("#{libraryurl}/#{package}_#{os}.keg").read
    rescue
      puts "Could not find a #{package} package for your operating system"
      return false
    else
      FileUtils.mkdir_p("#{$thispath}/Storeroom/#{package}")
      keg = File.open("#{$thispath}/Storeroom/#{package}/#{package}.keg", "w")
      keg << tap
      keg.close
      puts "Done!"
      return true
    end
  end

  # builds a package according to the package install instructions
  def self.pour(package)
    kegfile = File.open("#{$thispath}/Storeroom/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    puts "Installing..."
    Dir.chdir("#{$thispath}/Storeroom/#{package}/") do
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
      kegfile = File.open("#{$thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      Dir.chdir("#{$thispath}/Storeroom/#{package}/") do
        keg['uninstall'].each do |line|
          system line
        end
      end
      FileUtils.remove_dir("#{$thispath}/Storeroom/#{package}")
      temp = Tempfile.new("kegs")
      File.open("#{$thispath}/Storeroom/installed.menu", 'r').each do |line|
        temp << line unless line.chomp == package
      end
      temp.close
      FileUtils.mv(temp.path, "#{$thispath}/Storeroom/installed.menu")
      puts "#{package.capitalize} uninstalled"
    end
  end

  # updates a package
  def self.update(package, libraryurl, os)
    if self.is_downloaded?(package)
      currentkegfile = File.open("#{$thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      currentkeg = JSON.parse(currentkegfile)
      currentkegfile.close
      puts "Local version: #{currentkeg['version']}"
      serverkegfile = open("#{libraryurl}/#{package}_#{os}.keg").read
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
    menu = File.open("#{$thispath}/Storeroom/installed.menu", "r")
    menu.each_line do |package|
      kegfile = File.open("#{$thispath}/Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      puts "#{keg['name']}, version: #{keg['version']}"
    end
  end

  # installs a package
  def self.install(package, libraryurl, os)
    if is_downloaded?(package)
      puts "#{package} already installed!"
    else
      if self.fetch(package, libraryurl, os)
        menu = File.open("#{$thispath}/Storeroom/installed.menu", "a")
        menu << "#{package}"
        menu.close
        self.pour(package)
        puts "Package #{package} is installed!"
      end
    end
  end
end
