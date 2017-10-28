require 'sequel'
require 'zlib'
require 'stringio'
require 'json'
require 'fileutils'

def fan_out(mbtiles)
  db = Sequel.sqlite(mbtiles)
  count = 0
  db[:tiles].each {|r|
    z = r[:zoom_level]
    x = r[:tile_column]
    y = (1 << r[:zoom_level]) - r[:tile_row] - 1
    data = r[:tile_data]
    dir = "../jp1710_#{z}/#{x}"
    FileUtils::mkdir_p(dir) unless File.directory?(dir)
    File.write("#{dir}/#{y}.mvt", Zlib::GzipReader.new(StringIO.new(data)).read)
    count += 1
  }
  print "wrote #{count} tiles.\n"
end

fan_out('japan.mbtiles')
