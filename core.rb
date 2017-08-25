require 'open-uri'
require 'fileutils'
require 'tempfile'
require "#{$taverndir}/kegfile"

module Core
  # checks whether or not a package has already been downloaded
  def self.is_downloaded?(package)
    if File.directory?("#{$taverndir}/Storeroom/#{package}")
      return true
    end
    return false
  end

  # attempts to download and install a package
  def self.fetch(package, libraryurl)
    begin
      kegfile = open("#{libraryurl}/#{package}.keg").read
      FileUtils.mkdir_p("#{$taverndir}/Storeroom/#{package}")
      keg = File.open("#{$taverndir}/Storeroom/#{package}/#{package}.keg", "w+")
      keg << kegfile
      keg.close
    rescue
      puts "Could not find '#{package}'"
    end
  end

  # builds a package according to the package install instructions
  def self.pour(package, os)
    kegdata = KegParser.parseFile("#{$taverndir}/Storeroom/#{package}/#{package}.keg", os)
    KegExecutor.run(kegdata, :install, os)
  end

  # removes a package from the Storeroom
  def self.uninstall(package, os)
    if self.is_downloaded?(package)
      kegdata = KegParser.parseFile("#{$taverndir}/Storeroom/#{package}/#{package}.keg", os)
      KegExecutor.run(kegdata, :uninstall, os)
    end
  end

  # updates a package
  def self.update(package, libraryurl, os)
    if self.is_downloaded?(package)
      self.uninstall(package, os)
      self.fetch(package, libraryurl)
      self.pour(package, os)
    end
  end

  # gets all the installed packages
  def self.info(os)
    Dir.foreach("#{$taverndir}/Storeroom") do |item|
      next if item == "." or item == ".."
      kegdata = KegParser.parseFile("#{$taverndir}/Storeroom/#{item}/#{item}.keg", os)
      puts kegdata[:name]
    end
  end

  # installs a package
  def self.install(package, libraryurl, os)
    if self.is_downloaded?(package)
      puts "#{package} already installed!"
    else
      self.fetch(package, libraryurl)
      self.pour(package, os)
    end
  end
end
