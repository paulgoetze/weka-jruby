module InstancesHelpers
  def load_instances(file_name)
    file = File.expand_path("./../resources/#{file_name}", __FILE__)
    Weka::Core::Loader.send("load_#{File.extname(file_name)[1..-1]}", file)
  end
end
