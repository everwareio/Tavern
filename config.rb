require 'tempfile'

module Config
  @configsettings = Hash.new

  # turn the config file into a series of hashed values, treat $ as comment
  def self.parse()
    source = File.open("#{$taverndir}/.tavernconfig")
    source.each_line do |line|
      if line.length > 1 and line[0] != "$"
        values = line.split('=')
        @configsettings[values[0].strip] = values[1].strip
      end
    end
  end

  # returns the config setting requested
  def self.get(option)
    if @configsettings.key?(option)
      return @configsettings[option]
    else
      return "Setting not found"
    end
  end

  # updates a line in the config file
  def self.set(option, newvalue)
    temp = Tempfile.new("tavernconfig")
    File.open("#{$taverndir}/.tavernconfig").read.each_line do |line|
      if line.length > 1 and line[0] != "$"
        values = line.split('=')
        if values[0].strip == option
          temp << "#{values[0].strip} = #{newvalue}\n"
        else
          temp << line
        end
      else
        temp << line
      end
    end
    temp.close
    FileUtils.cp_r(temp.path, "#{$taverndir}/.tavernconfig")
  end
end
