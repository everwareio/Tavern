require 'open-uri'
require 'fileutils'
require 'json'
require 'tempfile'

module Core
  # checks whether or not a package has already been downloaded
  def self.is_downloaded?(package)
    if File.directory?("#{$taverndir}/Storeroom/#{package}")
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
      FileUtils.mkdir_p("#{$taverndir}/Storeroom/#{package}")
      keg = File.open("#{$taverndir}/Storeroom/#{package}/#{package}.keg", "w")
      keg << tap
      keg.close
      puts "Done!"
      return true
    end
  end

  # builds a package according to the package install instructions
  def self.pour(package)
    kegfile = File.open("#{$taverndir}/Storeroom/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    puts "Installing..."
    Dir.chdir("#{$taverndir}/Storeroom/#{package}/") do
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
      kegfile = File.open("#{$taverndir}/Storeroom/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      Dir.chdir("#{$taverndir}/Storeroom/#{package}/") do
        keg['uninstall'].each do |line|
          system line
        end
      end
      FileUtils.remove_dir("#{$taverndir}/Storeroom/#{package}")
      temp = Tempfile.new("kegs")
      File.open("#{$taverndir}/Storeroom/installed.menu", 'r').each_line do |line|
        temp << line unless line.chomp == package
      end
      temp.close
      FileUtils.mv(temp.path, "#{$taverndir}/Storeroom/installed.menu")
      puts "#{package.capitalize} uninstalled"
    end
  end

  # updates a package
  def self.update(package, libraryurl, os)
    if self.is_downloaded?(package)
      currentkegfile = File.open("#{$taverndir}/Storeroom/#{package}/#{package}.keg", "r")
      currentkeg = JSON.parse(currentkegfile.read)
      currentkegfile.close
      puts "Local version: #{currentkeg['version']}"
      serverkegfile = open("#{libraryurl}/#{package}_#{os}.keg")
      serverkeg = JSON.parse(serverkegfile.read)
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
    menu = File.open("#{$taverndir}/Storeroom/installed.menu", "r")
    menu.each_line do |package|
      kegfile = File.open("#{$taverndir}/Storeroom/#{package.strip}/#{package.strip}.keg", "r")
      keg = JSON.parse(kegfile.read)
      kegfile.close
      puts "#{keg['name']}, version: #{keg['version']}"
    end
    menu.close
  end

  # installs a package
  def self.install(package, libraryurl, os)
    if self.is_downloaded?(package)
      puts "#{package} already installed!"
    else
      if self.fetch(package, libraryurl, os)
        menu = File.open("#{$taverndir}/Storeroom/installed.menu", "a")
        menu << "#{package}\n"
        menu.close
        self.pour(package)
        puts "Package #{package} is installed!"
      end
    end
  end

  # setup local Cellar
  def self.setup_cellar()
    unless File.directory?("Cellar")
        FileUtils.mkdir_p("Cellar")
        menu = File.new("Cellar/installed.menu", "w")
        menu.close
    end
  end

  # checks if a package has been downloaded locally
  def self.is_downloaded_locally?(package)
    if File.directory?("./Cellar/#{package}")
      return true
    end
    return false
  end

  # fetches a package for local use
  def self.fetch_local(package, libraryurl, os)
    puts "Fetching '#{package}'"
    begin
      tap = open("#{libraryurl}/#{package}_#{os}.keg").read
    rescue
      puts "Could not find a #{package} package for your operating system"
      return false
    else
      FileUtils.mkdir_p("./Cellar/#{package}")
      keg = File.open("./Cellar/#{package}/#{package}.keg", "w")
      keg << tap
      keg.close
      puts "Done!"
      return true
    end
  end

  #
  def self.pour_local(package)
    kegfile = File.open("./Cellar/#{package}/#{package}.keg", "r").read
    keg = JSON.parse(kegfile)
    puts "Installing..."
    Dir.chdir("./Cellar/#{package}/") do
      keg['build'].each do |line|
        system line
      end

      keg['install'].each do |line|
        system line
      end
    end
  end

  # check if there are differences between the local and server versions
  def self.update(package, libraryurl, os)
    if self.is_downloaded_locally?(package)
      currentkegfile = File.open("./Cellar/#{package}/#{package}.keg", "r")
      currentkeg = JSON.parse(currentkegfile.read)
      currentkegfile.close
      puts "Local version: #{currentkeg['version']}"
      serverkegfile = open("#{libraryurl}/#{package}_#{os}.keg")
      serverkeg = JSON.parse(serverkegfile.read)
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

  # removes a package from the Cellar
  def self.uninstall_local(package)
    if self.is_downloaded?(package)
      kegfile = File.open("./Cellar/#{package}/#{package}.keg", "r").read
      keg = JSON.parse(kegfile)
      Dir.chdir("./Cellar/#{package}/") do
        keg['uninstall'].each do |line|
          system line
        end
      end
      FileUtils.remove_dir("./Cellar/#{package}")
      temp = Tempfile.new("kegs")
      File.open("./Cellar/installed.menu", 'r').each_line do |line|
        temp << line unless line.chomp == package
      end
      temp.close
      FileUtils.mv(temp.path, "./Cellar/installed.menu")
      puts "#{package} uninstalled"
    end
  end

  # install a package locally
  def self.install_local(package, libraryurl, os)
    self.setup_cellar()
    if self.is_downloaded_locally?(package)
      puts "#{package} already installed!"
    else
      if self.fetch_local(package, libraryurl, os)
        menu = File.open("./Cellar/installed.menu", "a")
        menu << "#{package}\n"
        menu.close
        self.pour_local(package)
        puts "Package #{package} is installed!"
      end
    end
  end
end
