require 'java'
require 'weka/jars'
require 'weka/version'

module Weka
  include Jars

  def self.require_all(type)
    files = Dir[File.expand_path("../weka/#{type}/**/*.rb", __FILE__)]
    files.each { |file| require file }
  end
end

require 'weka/core'
require 'weka/classifiers'
require 'weka/filters'
require 'weka/clusterers'
