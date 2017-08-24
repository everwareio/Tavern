require 'open-uri'
require 'fileutils'

# regex to isolate strings
# enviroment_var = / \$\(([A-Z]+)\)/

# parses kegs
module KegParser
  # expand special variables into full paths
  def self.explode_arg(line, os, name)
    paths = {
      win: {
        HOME: "C:",
        EVERWARE: "C:/EverwareIO",
        PACKAGE: "C:/EverwareIO/Tavern/Storeroom/#{name}"
      },
      darwin: {
        HOME: "~",
        EVERWARE: "~/everware",
        PACKAGE: "~/everware/Tavern/Storeroom/#{name}"
      }
    }

    if line =~ /\$\(([A-Z]+)\)/
      line.gsub!("$(#{$1})", paths[os.to_sym][$1.to_sym])
    end

    return line
  end

  # parse information from a Kegfile
  def self.parseFile(filepath, os)
    kegdata = Hash.new
    openblock = 0
    raw = File.open(filepath)
    lines = raw.read.split("\n")
    raw.close

    lines.each do |line|
      # remove excess whitespace from each line
      line = line.strip
      if line =~ /^;.+$/
        # if it is a comment, skip this line
        next
      elsif line =~ /^\)$/
        # if it is the end of a command block, set the openblock variable to 0
        openblock = 0
      elsif line =~ /^([A-Za-z]+) ?= ?\($/
        # if it is the opening of a block, create a new block in the array and
        # then set it to the openblock variable
        kegdata[$1.to_sym] = Array.new
        openblock = kegdata[$1.to_sym]
      elsif line =~ /^([A-Za-z]+) ?= ?(.+)$/
        # set a variable in the hash to the specified variable in the kegfile
        kegdata[$1.to_sym] = $2
      elsif line =~ /^\$([A-Za-z]+) (.+)$/
        # if the line is a command, first make sure a block is current open,   
        # aborting if it isn't
        if openblock == 0
          puts "Command not in block, aborting"
          return nil
        end

        # if one is open, push the command into it
        params = $2.split(" ")
        params.each do |arg|
          arg = self.explode_arg(arg, os, kegdata[:name])
        end
        command = [$1] + params
        openblock.push(command)
      end
    end

    # return the hash with the data
    return kegdata
  end
end

module KegExecutor
  # $remove command
  def self._remove(path)
    if File.exists?(path)
      if File.directory?(path)
        FileUtils.rm_rf(path)
      else
        File.delete(path)
      end
    end
  end

  # $copy command
  def self._copy(from, to)
    unless File.exists?(from)
      puts "Error: 'from' paramter in $copy does not exist"
    end

    unless File.exists?(to)
      FileUtils.mkdir(to)
    end

    FileUtils.cp_r(from, to)
  end

  # $move command
  def self._move(from, to)
    self._copy(from, to)
    self._remove(from)
  end

  # $download command
  def self._download(url, path)
    puts "Downloading file from #{url} into #{path}"
    content = open(url)
    target = File.open(path, "w+")
    target << content.read
    content.close
    target.close
    puts "Done"
  end

  # $exec command (could be depreciated, breaks cross platform)
  def self._exec(cmd)
    system cmd
  end

  # $gitclone command
  def self._gitclone(git, dest)
    system "git clone #{git} #{dest}"
  end

  # $gitclean command
  def self._gitclean(path)
    Dir.chdir(path) do
      self._remove(".git")
      self._remove(".gitignore")
    end
  end

  # $link command
  def self._link(name, path, argc, executor, os)
    command = "#{executor} #{path} "
    count = 1
    while count <= argc.to_i do
      if os == "win"
        command += "%#{count}"
      elsif os == "darwin"
        command += "$#{count}"
      end
      count += 1
    end

    if os == "win"
      link = File.open("C:/EverwareIO/bin/#{name}.bat", "w+")
      link << command
      link.close
    elsif os == "darwin"
      link = File.open("~/everware/bin/#{name}.sh", "w+")
      link << command
      link.close
      FileUtils.chmod("a=wrx", "~/everware/bin/#{name}.sh")
    end
  end

  # $unlink command
  def self._unlink(name, os)
    if os == "win"
      self._remove("C:/EverwareIO/bin/#{name}.bat")
    elsif os == "darwin"
      self._remove("~/everware/bin/#{name}.sh")
    end
  end

  def self.run(commandlist, os)
    commandlist.each do |cmd|
      if cmd[0] == "exec"
        self._exec(cmd.drop(1).join(" "))
      elsif cmd[0] == "remove"
        self._remove(cmd[1])
      elsif cmd[0] == "download"
        self._download(cmd[1], cmd[2])
      elsif cmd[0] == "gitclone"
        self._gitclone(cmd[1], cmd[2])
      elsif cmd[0] == "gitclean"
        self._gitclean(cmd[1])
      elsif cmd[0] == "move"
        self._move(cmd[1], cmd[2])
      elsif cmd[0] == "copy"
        self._copy(cmd[1], cmd[2])
      elsif cmd[0] == "link"
        self._link(cmd[1], cmd[2], cmd[3], cmd[4], os)
      elsif cmd[0] == "unlink"
        self._unlink(cmd[1], os)
      end
    end
  end
end

outcome = KegParser.parseFile("samplekeg.kegfile", "win")
KegExecutor.run(outcome[:install], "win")