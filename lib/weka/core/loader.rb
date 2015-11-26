require 'weka/core/converters'

module Weka
  module Core
    class Loader
      java_import 'java.io.File'

      class << self
        def load_arff(file)
          load_with(Converters::ArffLoader, file: file)
        end

        def load_csv(file)
          load_with(Converters::CSVLoader, file: file)
        end

        def load_json(file)
          load_with(Converters::JSONLoader, file: file)
        end

        private

        def load_with(loader_class, file:)
          loader        = loader_class.new
          loader.source = File.new(file)
          loader.data_set
        end
      end
    end

  end
end
