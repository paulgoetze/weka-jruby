module Weka
  class Error < StandardError; end

  class UnassignedClassError < Error; end
  class UnassignedTrainingInstancesError < Error; end
end
