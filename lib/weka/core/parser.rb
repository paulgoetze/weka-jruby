require 'weka/core/converters'

module Weka
  module Core
    class Parser
      java_import 'java.io.File'

      class << self
        def parse_arff(file)
          parse_data_set_with(Converters::ArffLoader, file: file)
        end

        def parse_csv(file)
          parse_data_set_with(Converters::CSVLoader, file: file)
        end

        def parse_json(file)
          parse_data_set_with(Converters::JSONLoader, file: file)
        end

        private

        def parse_data_set_with(loader_class, file:)
          loader        = loader_class.new
          loader.source = File.new(file)
          loader.data_set
        end
      end
    end

  end
end
