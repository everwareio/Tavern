require 'fileutils'

# creates a /Storeroom directory to store packages in
unless File.directory?("Storeroom")
    FileUtils.mkdir_p("Storeroom")
end