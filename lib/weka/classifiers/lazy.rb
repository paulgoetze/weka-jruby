require 'weka/class_builder'

module Weka
  module Classifiers
    module Lazy
      include ClassBuilder

      build_classes :IBk,
                    :KStar,
                    :LWL
    end
  end
end
