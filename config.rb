module Config
  @configsettings = Hash.new

  # turn the config file into a series of hashed values, treat $ as comment
  def self.parse()
    source = File.open(".tavernconfig")
    source.each_line do |line|
      if line.length > 1 and line[0] != "$"
        values = line.split('=')
        @configsettings[values[0].strip] = values[1].strip
      end
    end
  end

  # returns the config setting requested
  def self.get(option)
    return @configsettings[option]
  end
end
