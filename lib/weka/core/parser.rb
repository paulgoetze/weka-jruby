module Weka
  module Core
    java_import 'weka.core.converters.CSVLoader'
    java_import 'weka.core.converters.ArffLoader'
    java_import 'weka.core.converters.JSONLoader'

    class Parser
      java_import 'java.io.File'

      class << self
        def parse_arff(file_name)
          parse_data_set_with(ArffLoader, file_name)
        end

        def parse_csv(file_name)
          parse_data_set_with(CSVLoader, file_name)
        end

        def parse_json(file_name)
          parse_data_set_with(JSONLoader, file_name)
        end

        private

        def parse_data_set_with(loader_class, file_name)
          loader = loader_class.new
          loader.source = File.new(file_name)
          loader.data_set
        end
      end
    end

  end
end
