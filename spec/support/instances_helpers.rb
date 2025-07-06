require_relative 'file_helpers'

module InstancesHelpers
  include FileHelpers

  def load_instances(filename)
    file      = resources_file(filename)
    extension = File.extname(filename)[1..]

    Weka::Core::Loader.send("load_#{extension}", file)
  end
end
