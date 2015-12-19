require 'weka/attribute_selection/evaluator'
require 'weka/attribute_selection/search'

module Weka
  module AttributeSelection
    java_import 'weka.attributeSelection.AttributeSelection'

    class AttributeSelection

      alias :summary :to_results_string
      alias :selected_attributes_count :number_attributes_selected
    end
  end
end
