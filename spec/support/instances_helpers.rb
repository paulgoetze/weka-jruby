module InstancesHelpers
  def load_instances(file_name)
    file           = File.expand_path("./../resources/#{file_name}", __FILE__)
    file_extension = File.extname(file_name)[1..-1]

    Weka::Core::Loader.send("load_#{file_extension}", file)
  end
end
