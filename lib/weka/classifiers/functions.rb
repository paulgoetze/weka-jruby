require 'weka/class_builder'

module Weka
  module Classifiers
    module Functions
      include ClassBuilder

      build_classes :GaussianProcesses,
                    :LinearRegression,
                    :Logistic,
                    :MultilayerPerceptron,
                    :SGD,
                    :SGDText,
                    :SimpleLinearRegression,
                    :SimpleLogistic,
                    :SMO,
                    :SMOreg,
                    :VotedPerceptron
    end
  end
end
