module Config
  # turn the config file into a series of hashed values, treat $ as comment
  def self.parse(source)
    settings = Hash.new
    source.each_line do |line|
      unless line[0] == '$'
        values = line.split('=')
        settings[values[0].strip] = values[1].strip
      end
    end
    return settings
  end
end
