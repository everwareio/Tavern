module Config
    def Config.parse(source) 
        settings = Hash.new
        source.each_line do |line|
            unless line[0] == '$'
                values = line.split('=')
                settings[values[0]] = values[1]
            end
        end
        return settings
    end
end