require 'weka/class_builder'

module Weka
  module Core
    module Converters
      include ClassBuilder

      build_classes :ArffLoader,
                    :ArffSaver,
                    :CSVLoader,
                    :CSVSaver,
                    :JSONLoader,
                    :JSONSaver,
                    :C45Loader,
                    :C45Saver,
                    include_concerns: false
    end
  end
end
