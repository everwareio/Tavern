module Config
  # turn the config file into a series of hashed values, treat $ as comment
  def self.parse(source)
    settings = Hash.new
    source.each_line do |line|
      if line.length > 1 and line[0] != "$"
        values = line.split('=')
        settings[values[0].strip] = values[1].strip
      end
    end
    puts settings
    return settings
  end
end
