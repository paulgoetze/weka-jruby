module Weka
  class Error < StandardError; end

  class UnassignedClassError < Error; end
  class UnassignedTrainingInstancesError < Error; end
  class MissingInstancesStructureError < Error; end
  class InvalidInstancesStructureError < Error; end
end
