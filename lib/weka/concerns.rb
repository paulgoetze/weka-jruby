require 'active_support/concern'
require 'weka/concerns/buildable'
require 'weka/concerns/describable'
require 'weka/concerns/optionizable'
require 'weka/concerns/persistent'

module Weka
  module Concerns
    extend ActiveSupport::Concern

    included do
      include Buildable
      include Describable
      include Optionizable
      include Persistent
    end
  end
end
