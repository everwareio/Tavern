require 'fileutils'

# creates a /Storeroom directory to store packages in
unless File.directory?("Storeroom")
    FileUtils.mkdir_p("Storeroom")
end

# creates a index file to store packages
unless File.exists?("Storeroom/.packageindex")
    f = File.open("Storeroom/.packageindex", "w+")
    f.close
end