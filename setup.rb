require 'fileutils'

unless File.directory?("Storeroom")
    FileUtils.mkdir_p("Storeroom")
end