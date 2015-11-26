require 'weka/class_builder'

module Weka
  module Core
    module Converters
      include ClassBuilder

      java_import 'java.io.File'

      build_classes :ArffLoader,
                    :ArffSaver,
                    :CSVLoader,
                    :CSVSaver,
                    :JSONLoader,
                    :JSONSaver
    end
  end
end
