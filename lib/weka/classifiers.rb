Dir[File.expand_path("../../weka/classifiers/*.rb", __FILE__)].each do |file|
  require file
end
