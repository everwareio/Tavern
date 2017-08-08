require 'json'

module Kegbuilder
  # gets multiline input
  def self.multiline()
    lines = Array.new
    input = STDIN.gets.chomp
    while input != ""
      lines.push(input)
      input = STDIN.gets.chomp
    end
    return lines
  end

  # creates a kegfile and saves it
  def self.create()
    keghash = {}

    # get the package name
    puts "Package name:"
    keghash[:name] = STDIN.gets.chomp

    # gets the target architecture of the package
    puts "Target architecture (darwin for OSX, win for windows, linux for linux)"
    targetarch = STDIN.gets.chomp

    # get the package version
    puts "Package version:"
    keghash[:version] = STDIN.gets.chomp

    # get a simple description of the package
    puts "Package description"
    keghash[:desc] = STDIN.gets.chomp

    # get a series of build commands to build the package on the target machine
    puts "Build commands (a collection of commands to be executed to build your program)"
    keghash[:build] = self.multiline

    # get a series of install commands to build the package on target machine
    puts "Install commands (a collectionof commands to execute to install your program)"
    keghash[:install] = self.multiline

    # get a series of uninstall commands to remove the package from the target machine
    puts "Uninstall commands (a collection of commands to remove the program from the computer)"
    keghash[:uninstall] = self.multiline

    # writes the keghash to a file
    newkeg = File.open("#{keghash[:name]}_#{targetarch}.keg", "w")
    newkeg << JSON.generate(keghash)
    newkeg.close
  end
end
