require 'java'
require 'weka/jars'
require 'weka/version'
require 'weka/exceptions'

module Weka
  include Jars

  class << self
    def require_all(type)
      files        = Dir[File.expand_path("../weka/#{type}/**/*.rb", __FILE__)]
      utils        = File.expand_path("../weka/#{type}/utils.rb", __FILE__)
      sorted_files = move_to_head(utils, files)

      sorted_files.each { |file| require file }
    end

    private

    def move_to_head(file, files)
      file_to_move = files.delete(file)
      files.unshift(file_to_move) unless file_to_move.nil?
      files
    end
  end
end

require 'weka/core'
require 'weka/classifiers'
require 'weka/filters'
require 'weka/clusterers'
require 'weka/attribute_selection'
