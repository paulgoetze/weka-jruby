require 'weka/class_builder'

module Weka
  module AttributeSelection
    module Evaluator
      include ClassBuilder

      build_classes :CfsSubsetEval,
                    :CorrelationAttributeEval,
                    :GainRatioAttributeEval,
                    :InfoGainAttributeEval,
                    :OneRAttributeEval,
                    :ReliefFAttributeEval,
                    :SymmetricalUncertAttributeEval,
                    :WrapperSubsetEval,
                    weka_module: 'weka.attributeSelection'

      class CfsSubset                  < CfsSubsetEval; end
      class CorrelationAttribute       < CorrelationAttributeEval; end
      class GainRatioAttribute         < GainRatioAttributeEval; end
      class InfoGainAttribute          < InfoGainAttributeEval; end
      class OneRAttribute              < OneRAttributeEval; end
      class ReliefFAttribute           < ReliefFAttributeEval; end
      class SymmetricalUncertAttribute < SymmetricalUncertAttributeEval; end
      class WrapperSubset              < WrapperSubsetEval; end
    end
  end
end
