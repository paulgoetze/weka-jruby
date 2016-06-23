require 'weka/concerns/buildable'
require 'weka/concerns/describable'
require 'weka/concerns/optionizable'
require 'weka/concerns/persistent'
require 'weka/concerns/serializable'

module Weka
  module Concerns
    def self.included(base)
      base.include Buildable
      base.include Describable
      base.include Optionizable
      base.include Persistent
    end
  end
end
